with source as (

    select *
    from {{ ref('stg_db_dpd_history__ocn_sources') }}

),

payment_status as (

    select
        business_date,
        contract_number,
        vin,
        dpd,
        last_payment_received_date,

        case
            when dpd is null then null
            when dpd > 0 then true
            else false
        end as is_past_due,

        case
            when dpd is null then null
            when dpd > 7 then true
            else false
        end as is_over_7_days_past_due,

        case
            when dpd is null then 'unknown'
            when dpd = 0 then 'current'
            when dpd between 1 and 7 then '1_7_days'
            when dpd between 8 and 30 then '8_30_days'
            when dpd > 30 then '30_plus_days'
        end as dpd_bucket

    from source

),

final as (

    select *
    from payment_status

)

select *
from final
