{% docs mart_vehicle_operations %}
Current vehicle-level operational mart for Fleet and Operations action lists, lifecycle diagnostics and prolonged-status alerts.
{% enddocs %}

{% docs mart_vehicle_operations__transition_count %}
Total number of status history records associated with the VIN.
{% enddocs %}

{% docs mart_vehicle_operations__workshop_entry_count %}
Number of status history records classified as workshop or taller entries.
{% enddocs %}

{% docs mart_vehicle_operations__total_days_in_workshop %}
Sum of completed status durations classified as workshop or taller.
{% enddocs %}

{% docs mart_vehicle_operations__last_transition_at %}
Timestamp of the most recently created status transition for the VIN.
{% enddocs %}

{% docs mart_vehicle_operations__last_status_transition %}
Normalized status transition associated with the most recent transition timestamp.
{% enddocs %}

{% docs mart_vehicle_operations__operational_alert_reason %}
Highest-priority actionable reason assigned to the vehicle: excessive inventory age, prolonged workshop stay or another unproductive condition.
{% enddocs %}
