with work_orders as (

    select * from {{ ref('stg_work_order') }}

),

employees as (

    select * from {{ ref('stg_employee') }}

),

carts as (

    select * from {{ ref('stg_cart') }}

),

joined as (

    select
        wo.work_order_event_id,
        wo.work_order_number,
        wo.cart_id,
        wo.employee_id,
        wo.site_code,
        wo.work_order_type,
        wo.priority,
        wo.opened_at,
        wo.closed_at,
        wo.labor_hours,
        wo.parts_cost,
        wo.labor_cost,
        wo.status,

        -- from the employee
        emp.employee_name,
        emp.hourly_rate,

        -- from the cart
        crt.cart_type,
        crt.capacity_gallons,

        -- business logic lives HERE, once
        wo.labor_hours * emp.hourly_rate            as expected_labor_cost,
        wo.labor_cost - (wo.labor_hours * emp.hourly_rate) as labor_cost_variance,

        -- CDC columns must survive every layer
        wo.created_at,
        wo.modified_at,
        wo.is_deleted,
        wo.valid_from,
        wo.valid_to

    from work_orders wo
    left join employees emp on wo.employee_id = emp.employee_id
    left join carts     crt on wo.cart_id     = crt.cart_id

)

select * from joined