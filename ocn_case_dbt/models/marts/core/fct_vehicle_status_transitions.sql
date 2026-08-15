with transitions as (

    select *
    from {{ ref('int_vehicle_status_transitions') }}

),

final as (

    select
        *,
        cast(created_at as date) as transition_date,
        concat(
            coalesce(regexp_replace(lower(trim(previous_status)), '[^a-z0-9]+', '_'), 'unknown'),
            '_to_',
            coalesce(regexp_replace(lower(trim(status)), '[^a-z0-9]+', '_'), 'unknown')
        ) as status_transition,
        concat(
            coalesce(standardized_previous_category, 'unknown'),
            '_to_',
            coalesce(standardized_category, 'unknown')
        ) as category_transition,
        case
            when date_out is null then true
            else false
        end as is_open_transition

    from transitions

)

select *
from final
