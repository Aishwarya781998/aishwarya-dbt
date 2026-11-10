{% snapshot snap_employee %}

{{
    config(
        target_database='DEV_CURATED',
        target_schema='OPERATIONS',
        unique_key='employee_id',
        strategy='timestamp',
        updated_at='modified_at',
        invalidate_hard_deletes=True
    )
}}

select * from {{ ref('stg_employee') }}

{% endsnapshot %}