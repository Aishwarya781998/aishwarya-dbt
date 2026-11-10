{{ config(materialized='view') }}

with source as (

    select * from {{ source('operations_raw', 'raw_cart') }}

),

renamed as (

    select
        cart_id,
        cart_serial_no  as cart_serial_number,
        site_cd         as site_code,
        cart_type_cd    as cart_type,
        capacity_gal    as capacity_gallons,
        in_service_dt   as in_service_date,
        status_cd       as status,
        create_dtm      as created_at,
        modify_dtm      as modified_at

    from source

)

select * from renamed