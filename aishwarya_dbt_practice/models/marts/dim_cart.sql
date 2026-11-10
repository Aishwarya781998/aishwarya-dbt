with stg as (

    select * from {{ ref('stg_cart') }}

),

final as (

    select
        cart_id,
        cart_serial_number,
        site_code,
        cart_type,
        capacity_gallons,
        in_service_date,
        status,

        case
            when capacity_gallons <= 100 then 'SMALL'
            when capacity_gallons <= 500 then 'MEDIUM'
            else 'LARGE'
        end as size_category,

        datediff('day', in_service_date, current_date()) as days_in_service,

        created_at,
        modified_at

    from stg

)

select * from final