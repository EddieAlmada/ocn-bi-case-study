{% macro classify_fleet_composition(status_expression, category_expression, sub_category_expression) %}
    case
        when {{ status_expression }} in ('withdrawn', 'discharged')
          or {{ category_expression }} in ('withdrawn', 'sold')
          or {{ sub_category_expression }} = 'withdrawn'
          or {{ sub_category_expression }} like 'sold%'
            then 'withdrawn'

        when {{ status_expression }} in ('workshop', 'in_service', 'overhauling', 'maintenance')
          or {{ category_expression }} in ('workshop', 'in_maintenance')
          or {{ sub_category_expression }} in ('workshop', 'in_maintenance')
            then 'workshop'

        when {{ status_expression }} in ('active', 'assigned')
          or {{ category_expression }} = 'assigned'
          or {{ sub_category_expression }} = 'assigned'
            then 'active'

        else 'idle'
    end
{% endmacro %}
