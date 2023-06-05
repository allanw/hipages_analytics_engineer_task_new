{% macro test_as_timestamp_utc() %}
    {% set myquery %}
    /* todo - call the macro directly rather than duplicating the macro logic here */
        to_timestamp('2023-04-29 00:58:35+00','YYYY-MM-DD HH24:MI:SS.MS') :: timestamp at TIME zone 'UTC'
    {% endset %}

    {% set result = run_query(myquery) %}
    {% if result != '2023-04-29 00:58:35+00' %}
        {{ exceptions.raise_compiler_error('there was an error') }}
    {% endif %}
{% endmacro %}