{% macro cost_bucket(cost_column) %}
    case
        when {{ cost_column }} > 2000 then 'HIGH_COST'
        when {{ cost_column }} >  500 then 'MEDIUM_COST'
        else 'LOW_COST'
    end
{% endmacro %}