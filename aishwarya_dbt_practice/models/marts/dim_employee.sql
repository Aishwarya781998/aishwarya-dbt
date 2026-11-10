with stg as (

    select * from {{ ref('stg_employee') }}

),

final as (

    select
        employee_id,
        employee_name,
        job_code,
        department_name,
        site_code,
        hire_date,
        hourly_rate,
        is_active,

        case
            when job_code like 'TECH%'   then 'TECHNICIAN'
            when job_code = 'SUPERVISOR' then 'MANAGEMENT'
            when job_code = 'CONTRACTOR' then 'EXTERNAL'
            else 'OTHER'
        end as job_category,

        datediff('year', hire_date, current_date()) as years_of_service,

        created_at,
        modified_at

    from stg

)

select * from final