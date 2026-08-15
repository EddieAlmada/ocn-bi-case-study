with source as (

    select *
    from {{ ref('stg_db_stock_vehicles_status_histories__ocn_sources') }}

),

valid_status_records as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'stock_vehicle_status_histories_id',
            'vin',
            'contract_number',
            'created_at',
            'date_in',
            'date_out',
            'previous_status',
            'status',
            'previous_category',
            'category',
            'previous_sub_category',
            'sub_category',
            'previous_step',
            'step',
            'userid'
        ]) }} as vehicle_status_transition_id,
        stock_vehicle_status_histories_id,
        vin,
        contract_number,

        previous_status,
        status,

        standardized_previous_category,
        standardized_category,

        standardized_previous_sub_category,
        standardized_sub_category,

        previous_step,
        step,

        date_in,
        date_out,
        created_at,

        is_canceled,
        is_completed,

        associate_id,
        userid

    from source

    where status is not null
       or previous_status is not null
       or standardized_category is not null
       or standardized_previous_category is not null

),

deduplicated_status_records as (

    select *
    from valid_status_records
    qualify row_number() over (
        partition by vehicle_status_transition_id
        order by created_at desc, date_in desc
    ) = 1

),

status_transitions as (

    select
        *,

        regexp_replace(lower(trim(status)), '[^a-z0-9]+', '_') as normalized_status,
        regexp_replace(lower(trim(previous_status)), '[^a-z0-9]+', '_') as normalized_previous_status,

        case
            when date_in is not null
             and date_out is not null
             and date_out < date_in
            then true
            else false
        end as has_invalid_date_range,

        case
            when date_in is not null
             and date_out is not null
             and date_out >= date_in
            then datediff(day, date_in, date_out)
        end as days_in_status,

        case
            when previous_status is distinct from status
            then true
            else false
        end as is_status_change,

        case
            when standardized_previous_category is distinct from standardized_category
            then true
            else false
        end as is_category_change

    from deduplicated_status_records

),

final as (

    select *
    from status_transitions

)

select *
from final
