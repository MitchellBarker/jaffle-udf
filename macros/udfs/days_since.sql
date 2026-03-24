{# Creates a SQL UDF that returns the integer number of days elapsed since a given date #}

{% macro create_days_since() %}
    {{ return(adapter.dispatch('create_days_since')()) }}
{% endmacro %}

{% macro default__create_days_since() %}
    create or replace function {{ target.schema }}.days_since(date_col date)
    returns integer
    as $$
        datediff('day', date_col, current_date())
    $$
{% endmacro %}

{% macro bigquery__create_days_since() %}
    create or replace function `{{ target.project }}.{{ target.schema }}.days_since`(date_col date)
    returns int64 as (
        date_diff(current_date(), date_col, day)
    )
{% endmacro %}

{# Inline wrapper to call the days_since UDF within model SQL #}

{% macro days_since(column_name) %}
    {{ return(adapter.dispatch('days_since')(column_name)) }}
{% endmacro %}

{% macro default__days_since(column_name) %}
    {{ target.schema }}.days_since({{ column_name }})
{% endmacro %}

{% macro bigquery__days_since(column_name) %}
    `{{ target.project }}.{{ target.schema }}.days_since`({{ column_name }})
{% endmacro %}
