{{
    config(
        materialized='incremental',
        unique_key='work_order_event_id',
        incremental_strategy='merge'
    )
}}

with enriched as (

    select * from {{ ref('int_work_order_enriched') }}

    {% if is_incremental() %}

    where modified_at > (select max(modified_at) from {{ this }})

    {% endif %}

),
final as (

    select
        work_order_event_id,
        work_order_number,

        cart_id,
        employee_id,
        site_code,

        work_order_type,
        priority,
        opened_at,
        closed_at,

        labor_hours,
        parts_cost,
        labor_cost,
        parts_cost + labor_cost as total_cost,

        employee_name,
        hourly_rate,
        cart_type,
        expected_labor_cost,
        labor_cost_variance,

        case when closed_at is null then true else false end as is_open,

        datediff('hour', opened_at, coalesce(closed_at, current_timestamp()))
            as hours_to_close,

        case
            when parts_cost + labor_cost > 2000 then 'HIGH_COST'
            when parts_cost + labor_cost >  500 then 'MEDIUM_COST'
            else 'LOW_COST'
        end as cost_bucket,

        status,
        created_at,
        modified_at,

        is_deleted,
        valid_from,
        valid_to

    from enriched

)

select * from final