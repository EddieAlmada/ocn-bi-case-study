{% docs int_vehicle_status_transitions %}
Vehicle status history enriched with elapsed duration and indicators for status and category changes.
{% enddocs %}

{% docs int_vehicle_status_transitions__vehicle_status_transition_id %}
Analytical surrogate key generated from the source identifier and all attributes that define a status transition. Exact duplicate source rows are collapsed by this key.
{% enddocs %}

{% docs int_vehicle_status_transitions__normalized_status %}
Lowercase, underscore-separated representation of the resulting source status.
{% enddocs %}

{% docs int_vehicle_status_transitions__normalized_previous_status %}
Lowercase, underscore-separated representation of the previous source status.
{% enddocs %}

{% docs int_vehicle_status_transitions__has_invalid_date_range %}
Boolean indicating that the recorded exit timestamp occurs before the entry timestamp. Invalid intervals are retained for audit but excluded from duration calculations.
{% enddocs %}

{% docs int_vehicle_status_transitions__days_in_status %}
Whole days elapsed between entry and exit when both dates are valid; otherwise null.
{% enddocs %}

{% docs int_vehicle_status_transitions__is_status_change %}
Boolean indicating whether the previous and resulting status are distinct, including null-safe comparison.
{% enddocs %}

{% docs int_vehicle_status_transitions__is_category_change %}
Boolean indicating whether the previous and resulting category are distinct, including null-safe comparison.
{% enddocs %}

{% docs int_vehicle_status_transitions__standardized_category %}
Standardized resulting category inherited from staging for consistent transition analysis.
{% enddocs %}

{% docs int_vehicle_status_transitions__standardized_sub_category %}
Standardized resulting sub-category inherited from staging for consistent transition analysis.
{% enddocs %}

{% docs int_vehicle_status_transitions__standardized_previous_category %}
Standardized category preceding the transition.
{% enddocs %}

{% docs int_vehicle_status_transitions__standardized_previous_sub_category %}
Standardized sub-category preceding the transition.
{% enddocs %}
