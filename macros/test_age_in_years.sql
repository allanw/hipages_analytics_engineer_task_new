{% macro test_age_in_years() %}
    {% set myquery %}
    /* todo - call the macro directly rather than duplicating the macro logic here */
        select date_part('year', age(current_date, '2022-04-11'))
    {% endset %}

    {% set result = run_query(myquery) %}
    {% if result != '21' %}
        {{ exceptions.raise_compiler_error('there was an error') }}
    {% endif %}
{% endmacro %}