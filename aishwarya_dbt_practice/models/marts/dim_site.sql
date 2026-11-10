with stg as (

    select * from {{ ref('stg_site') }}

),

final as (

    select
        site_code,
        site_name,
        market_code,
        area_name,
        line_of_business,
        region_name,
        is_active,

        case
            when region_name in ('SOUTH','WEST')   then 'WESTERN_DIVISION'
            when region_name in ('EAST','CENTRAL') then 'EASTERN_DIVISION'
            else 'UNKNOWN'
        end as division_name,

        created_at,
        modified_at

    from stg

)

select * from final