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
        sum(
            case
                when standardized_category in ('workshop', 'in_maintenance')
                 and days_in_status is not null
                then 1 else 0
            end
        ) as completed_workshop_visit_count,
        sum(
            case
                when standardized_category in ('workshop', 'in_maintenance')
                then days_in_status else 0
            end
        ) as completed_workshop_days,
        max(created_at) as last_transition_at,
        max_by(status_transition, created_at) as last_status_transition

    from {{ ref('fct_vehicle_status_transitions') }}

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
        coalesce(vehicles.state_name, vehicles.state, 'Unknown') as park_name,
        vehicles.vehicle_state,
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
        coalesce(transition_metrics.completed_workshop_visit_count, 0) as completed_workshop_visit_count,
        coalesce(transition_metrics.completed_workshop_days, 0) as completed_workshop_days,
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

)

select *
from final
