{{config(
    materialized = 'view')}}
select
 *
  from 

{{source('source', 'fact_sale')}}