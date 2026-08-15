{% macro standardize_operational_label(column_name) %}

    {% set normalized_value %}
        regexp_replace(
            regexp_replace(
                translate(
                    lower(trim(cast({{ column_name }} as string))),
                    'áéíóúüñ',
                    'aeiouun'
                ),
                '[^a-z0-9]+',
                '_'
            ),
            '^_+|_+$',
            ''
        )
    {% endset %}

    case
        when {{ column_name }} is null
          or lower(trim(cast({{ column_name }} as string))) in ('', 'null', 'none')
            then null
        when {{ normalized_value }} in ('taller', 'workshop', 'in_workshop')
            then 'workshop'
        when {{ normalized_value }} in ('mantenimiento', 'maintenance', 'in_maintenance')
            then 'in_maintenance'
        when {{ normalized_value }} in ('legal', 'proceso_legal', 'in_legal_process')
            then 'legal'
        when {{ normalized_value }} in ('seguro', 'insurance', 'espera_de_seguro', 'awaiting_insurance')
            then 'insurance'
        when {{ normalized_value }} in ('listo', 'ready', 'vehicle_ready')
            then 'ready'
        when {{ normalized_value }} in ('stock', 'en_stock', 'in_stock')
            then 'stock'
        when {{ normalized_value }} in ('vendido', 'sold')
            then 'sold'
        when {{ normalized_value }} in ('baja', 'dado_de_baja', 'withdrawn')
            then 'withdrawn'
        else {{ normalized_value }}
    end

{% endmacro %}
