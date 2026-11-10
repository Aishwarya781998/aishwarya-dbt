{{ config(materialized='view') }}

with source as (

    select * from {{ source('operations_raw', 'raw_employee') }}

),

renamed as (

    select
        emp_id          as employee_id,
        emp_name        as employee_name,
        job_cd          as job_code,
        dept_nm         as department_name,
        site_cd         as site_code,
        hire_dt         as hire_date,
        hourly_rate,
        active_flg      as is_active,
        create_dtm      as created_at,
        modify_dtm      as modified_at

    from source

)

select * from renamed