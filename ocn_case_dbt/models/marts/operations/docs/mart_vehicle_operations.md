{% docs mart_vehicle_operations %}
Current vehicle-level operational mart for PARK inventory heatmaps, workshop turnaround analysis by brand and model, GPS-to-driver assignment diagnostics and prolonged-status alerts.
{% enddocs %}

{% docs mart_vehicle_operations__park_name %}
Governed PARK-level location derived exclusively from the standardized geographic state name, falling back to `Unknown` when no mapping is available.
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
Total measurable duration in days across completed workshop or maintenance visits. When `date_out` is unavailable, the duration may use the next valid non-workshop transition for a completed record.
{% enddocs %}

{% docs mart_vehicle_operations__inferred_workshop_visit_count %}
Number of measurable workshop visits whose exit timestamp was inferred from the next valid non-workshop transition because the source `date_out` was missing.
{% enddocs %}

{% docs mart_vehicle_operations__workshop_turnaround_days %}
Vehicle-level average measurable workshop turnaround. For aggregated reporting by brand or model, divide total completed workshop days by total completed workshop visit count instead of averaging this field.
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
