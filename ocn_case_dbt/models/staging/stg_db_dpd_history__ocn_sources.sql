with source as (

    select * from {{ source('ocn_sources', 'db_dpd_history') }}

),

renamed as (

    select
        business_date,
        contract_number,
        vin,
        dpd,
        last_payment_received_date

    from source

)

select * from renamed