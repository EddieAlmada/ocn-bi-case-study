{% docs mart_vehicle_operations %}
Current vehicle-level operational mart for PARK inventory heatmaps, workshop turnaround analysis by brand and model, GPS-to-driver assignment diagnostics and prolonged-status alerts.
{% enddocs %}

{% docs mart_vehicle_operations__park_name %}
Governed PARK-level location. It uses the standardized geographic state name, falls back to the source location code and finally to `Unknown`.
{% enddocs %}

{% docs mart_vehicle_operations__is_inventory_vehicle %}
Boolean identifying vehicles included in current PARK inventory. It excludes vehicles currently classified as withdrawn.
{% enddocs %}

{% docs mart_vehicle_operations__transition_count %}
Total number of status history records associated with the VIN.
{% enddocs %}

{% docs mart_vehicle_operations__workshop_visit_count %}
Number of status-history records classified as workshop or maintenance visits, including the currently open visit.
{% enddocs %}

{% docs mart_vehicle_operations__completed_workshop_visit_count %}
Number of workshop or maintenance visits with a valid completed duration. Use this as the denominator for workshop turnaround.
{% enddocs %}

{% docs mart_vehicle_operations__completed_workshop_days %}
Total duration in days across completed workshop or maintenance visits. Divide its sum by completed workshop visit count to calculate turnaround at any aggregation level.
{% enddocs %}

{% docs mart_vehicle_operations__current_workshop_age_days %}
Elapsed days in the current workshop status for vehicles that are presently in workshop. This open duration is intentionally excluded from completed turnaround.
{% enddocs %}

{% docs mart_vehicle_operations__gps_to_driver_assignment_days %}
Whole days from first GPS installation to the canonical driver-assignment timestamp. Null means one or both milestones are unavailable.
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
