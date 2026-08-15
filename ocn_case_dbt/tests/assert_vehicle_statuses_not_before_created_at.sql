{{ config(severity='warn') }}

select
    transitions.vehicle_status_transition_id,
    transitions.vin,
    vehicles.created_at as vehicle_created_at,
    transitions.date_in,
    transitions.created_at as status_created_at
from {{ ref('int_vehicle_status_transitions') }} as transitions
inner join {{ ref('stg_db_stock_vehicles__ocn_sources') }} as vehicles
    on transitions.vin = vehicles.vin
where vehicles.created_at is not null
  and coalesce(transitions.date_in, transitions.created_at) is not null
  and coalesce(transitions.date_in, transitions.created_at) < vehicles.created_at
