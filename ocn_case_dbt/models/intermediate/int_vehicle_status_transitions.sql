with source as (

    select *
    from {{ ref('stg_db_stock_vehicles_status_histories__ocn_sources') }}

),

valid_status_records as (

    select
        stock_vehicle_status_histories_id,
        vin,
        contract_number,

        previous_status,
        status,

        previous_category,
        category,

        previous_sub_category,
        sub_category,

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
       or category is not null
       or previous_category is not null

),

status_transitions as (

    select
        *,

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
            when previous_category is distinct from category
            then true
            else false
        end as is_category_change

    from valid_status_records

),

final as (

    select *
    from status_transitions

)

select *
from final