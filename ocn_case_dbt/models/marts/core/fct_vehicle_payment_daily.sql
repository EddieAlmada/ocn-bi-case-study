with payments as (

    select *
    from {{ ref('int_vehicle_payment_status') }}

),

with_previous as (

    select
        *,
        lag(dpd) over (
            partition by vin, contract_number
            order by business_date
        ) as previous_dpd

    from payments

),

final as (

    select
        *,
        dpd - previous_dpd as dpd_change,
        case
            when last_payment_received_date is not null
            then datediff(day, last_payment_received_date, business_date)
        end as days_since_last_payment,
        case
            when dpd > 30 then 'critical'
            when dpd > 7 then 'high'
            when dpd > 0 then 'medium'
            when dpd = 0 then 'current'
            else 'unknown'
        end as operational_risk_level

    from with_previous

)

select *
from final
