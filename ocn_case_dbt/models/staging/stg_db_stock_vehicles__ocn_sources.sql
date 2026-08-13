with source as (

    select * from {{ source('ocn_sources', 'db_stock_vehicles') }}

),

renamed as (

    select
        schema_version,
        stock_vehicles_id,
        adendum_service_count,
        try_cast(agency_payment_date as date) as agency_payment_date,
        bill,
        bill_amount,
        try_cast(bill_date as date) as bill_date,
        bill_number,
        brand,
        can_finish_process,
        car_number,
        category,
        color,
        contract,
        country,
        try_cast(created_at as timestamp) as created_at,
        try_cast(delivered_date as timestamp) as delivered_date,
        delivery_confirmation,
        extension_car_number,
        gps_installed,
        gps_number,
        gps_serie,
        is_blocked,
        is_electric,
        km,
        maintenance_history,
        mi,
        model,
        motor_number,
        new_car,
        owner,
        payment_count,
        physical_status,
        platform,
        qr_code,
        try_cast(readmission_date as timestamp) as readmission_date,
        readmission_reason,
        ready_to_deliver,
        try_cast(reception_date as timestamp) as reception_date,
        state,
        status,
        step,
        sub_category,
        transferred_to,
        try_cast(updated_at as timestamp) as updated_at,
        vehicle_docs_complete,
        vehicle_physically_received,
        vehicle_state,
        version,
        vin,
        vin_number_validated,
        year,
        contract_number,
        last_driver_index,
        last_driver_id

    from source

)

select * from renamed
