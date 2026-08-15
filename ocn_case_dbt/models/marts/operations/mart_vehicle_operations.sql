with vehicles as (

    select *
    from {{ ref('dim_vehicle') }}

),

latest_snapshot as (

    select *
    from {{ ref('fct_vehicle_daily_snapshot') }}
    qualify row_number() over (
        partition by vin
        order by snapshot_date desc
    ) = 1

),

transitions as (

    select *
    from {{ ref('fct_vehicle_status_transitions') }}

),

transition_metrics as (

    select
        vin,
        count(*) as transition_count,
        sum(
            case
                when standardized_category in ('workshop', 'in_maintenance')
                then 1 else 0
            end
        ) as workshop_visit_count,
        max(created_at) as last_transition_at,
        max_by(status_transition, created_at) as last_status_transition

    from transitions

    group by vin

),

valid_transitions as (

    select *
    from transitions
    where date_in is not null
      and year(date_in) between 2000 and year(current_date()) + 1

),

workshop_visits as (

    select
        workshop.vehicle_status_transition_id,
        workshop.vin,
        workshop.date_in as workshop_started_at,
        case
            when workshop.date_out > workshop.date_in
             and year(workshop.date_out) between 2000 and year(current_date()) + 1
                then workshop.date_out
            when workshop.is_completed
                then min(next_status.date_in)
        end as resolved_workshop_ended_at,
        case
            when workshop.date_out > workshop.date_in
             and year(workshop.date_out) between 2000 and year(current_date()) + 1
                then 'date_out'
            when workshop.is_completed
             and min(next_status.date_in) is not null
                then 'next_non_workshop_transition'
            else 'missing'
        end as workshop_exit_source

    from valid_transitions as workshop

    left join valid_transitions as next_status
        on workshop.vin = next_status.vin
        and next_status.date_in > workshop.date_in
        and coalesce(next_status.standardized_category, 'unknown')
            not in ('workshop', 'in_maintenance')

    where workshop.standardized_category in ('workshop', 'in_maintenance')

    group by
        workshop.vehicle_status_transition_id,
        workshop.vin,
        workshop.date_in,
        workshop.date_out,
        workshop.is_completed

),

workshop_metrics as (

    select
        vin,
        count_if(resolved_workshop_ended_at is not null) as completed_workshop_visit_count,
        sum(
            case
                when resolved_workshop_ended_at is not null
                then datediff(day, workshop_started_at, resolved_workshop_ended_at)
                else 0
            end
        ) as completed_workshop_days,
        count_if(
            workshop_exit_source = 'next_non_workshop_transition'
        ) as inferred_workshop_visit_count

    from workshop_visits

    group by vin

),

final as (

    select
        vehicles.stock_vehicles_id,
        vehicles.vin,
        vehicles.contract_number,
        vehicles.brand,
        vehicles.model,
        vehicles.country,
        coalesce(vehicles.state_name, 'Unknown') as park_name,
        latest_snapshot.status,
        latest_snapshot.standardized_category,
        latest_snapshot.standardized_sub_category,
        latest_snapshot.days_in_inventory,
        latest_snapshot.days_in_current_status,
        latest_snapshot.is_assigned,
        latest_snapshot.is_workshop,
        latest_snapshot.is_withdrawn,
        not coalesce(latest_snapshot.is_withdrawn, false) as is_inventory_vehicle,
        latest_snapshot.is_unproductive,
        latest_snapshot.is_over_45_days_in_stock,
        vehicles.days_reception_to_ready,
        vehicles.days_reception_to_driver_assignment,
        vehicles.first_gps_installed_at,
        vehicles.resolved_driver_assignment_at,
        vehicles.days_gps_to_driver_assignment as gps_to_driver_assignment_days,
        vehicles.driver_assignment_timestamp_source,
        vehicles.has_delivery_assignment_timestamp_conflict,
        vehicles.delivery_assignment_day_difference,
        coalesce(transition_metrics.transition_count, 0) as transition_count,
        coalesce(transition_metrics.workshop_visit_count, 0) as workshop_visit_count,
        coalesce(workshop_metrics.completed_workshop_visit_count, 0) as completed_workshop_visit_count,
        coalesce(workshop_metrics.completed_workshop_days, 0) as completed_workshop_days,
        coalesce(workshop_metrics.inferred_workshop_visit_count, 0) as inferred_workshop_visit_count,
        try_divide(
            workshop_metrics.completed_workshop_days,
            workshop_metrics.completed_workshop_visit_count
        ) as workshop_turnaround_days,
        case
            when latest_snapshot.is_workshop
            then latest_snapshot.days_in_current_status
        end as current_workshop_age_days,
        transition_metrics.last_transition_at,
        transition_metrics.last_status_transition,
        case
            when latest_snapshot.is_over_45_days_in_stock then 'over_45_days_in_stock'
            when latest_snapshot.is_workshop and latest_snapshot.days_in_current_status > 15 then 'prolonged_workshop'
            when latest_snapshot.is_unproductive then 'unproductive_vehicle'
        end as operational_alert_reason

    from vehicles

    left join latest_snapshot
        on vehicles.vin = latest_snapshot.vin

    left join transition_metrics
        on vehicles.vin = transition_metrics.vin

    left join workshop_metrics
        on vehicles.vin = workshop_metrics.vin

)

select *
from final
