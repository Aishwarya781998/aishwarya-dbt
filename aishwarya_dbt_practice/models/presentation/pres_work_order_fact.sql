{{
    config(
        materialized='incremental',
        unique_key='work_order_event_id',
        incremental_strategy='merge',
        database='DEV_PRESENTATION',
        schema='OPERATIONS_FABRIC',
        alias='PRES_WORK_ORDER_FACT'
    )
}}

with fct as (

    select * from {{ ref('fct_work_order') }}

    {% if is_incremental() %}
    where modified_at > (select max(MODIFY_DTM) from {{ this }})
    {% endif %}

),

dims as (

    select
        f.work_order_event_id,
        f.work_order_number,

        -- site attributes, pre-joined for the report
        f.site_code,
        s.site_name,
        s.area_name,
        s.region_name,
        s.division_name,
        s.line_of_business,

        -- employee attributes
        f.employee_id,
        f.employee_name,
        e.job_category,
        e.department_name,

        -- cart attributes
        f.cart_id,
        c.cart_type,
        c.size_category,

        -- the measures
        f.work_order_type,
        f.priority,
        f.opened_at,
        f.closed_at,
        f.labor_hours,
        f.parts_cost,
        f.labor_cost,
        f.total_cost,
        f.cost_bucket,
        f.is_open,
        f.hours_to_close,
        f.status,

        -- CDC columns Fabric needs 🧵
        f.modified_at   as MODIFY_DTM,
        f.is_deleted    as IS_DELETE,
        f.valid_from    as VALID_FROM,
        f.valid_to      as VALID_TO

    from fct f
    left join {{ ref('dim_site') }}     s on f.site_code   = s.site_code
    left join {{ ref('dim_employee') }} e on f.employee_id = e.employee_id
    left join {{ ref('dim_cart') }}     c on f.cart_id     = c.cart_id

)

select * from dims