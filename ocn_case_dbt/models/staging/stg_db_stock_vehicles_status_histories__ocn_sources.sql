with source as (

    select * from {{ source('ocn_sources', 'db_stock_vehicles_status_histories') }}

),

renamed as (

    select
        contract_number,
        vin,
        schema_version,
        stock_vehicle_status_histories_id,
        associate_id,
        try_cast(canceled_at as timestamp) as canceled_at,
        category,
        {{ standardize_operational_label('category') }} as standardized_category,
        commments,
        try_cast(created_at as timestamp) as created_at,
        try_cast(date_in as timestamp) as date_in,
        try_cast(date_out as timestamp) as date_out,
        is_canceled,
        is_completed,
        previous_category,
        {{ standardize_operational_label('previous_category') }} as standardized_previous_category,
        previous_status,
        previous_step,
        previous_sub_category,
        {{ standardize_operational_label('previous_sub_category') }} as standardized_previous_sub_category,
        status,
        step,
        stockid,
        sub_category,
        {{ standardize_operational_label('sub_category') }} as standardized_sub_category,
        userid

    from source

)

select * from renamed
