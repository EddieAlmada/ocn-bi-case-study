with snapshots as (

    select *
    from {{ ref('fct_vehicle_daily_snapshot') }}

),

events as (

    select *
    from {{ ref('fct_vehicle_events') }}

),

vehicles as (

    select *
    from {{ ref('dim_vehicle') }}

),

daily_stock as (

    select
        date_trunc('month', snapshot_date) as month,
        snapshot_date,
        country,
        state_name,
        count(*) as vehicles_in_stock

    from snapshots

    where not is_assigned
      and not is_withdrawn

    group by
        date_trunc('month', snapshot_date),
        snapshot_date,
        country,
        state_name

),

monthly_stock as (

    select
        month,
        country,
        state_name,
        avg(vehicles_in_stock) as avg_monthly_stock

    from daily_stock

    group by month, country, state_name

),

monthly_assignments as (

    select
        date_trunc('month', events.event_date) as month,
        vehicles.country,
        vehicles.state_name,
        count(distinct events.vin) as assigned_vehicles

    from events

    left join vehicles
        on events.vin = vehicles.vin

    where events.event_type = 'driver_assigned'

    group by
        date_trunc('month', events.event_date),
        vehicles.country,
        vehicles.state_name

),

final as (

    select
        coalesce(monthly_stock.month, monthly_assignments.month) as month,
        coalesce(monthly_stock.country, monthly_assignments.country) as country,
        coalesce(monthly_stock.state_name, monthly_assignments.state_name) as state_name,
        coalesce(monthly_assignments.assigned_vehicles, 0) as assigned_vehicles,
        coalesce(monthly_stock.avg_monthly_stock, 0) as avg_monthly_stock,
        case
            when monthly_stock.avg_monthly_stock > 0
            then monthly_assignments.assigned_vehicles / cast(monthly_stock.avg_monthly_stock as double)
        end as inventory_turnover_rate

    from monthly_stock

    full outer join monthly_assignments
        on monthly_stock.month = monthly_assignments.month
        and monthly_stock.country <=> monthly_assignments.country
        and monthly_stock.state_name <=> monthly_assignments.state_name

)

select *
from final
