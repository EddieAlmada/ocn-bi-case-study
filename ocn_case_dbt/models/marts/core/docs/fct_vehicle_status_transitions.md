{% docs fct_vehicle_status_transitions %}
Event-level fact containing one row per vehicle status history record, enriched with standardized transition labels and open-record identification.
{% enddocs %}

{% docs fct_vehicle_status_transitions__transition_date %}
Calendar date on which the status history record was created.
{% enddocs %}

{% docs fct_vehicle_status_transitions__status_transition %}
Normalized label combining previous and resulting status in `previous_to_current` format.
{% enddocs %}

{% docs fct_vehicle_status_transitions__category_transition %}
Label combining the standardized previous and resulting category in `previous_to_current` format.
{% enddocs %}

{% docs fct_vehicle_status_transitions__is_open_transition %}
Boolean indicating that the status interval has no recorded exit date.
{% enddocs %}
