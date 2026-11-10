{{ config(materialized='view') }}

with source as (

    select * from {{ source('operations_raw', 'raw_work_order') }}

),

renamed as (

    select
        work_order_event_id,
        work_order_no       as work_order_number,
        cart_id,
        emp_id              as employee_id,
        site_cd             as site_code,
        wo_type_cd          as work_order_type,
        priority_cd         as priority,
        open_dtm            as opened_at,
        close_dtm           as closed_at,
        labor_hours,
        parts_cost,
        labor_cost,
        status_cd           as status,
        create_dtm          as created_at,
        modify_dtm          as modified_at,
        is_delete           as is_deleted,
        valid_from,
        valid_to

    from source

)

select * from renamed