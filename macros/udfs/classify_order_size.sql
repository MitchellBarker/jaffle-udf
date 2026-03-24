{# Creates a SQL UDF that classifies an order total as 'small', 'medium', or 'large' #}

{% macro create_classify_order_size() %}
    {{ return(adapter.dispatch('create_classify_order_size')()) }}
{% endmacro %}

{% macro default__create_classify_order_size() %}
    create or replace function {{ target.schema }}.classify_order_size(order_total float)
    returns varchar
    as $$
        case
            when order_total < 10 then 'small'
            when order_total < 20 then 'medium'
            else 'large'
        end
    $$
{% endmacro %}

{% macro bigquery__create_classify_order_size() %}
    create or replace function `{{ target.project }}.{{ target.schema }}.classify_order_size`(order_total float64)
    returns string as (
        case
            when order_total < 10 then 'small'
            when order_total < 20 then 'medium'
            else 'large'
        end
    )
{% endmacro %}

{# Inline wrapper to call the classify_order_size UDF within model SQL #}

{% macro classify_order_size(column_name) %}
    {{ return(adapter.dispatch('classify_order_size')(column_name)) }}
{% endmacro %}

{% macro default__classify_order_size(column_name) %}
    {{ target.schema }}.classify_order_size({{ column_name }})
{% endmacro %}

{% macro bigquery__classify_order_size(column_name) %}
    `{{ target.project }}.{{ target.schema }}.classify_order_size`({{ column_name }})
{% endmacro %}
