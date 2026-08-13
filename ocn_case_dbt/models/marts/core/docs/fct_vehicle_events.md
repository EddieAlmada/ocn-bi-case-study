{% docs fct_vehicle_events %}
Auditable event-level fact containing one row per operational vehicle event, enriched with sequencing and elapsed-time attributes.
{% enddocs %}

{% docs fct_vehicle_events__event_date %}
Calendar date on which the event occurred.
{% enddocs %}

{% docs fct_vehicle_events__event_month %}
Month containing the event, truncated to the first instant of that month.
{% enddocs %}

{% docs fct_vehicle_events__event_sequence %}
Chronological position of the event within the complete event history of the VIN.
{% enddocs %}

{% docs fct_vehicle_events__previous_event_type %}
Standardized event type immediately preceding the current event for the same VIN.
{% enddocs %}

{% docs fct_vehicle_events__previous_event_at %}
Timestamp of the immediately preceding event for the same VIN.
{% enddocs %}

{% docs fct_vehicle_events__days_since_previous_event %}
Whole days elapsed between the previous event and the current event.
{% enddocs %}
