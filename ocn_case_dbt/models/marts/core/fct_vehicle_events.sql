with events as (

    select *
    from {{ ref('int_vehicle_events') }}

),

sequenced as (

    select
        vehicle_event_id,
        history_id,
        vin,
        contract,
        step,
        event_at,
        cast(event_at as date) as event_date,
        date_trunc('month', event_at) as event_month,
        user_id,
        description,
        event_type,
        row_number() over (
            partition by vin
            order by event_at, vehicle_event_id
        ) as event_sequence,
        lag(event_type) over (
            partition by vin
            order by event_at, vehicle_event_id
        ) as previous_event_type,
        lag(event_at) over (
            partition by vin
            order by event_at, vehicle_event_id
        ) as previous_event_at

    from events

),

final as (

    select
        *,
        case
            when previous_event_at is not null
            then datediff(day, previous_event_at, event_at)
        end as days_since_previous_event

    from sequenced

)

select *
from final
