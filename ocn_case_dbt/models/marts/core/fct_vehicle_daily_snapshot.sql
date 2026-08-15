with vehicles as (

    select *
    from {{ ref('dim_vehicle') }}

),

payments as (

    select *
    from {{ ref('fct_vehicle_payment_daily') }}

),

status_history as (

    select *
    from {{ ref('fct_vehicle_status_transitions') }}

),

date_bounds as (

    select
        min(business_date) as min_date,
        greatest(max(business_date), current_date()) as max_date
    from payments

),

date_spine as (

    select explode(sequence(min_date, max_date, interval 1 day)) as snapshot_date
    from date_bounds

),

vehicle_dates as (

    select
        date_spine.snapshot_date,
        vehicles.*

    from date_spine

    cross join vehicles

    where date_spine.snapshot_date >= cast(
        coalesce(vehicles.reception_date, vehicles.created_at) as date
    )

),

status_as_of_date as (

    select
        vehicle_dates.snapshot_date,
        vehicle_dates.vin,
        status_history.status as historical_status,
        status_history.standardized_category as historical_standardized_category,
        status_history.standardized_sub_category as historical_standardized_sub_category,
        status_history.associate_id,
        status_history.date_in as status_date_in,
        row_number() over (
            partition by vehicle_dates.snapshot_date, vehicle_dates.vin
            order by status_history.date_in desc, status_history.created_at desc
        ) as status_record_rank

    from vehicle_dates

    left join status_history
        on vehicle_dates.vin = status_history.vin
        and vehicle_dates.snapshot_date >= cast(status_history.date_in as date)
        and (
            status_history.date_out is null
            or vehicle_dates.snapshot_date <= cast(status_history.date_out as date)
        )

),

enriched as (

    select
        vehicle_dates.snapshot_date,
        vehicle_dates.stock_vehicles_id,
        vehicle_dates.vin,
        vehicle_dates.contract_number,
        vehicle_dates.brand,
        vehicle_dates.model,
        vehicle_dates.is_electric,
        vehicle_dates.platform,
        vehicle_dates.country,
        vehicle_dates.state_name,
        coalesce(status_as_of_date.historical_status, vehicle_dates.status) as status,
        vehicle_dates.physical_status,
        coalesce(status_as_of_date.historical_standardized_category, vehicle_dates.standardized_category) as standardized_category,
        coalesce(status_as_of_date.historical_standardized_sub_category, vehicle_dates.standardized_sub_category) as standardized_sub_category,
        status_as_of_date.associate_id,
        vehicle_dates.reception_date,
        vehicle_dates.delivered_date,
        status_as_of_date.status_date_in,
        payments.dpd,
        payments.last_payment_received_date,
        payments.is_past_due,
        payments.is_over_7_days_past_due,
        payments.dpd_bucket,
        payments.operational_risk_level

    from vehicle_dates

    left join status_as_of_date
        on vehicle_dates.snapshot_date = status_as_of_date.snapshot_date
        and vehicle_dates.vin = status_as_of_date.vin
        and status_as_of_date.status_record_rank = 1

    left join payments
        on vehicle_dates.snapshot_date = payments.business_date
        and vehicle_dates.vin = payments.vin
        and vehicle_dates.contract_number = payments.contract_number

),

classified as (

    select
        *,
        regexp_replace(lower(trim(status)), '[^a-z0-9]+', '_') as normalized_status,
        datediff(day, cast(reception_date as date), snapshot_date) as days_in_inventory,
        datediff(day, cast(status_date_in as date), snapshot_date) as days_in_current_status

    from enriched

),

final as (

    select
        *,
        case
            when normalized_status like '%idle%'
              or standardized_category like '%idle%'
              or standardized_sub_category like '%idle%'
            then true else false
        end as is_idle,
        case
            when normalized_status like '%workshop%'
              or standardized_category like '%workshop%'
              or standardized_sub_category like '%workshop%'
              or normalized_status like '%taller%'
              or standardized_category like '%taller%'
              or standardized_sub_category like '%taller%'
            then true else false
        end as is_workshop,
        case
            when normalized_status like '%withdrawn%'
              or standardized_category like '%withdrawn%'
              or normalized_status like '%baja%'
              or standardized_category like '%baja%'
            then true else false
        end as is_withdrawn,
        case
            when associate_id is not null
              or normalized_status like '%assigned%'
              or normalized_status like '%asignado%'
            then true else false
        end as is_assigned,
        case
            when days_in_inventory > 45 then true else false
        end as is_over_45_days_in_stock

    from classified

)

select
    *,
    case
        when is_idle or is_workshop or is_withdrawn then true
        else false
    end as is_unproductive
from final
