{% docs int_vehicle_events %}
Operational vehicle events standardized into a common event taxonomy for lifecycle analysis.
{% enddocs %}

{% docs int_vehicle_events__vehicle_event_id %}
Analytical surrogate key generated from the source event identifier and all event-defining attributes. Exact duplicate source rows are collapsed by this key.
{% enddocs %}

{% docs int_vehicle_events__event_at %}
Timestamp at which the operational event occurred, renamed from the source `time` column.
{% enddocs %}

{% docs int_vehicle_events__event_type %}
Standardized event classification derived from the normalized source workflow step.
{% enddocs %}
