with event_id_duplicates as (

    select
        sum(record_count - 1) as affected_rows
    from (
        select history_id, count(*) as record_count
        from {{ ref('stg_db_stock_update_history__ocn_sources') }}
        group by history_id
        having count(*) > 1
    )

),

quality_metrics as (

    select
        current_date() as observation_date,
        'staging' as data_layer,
        'warning' as severity,
        'duplicate_source_event_rows' as issue_type,
        coalesce((select affected_rows from event_id_duplicates), 0) as affected_rows

    union all

    select
        current_date(),
        'staging',
        'warning',
        'vehicles_missing_current_status',
        count(*)
    from {{ ref('stg_db_stock_vehicles__ocn_sources') }}
    where status is null

    union all

    select
        current_date(),
        'staging',
        'warning',
        'status_history_missing_source_id',
        count(*)
    from {{ ref('stg_db_stock_vehicles_status_histories__ocn_sources') }}
    where stock_vehicle_status_histories_id is null

    union all

    select
        current_date(),
        'staging',
        'warning',
        'status_history_missing_contract',
        count(*)
    from {{ ref('stg_db_stock_vehicles_status_histories__ocn_sources') }}
    where contract_number is null

    union all

    select
        current_date(),
        'intermediate',
        'warning',
        'invalid_status_date_ranges',
        count(*)
    from {{ ref('int_vehicle_status_transitions') }}
    where has_invalid_date_range

    union all

    select
        current_date(),
        'staging',
        'warning',
        'unrecognized_status_values',
        count(*)
    from {{ ref('stg_db_stock_vehicles_status_histories__ocn_sources') }}
    where status is not null
      and lower(trim(status)) not in ('active', 'inactive')

    union all

    select
        current_date(),
        'intermediate',
        'warning',
        'unclassified_vehicle_events',
        count(*)
    from {{ ref('int_vehicle_events') }}
    where event_type = 'other'

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'observation_date',
            'data_layer',
            'issue_type'
        ]) }} as data_quality_observation_id,
        observation_date,
        data_layer,
        severity,
        issue_type,
        affected_rows,
        case when affected_rows > 0 then true else false end as has_issue

    from quality_metrics

)

select *
from final
