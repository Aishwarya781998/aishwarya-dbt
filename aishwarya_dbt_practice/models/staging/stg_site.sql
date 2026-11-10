{{ config(materialized='view') }}

with source as (

    select * from {{ source('operations_raw', 'raw_site') }}

),

renamed as (

    select
        site_cd         as site_code,
        site_name,
        market_cd       as market_code,
        area_nm         as area_name,
        lob             as line_of_business,
        region_nm       as region_name,
        active_flg      as is_active,
        create_dtm      as created_at,
        modify_dtm      as modified_at

    from source

)

select * from renamed