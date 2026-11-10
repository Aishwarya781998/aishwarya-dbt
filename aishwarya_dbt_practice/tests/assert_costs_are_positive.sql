-- This test PASSES when it returns ZERO rows.
-- Any row returned = a failure.

select
    work_order_event_id,
    parts_cost,
    labor_cost,
    total_cost
from {{ ref('fct_work_order') }}
where parts_cost < 0
   or labor_cost < 0
   or total_cost < 0