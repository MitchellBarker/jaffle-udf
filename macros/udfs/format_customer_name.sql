{# Creates a SQL UDF that returns a customer name in title case with surrounding whitespace trimmed #}

{% macro create_format_customer_name() %}
    {{ return(adapter.dispatch('create_format_customer_name')()) }}
{% endmacro %}

{% macro default__create_format_customer_name() %}
    create or replace function {{ target.schema }}.format_customer_name(customer_name varchar)
    returns varchar
    as $$
        initcap(trim(customer_name))
    $$
{% endmacro %}

{% macro bigquery__create_format_customer_name() %}
    create or replace function `{{ target.project }}.{{ target.schema }}.format_customer_name`(customer_name string)
    returns string as (
        initcap(trim(customer_name))
    )
{% endmacro %}

{# Inline wrapper to call the format_customer_name UDF within model SQL #}

{% macro format_customer_name(column_name) %}
    {{ return(adapter.dispatch('format_customer_name')(column_name)) }}
{% endmacro %}

{% macro default__format_customer_name(column_name) %}
    {{ target.schema }}.format_customer_name({{ column_name }})
{% endmacro %}

{% macro bigquery__format_customer_name(column_name) %}
    `{{ target.project }}.{{ target.schema }}.format_customer_name`({{ column_name }})
{% endmacro %}
