with source as (

    select *
    from {{ ref('stg_db_stock_update_history__ocn_sources') }}

),

classified_events as (

    select
        history_id,
        vin,
        contract,
        step,
        time as event_at,
        user_id,
        description,

        case

            when step = 'VEHICULO CREADO'
                then 'vehicle_created'

            when step = 'GPS instalado'
                then 'gps_installed'

            when step = 'CONDUCTOR ASIGNADO'
                then 'driver_assigned'

            when step in (
                'VEHICULO ENTREGADO',
                'Entregado',
                'VEHICULO ENVIADO A ENTREGADO'
            )
                then 'vehicle_delivered'

            when step = 'Vehiculo enviado a stock'
                then 'sent_to_stock'

            when step = 'VEHICULO REINGRESADO A STOCK'
                then 'returned_to_stock'

            when step in (
                'Vehiculo Regresado a listo',
                'Vehiculo listo'
            )
                then 'vehicle_ready'

            when step = 'VEHICULO ENVIADO A TALLER'
                then 'sent_to_workshop'

            when step = 'VEHICULO ENVIADO A SERVICIO'
                then 'sent_to_service'

            when step = 'VEHICULO ENVIADO A PROCESO LEGAL'
                then 'sent_to_legal'

            when step in (
                'VEHICULO ENVIADO A ESPERA DE SEGURO',
                'VEHICULO ENVIADO A ESPERO DE SEGURO'
            )
                then 'awaiting_insurance'

            when step = 'VEHICULO ENVIADO A PROCESO GESTORIAS'
                then 'sent_to_gestorias'

            when step = 'VEHICULO DADO DE BAJA'
                then 'vehicle_withdrawn'

            when step = 'VEHICULO ENVIADO A VENDIDO'
                then 'vehicle_sold'

            else 'other'

        end as event_type

    from source

),

final as (

    select *
    from classified_events

)

select *
from final