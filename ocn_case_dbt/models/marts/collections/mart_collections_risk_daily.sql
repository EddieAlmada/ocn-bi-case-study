with payments as (

    select *
    from {{ ref('fct_vehicle_payment_daily') }}

),

snapshots as (

    select *
    from {{ ref('fct_vehicle_daily_snapshot') }}

),

vehicles as (

    select *
    from {{ ref('dim_vehicle') }}

),

final as (

    select
        payments.business_date,
        payments.contract_number,
        payments.vin,
        vehicles.brand,
        vehicles.model,
        vehicles.country,
        vehicles.state,
        snapshots.status,
        snapshots.category,
        snapshots.sub_category,
        snapshots.days_in_inventory,
        snapshots.days_in_current_status,
        snapshots.is_unproductive,
        payments.dpd,
        payments.previous_dpd,
        payments.dpd_change,
        payments.last_payment_received_date,
        payments.days_since_last_payment,
        payments.is_past_due,
        payments.is_over_7_days_past_due,
        payments.dpd_bucket,
        payments.operational_risk_level,
        case
            when payments.dpd > 30 then true
            when payments.dpd > 7 and snapshots.is_unproductive then true
            when payments.dpd > 7 and snapshots.days_in_current_status > 15 then true
            else false
        end as is_early_warning,
        case
            when payments.dpd > 30 then 'over_30_days_past_due'
            when payments.dpd > 7 and snapshots.is_unproductive then 'past_due_and_unproductive'
            when payments.dpd > 7 and snapshots.days_in_current_status > 15 then 'past_due_and_prolonged_status'
            when payments.dpd > 7 then 'over_7_days_past_due'
        end as risk_reason

    from payments

    left join snapshots
        on payments.business_date = snapshots.snapshot_date
        and payments.vin = snapshots.vin
        and payments.contract_number = snapshots.contract_number

    left join vehicles
        on payments.vin = vehicles.vin

)

select *
from final
