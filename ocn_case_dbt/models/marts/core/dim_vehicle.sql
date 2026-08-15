with vehicles as (

    select *
    from {{ ref('stg_db_stock_vehicles__ocn_sources') }}

),

lifecycle as (

    select *
    from {{ ref('int_vehicle_lifecycle') }}

),

final as (

    select
        vehicles.stock_vehicles_id,
        vehicles.vin,
        vehicles.contract_number,
        vehicles.contract,
        vehicles.brand,
        vehicles.model,
        vehicles.version,
        vehicles.year,
        vehicles.color,
        vehicles.is_electric,
        vehicles.platform,
        vehicles.country,
        vehicles.state_name,
        vehicles.status,
        vehicles.physical_status,
        vehicles.standardized_category,
        vehicles.standardized_sub_category,
        vehicles.step,
        vehicles.owner,
        vehicles.last_driver_id,
        vehicles.gps_installed,
        vehicles.ready_to_deliver,
        vehicles.vehicle_docs_complete,
        vehicles.vehicle_physically_received,
        vehicles.created_at,
        vehicles.updated_at,
        vehicles.reception_date,
        vehicles.delivered_date,
        vehicles.readmission_date,
        lifecycle.first_vehicle_created_at,
        lifecycle.first_gps_installed_at,
        lifecycle.first_vehicle_ready_at,
        lifecycle.first_driver_assigned_at,
        lifecycle.first_vehicle_delivered_at,
        lifecycle.first_workshop_at,
        lifecycle.first_service_at,
        lifecycle.first_returned_to_stock_at,
        lifecycle.resolved_driver_assignment_at,
        lifecycle.driver_assignment_timestamp_source,
        lifecycle.has_delivery_assignment_timestamp_conflict,
        lifecycle.delivery_assignment_day_difference,
        lifecycle.days_reception_to_ready,
        lifecycle.days_reception_to_driver_assignment,
        lifecycle.days_gps_to_driver_assignment,
        regexp_replace(lower(trim(vehicles.status)), '[^a-z0-9]+', '_') as normalized_status

    from vehicles

    left join lifecycle
        on vehicles.stock_vehicles_id = lifecycle.stock_vehicles_id

)

select *
from final
