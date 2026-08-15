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

transitions as (

    select *
    from {{ ref('fct_vehicle_status_transitions') }}

),

transition_metrics_as_of_date as (

    select
        payments.business_date,
        payments.contract_number,
        payments.vin,
        count(transitions.vehicle_status_transition_id) as status_transition_count,
        max(transitions.date_in) as latest_status_started_at,
        max_by(
            transitions.date_out,
            coalesce(transitions.date_in, transitions.created_at)
        ) as latest_status_source_ended_at

    from payments

    left join transitions
        on payments.vin = transitions.vin
        and cast(transitions.date_in as date) <= payments.business_date

    group by
        payments.business_date,
        payments.contract_number,
        payments.vin

),

enriched as (

    select
        payments.business_date,
        payments.contract_number,
        payments.vin,
        vehicles.brand,
        vehicles.model,
        vehicles.country,
        vehicles.state_name,
        snapshots.status,
        snapshots.standardized_category,
        snapshots.standardized_sub_category,
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
        transition_metrics_as_of_date.status_transition_count,
        transition_metrics_as_of_date.latest_status_started_at,
        case
            when cast(transition_metrics_as_of_date.latest_status_source_ended_at as date)
                <= payments.business_date
            then transition_metrics_as_of_date.latest_status_source_ended_at
        end as latest_status_ended_at,
        snapshots.days_in_current_status > 15 as is_prolonged_status,
        case
            when transition_metrics_as_of_date.status_transition_count > 0
             and (
                 transition_metrics_as_of_date.latest_status_source_ended_at is null
                 or cast(transition_metrics_as_of_date.latest_status_source_ended_at as date)
                    > payments.business_date
             )
             and snapshots.is_unproductive
            then true else false
        end as is_unresolved_status

    from payments

    left join snapshots
        on payments.business_date = snapshots.snapshot_date
        and payments.vin = snapshots.vin
        and payments.contract_number = snapshots.contract_number

    left join vehicles
        on payments.vin = vehicles.vin

    left join transition_metrics_as_of_date
        on payments.business_date = transition_metrics_as_of_date.business_date
        and payments.contract_number = transition_metrics_as_of_date.contract_number
        and payments.vin = transition_metrics_as_of_date.vin

),

scored as (

    select
        *,
        least(
            100,
            case
                when dpd > 30 then 75
                when dpd > 7 then 50
                when dpd > 0 then 20
                else 0
            end
            + case when dpd_change > 0 then 5 else 0 end
            + case when is_unproductive then 5 else 0 end
            + case when is_prolonged_status then 10 else 0 end
            + case when is_unresolved_status then 10 else 0 end
        ) as default_risk_score

    from enriched

),

final as (

    select
        *,
        business_date = max(business_date) over () as is_latest_business_date,
        row_number() over (
            partition by business_date, vin
            order by contract_number
        ) = 1 as is_vehicle_date_correlation_record,
        case
            when default_risk_score >= 75 then 'critical'
            when default_risk_score >= 50 then 'high'
            when default_risk_score >= 25 then 'medium'
            else 'low'
        end as default_risk_band,
        case
            when dpd > 30 then true
            when is_unresolved_status then true
            when is_prolonged_status then true
            when dpd > 7 and is_unproductive then true
            else false
        end as is_early_warning,
        case
            when dpd > 30 then 'over_30_days_past_due'
            when is_unresolved_status then 'unresolved_unproductive_status'
            when is_prolonged_status then 'prolonged_status'
            when dpd > 7 and is_unproductive then 'past_due_and_unproductive'
        end as early_warning_reason

    from scored

)

select *
from final
