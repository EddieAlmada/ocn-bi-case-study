{{ config(severity='warn') }}

select
    events.vehicle_event_id,
    events.vin,
    vehicles.created_at as vehicle_created_at,
    events.event_at
from {{ ref('int_vehicle_events') }} as events
inner join {{ ref('stg_db_stock_vehicles__ocn_sources') }} as vehicles
    on events.vin = vehicles.vin
where vehicles.created_at is not null
  and events.event_at is not null
  and events.event_at < vehicles.created_at
