with source as (

    select *
    from {{ ref('stg_db_stock_update_history__ocn_sources') }}

),

normalized_events as (

    select
        *,
        upper(trim(step)) as normalized_step,
        {{ dbt_utils.generate_surrogate_key([
            'history_id',
            'vin',
            'contract',
            'time',
            'step',
            'user_id',
            'description'
        ]) }} as vehicle_event_id
    from source

),

deduplicated_events as (

    select *
    from normalized_events
    qualify row_number() over (
        partition by vehicle_event_id
        order by time desc
    ) = 1

),

classified_events as (

    select
        vehicle_event_id,
        history_id,
        vin,
        contract,
        step,
        time as event_at,
        user_id,
        description,

        case

            when normalized_step = 'VEHICULO CREADO'
                then 'vehicle_created'

            when normalized_step = 'GPS INSTALADO'
                then 'gps_installed'

            when normalized_step = 'CONDUCTOR ASIGNADO'
                then 'driver_assigned'

            when normalized_step in (
                'VEHICULO ENTREGADO',
                'ENTREGADO',
                'VEHICULO ENVIADO A ENTREGADO'
            )
                then 'vehicle_delivered'

            when normalized_step = 'VEHICULO ENVIADO A STOCK'
                then 'sent_to_stock'

            when normalized_step = 'VEHICULO REINGRESADO A STOCK'
                then 'returned_to_stock'

            when normalized_step in (
                'VEHICULO REGRESADO A LISTO',
                'VEHICULO LISTO'
            )
                then 'vehicle_ready'

            when normalized_step = 'VEHICULO ENVIADO A TALLER'
                then 'sent_to_workshop'

            when normalized_step = 'VEHICULO ENVIADO A SERVICIO'
                then 'sent_to_service'

            when normalized_step = 'VEHICULO ENVIADO A PROCESO LEGAL'
                then 'sent_to_legal'

            when normalized_step in (
                'VEHICULO ENVIADO A ESPERA DE SEGURO',
                'VEHICULO ENVIADO A ESPERO DE SEGURO'
            )
                then 'awaiting_insurance'

            when normalized_step = 'VEHICULO ENVIADO A PROCESO GESTORIAS'
                then 'sent_to_gestorias'

            when normalized_step = 'VEHICULO DADO DE BAJA'
                then 'vehicle_withdrawn'

            when normalized_step = 'VEHICULO ENVIADO A VENDIDO'
                then 'vehicle_sold'

            else 'other'

        end as event_type

    from deduplicated_events

),

final as (

    select *
    from classified_events

)

select *
from final
