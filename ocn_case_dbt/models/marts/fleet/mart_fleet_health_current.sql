with vehicles as (

    select *
    from {{ ref('dim_vehicle') }}

),

status_transitions as (

    select *
    from {{ ref('fct_vehicle_status_transitions') }}

),

latest_status as (

    select
        vin,
        status,
        standardized_category,
        standardized_sub_category,
        associate_id,
        date_in as current_status_started_at

    from status_transitions

    where date_in <= current_timestamp()
      and (
          date_out is null
          or date_out >= current_timestamp()
      )

    qualify row_number() over (
        partition by vin
        order by date_in desc nulls last, created_at desc nulls last,
            vehicle_status_transition_id desc
    ) = 1

),

current_vehicle_state as (

    select
        vehicles.stock_vehicles_id,
        vehicles.vin,
        vehicles.contract_number,
        vehicles.brand,
        vehicles.model,
        vehicles.version,
        vehicles.year,
        vehicles.is_electric,
        vehicles.platform,
        vehicles.country,
        vehicles.state,
        vehicles.state_name,
        vehicles.vehicle_state,
        coalesce(latest_status.status, vehicles.status) as current_status,
        vehicles.physical_status,
        coalesce(
            latest_status.standardized_category,
            vehicles.standardized_category
        ) as current_standardized_category,
        coalesce(
            latest_status.standardized_sub_category,
            vehicles.standardized_sub_category
        ) as current_standardized_sub_category,
        coalesce(latest_status.associate_id, vehicles.last_driver_id) as current_driver_id,
        latest_status.current_status_started_at,
        vehicles.reception_date,
        vehicles.delivered_date,
        vehicles.created_at,
        vehicles.updated_at,
        regexp_replace(
            lower(trim(coalesce(latest_status.status, vehicles.status))),
            '[^a-z0-9]+',
            '_'
        ) as normalized_current_status

    from vehicles

    left join latest_status
        on vehicles.vin = latest_status.vin

),

classified as (

    select
        *,
        case
            when normalized_current_status like '%withdrawn%'
              or normalized_current_status like '%baja%'
              or current_standardized_category = 'withdrawn'
              or current_standardized_sub_category = 'withdrawn'
                then 'withdrawn'

            when normalized_current_status like '%workshop%'
              or normalized_current_status like '%taller%'
              or normalized_current_status like '%maintenance%'
              or current_standardized_category in ('workshop', 'in_maintenance')
              or current_standardized_sub_category in ('workshop', 'in_maintenance')
                then 'workshop'

            when current_driver_id is not null
              or normalized_current_status like '%assigned%'
              or normalized_current_status like '%asignado%'
                then 'active'

            else 'idle'
        end as fleet_composition,
        datediff(
            day,
            cast(coalesce(reception_date, created_at) as date),
            current_date()
        ) as days_in_inventory,
        datediff(
            day,
            cast(current_status_started_at as date),
            current_date()
        ) as days_in_current_status

    from current_vehicle_state

)

select
    *,
    current_timestamp() as dbt_updated_at
from classified
