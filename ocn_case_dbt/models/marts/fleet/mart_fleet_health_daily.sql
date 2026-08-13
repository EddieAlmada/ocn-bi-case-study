with snapshots as (

    select *
    from {{ ref('fct_vehicle_daily_snapshot') }}

),

final as (

    select
        snapshot_date,
        country,
        state,
        vehicle_state,
        status,
        category,
        brand,
        model,
        count(*) as total_vehicles,
        sum(case when is_assigned then 1 else 0 end) as assigned_vehicles,
        sum(case when is_idle then 1 else 0 end) as idle_vehicles,
        sum(case when is_workshop then 1 else 0 end) as workshop_vehicles,
        sum(case when is_withdrawn then 1 else 0 end) as withdrawn_vehicles,
        sum(case when is_unproductive then 1 else 0 end) as unproductive_vehicles,
        sum(case when is_over_45_days_in_stock then 1 else 0 end) as vehicles_over_45_days_in_stock,
        avg(days_in_inventory) as avg_days_in_inventory,
        percentile_approx(days_in_inventory, 0.5) as median_days_in_inventory,
        sum(case when is_unproductive then 1 else 0 end) / cast(count(*) as double) as unproductive_fleet_rate

    from snapshots

    group by
        snapshot_date,
        country,
        state,
        vehicle_state,
        status,
        category,
        brand,
        model

)

select *
from final
