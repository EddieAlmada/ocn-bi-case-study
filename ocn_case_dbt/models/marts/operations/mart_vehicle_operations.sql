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
        sum(case when normalized_category = 'workshop' or normalized_category = 'taller' then 1 else 0 end) as workshop_entry_count,
        sum(case when normalized_category = 'workshop' or normalized_category = 'taller' then days_in_status else 0 end) as total_days_in_workshop,
        max(created_at) as last_transition_at,
        max_by(status_transition, created_at) as last_status_transition

    from (
        select
            *,
            regexp_replace(lower(trim(category)), '[^a-z0-9]+', '_') as normalized_category
        from {{ ref('fct_vehicle_status_transitions') }}
    )

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
        vehicles.state,
        vehicles.vehicle_state,
        latest_snapshot.status,
        latest_snapshot.category,
        latest_snapshot.sub_category,
        latest_snapshot.days_in_inventory,
        latest_snapshot.days_in_current_status,
        latest_snapshot.is_assigned,
        latest_snapshot.is_unproductive,
        latest_snapshot.is_over_45_days_in_stock,
        vehicles.days_reception_to_ready,
        vehicles.days_reception_to_driver_assignment,
        vehicles.days_gps_to_driver_assignment,
        coalesce(transition_metrics.transition_count, 0) as transition_count,
        coalesce(transition_metrics.workshop_entry_count, 0) as workshop_entry_count,
        coalesce(transition_metrics.total_days_in_workshop, 0) as total_days_in_workshop,
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
