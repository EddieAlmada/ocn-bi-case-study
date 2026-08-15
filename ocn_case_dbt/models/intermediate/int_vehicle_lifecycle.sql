with vehicles as (

    select *
    from {{ ref('stg_db_stock_vehicles__ocn_sources') }}

),

events as (

    select *
    from {{ ref('int_vehicle_events') }}

),

event_dates as (

    select
        vin,

        min(
            case
                when event_type = 'vehicle_created'
                then event_at
            end
        ) as first_vehicle_created_at,

        min(
            case
                when event_type = 'gps_installed'
                then event_at
            end
        ) as first_gps_installed_at,

        min(
            case
                when event_type = 'vehicle_ready'
                then event_at
            end
        ) as first_vehicle_ready_at,

        min(
            case
                when event_type = 'driver_assigned'
                then event_at
            end
        ) as first_driver_assigned_at,

        min(
            case
                when event_type = 'vehicle_delivered'
                then event_at
            end
        ) as first_vehicle_delivered_at,

        min(
            case
                when event_type = 'sent_to_workshop'
                then event_at
            end
        ) as first_workshop_at,

        min(
            case
                when event_type = 'sent_to_service'
                then event_at
            end
        ) as first_service_at,

        min(
            case
                when event_type = 'returned_to_stock'
                then event_at
            end
        ) as first_returned_to_stock_at

    from events

    group by vin

),

vehicle_lifecycle as (

    select
        vehicles.stock_vehicles_id,
        vehicles.vin,
        vehicles.contract_number,

        vehicles.brand,
        vehicles.model,

        vehicles.status,
        vehicles.physical_status,
        vehicles.category,
        vehicles.sub_category,
        vehicles.created_at,
        vehicles.updated_at,
        vehicles.reception_date,
        vehicles.delivered_date,
        vehicles.readmission_date,

        event_dates.first_vehicle_created_at,
        event_dates.first_gps_installed_at,
        event_dates.first_vehicle_ready_at,
        event_dates.first_driver_assigned_at,
        event_dates.first_vehicle_delivered_at,
        event_dates.first_workshop_at,
        event_dates.first_service_at,
        event_dates.first_returned_to_stock_at,

        coalesce(
            event_dates.first_driver_assigned_at,
            vehicles.delivered_date
        ) as resolved_driver_assignment_at,

        case
            when event_dates.first_driver_assigned_at is not null then 'driver_assigned_event'
            when vehicles.delivered_date is not null then 'delivered_date_fallback'
            else 'missing'
        end as driver_assignment_timestamp_source,

        case
            when vehicles.delivered_date is not null
             and event_dates.first_driver_assigned_at is not null
             and cast(vehicles.delivered_date as date)
                 <> cast(event_dates.first_driver_assigned_at as date)
            then true
            else false
        end as has_delivery_assignment_timestamp_conflict,

        case
            when vehicles.delivered_date is not null
             and event_dates.first_driver_assigned_at is not null
            then datediff(
                day,
                vehicles.delivered_date,
                event_dates.first_driver_assigned_at
            )
        end as delivery_assignment_day_difference,

        case
            when vehicles.reception_date is not null
             and event_dates.first_vehicle_ready_at is not null
            then datediff(
                day,
                vehicles.reception_date,
                event_dates.first_vehicle_ready_at
            )
        end as days_reception_to_ready,

        case
            when vehicles.reception_date is not null
             and coalesce(
                 event_dates.first_driver_assigned_at,
                 vehicles.delivered_date
             ) is not null
            then datediff(
                day,
                vehicles.reception_date,
                coalesce(
                    event_dates.first_driver_assigned_at,
                    vehicles.delivered_date
                )
            )
        end as days_reception_to_driver_assignment,

        case
            when event_dates.first_gps_installed_at is not null
             and coalesce(
                 event_dates.first_driver_assigned_at,
                 vehicles.delivered_date
             ) is not null
            then datediff(
                day,
                event_dates.first_gps_installed_at,
                coalesce(
                    event_dates.first_driver_assigned_at,
                    vehicles.delivered_date
                )
            )
        end as days_gps_to_driver_assignment

    from vehicles

    left join event_dates
        on vehicles.vin = event_dates.vin

),

final as (

    select *
    from vehicle_lifecycle

)

select *
from final
