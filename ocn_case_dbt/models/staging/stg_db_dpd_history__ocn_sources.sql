with source as (

    select * from {{ source('ocn_sources', 'db_dpd_history') }}

),

renamed as (

    select
        try_cast(business_date as date) as business_date,
        contract_number,
        vin,
        try_cast(dpd as integer) as dpd,
        try_cast(last_payment_received_date as date) as last_payment_received_date

    from source

)

select * from renamed
