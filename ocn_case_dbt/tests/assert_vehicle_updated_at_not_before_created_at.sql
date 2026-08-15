{{ config(severity='warn') }}

select
    stock_vehicles_id,
    vin,
    created_at,
    updated_at
from {{ ref('stg_db_stock_vehicles__ocn_sources') }}
where created_at is not null
  and updated_at is not null
  and updated_at < created_at
