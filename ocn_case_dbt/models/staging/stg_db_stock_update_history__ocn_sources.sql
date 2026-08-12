with source as (

    select * from {{ source('ocn_sources', 'db_stock_update_history') }}

),

renamed as (

    select
        contract,
        vin,
        history_id,
        step,
        time,
        user_id,
        description

    from source

)

select * from renamed