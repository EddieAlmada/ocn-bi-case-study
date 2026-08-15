{% docs int_vehicle_lifecycle %}
One current vehicle record enriched with the first occurrence of key operational events and lifecycle duration metrics.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_vehicle_created_at %}
Timestamp of the vehicle's first classified creation event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_gps_installed_at %}
Timestamp of the vehicle's first classified GPS installation event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_vehicle_ready_at %}
Timestamp of the vehicle's first classified ready event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_driver_assigned_at %}
Timestamp of the vehicle's first classified driver assignment event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_vehicle_delivered_at %}
Timestamp of the vehicle's first classified delivery event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_workshop_at %}
Timestamp of the vehicle's first classified workshop event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_service_at %}
Timestamp of the vehicle's first classified service event.
{% enddocs %}

{% docs int_vehicle_lifecycle__first_returned_to_stock_at %}
Timestamp of the vehicle's first classified return-to-stock event.
{% enddocs %}

{% docs int_vehicle_lifecycle__days_reception_to_ready %}
Whole days elapsed from vehicle reception to its first ready event.
{% enddocs %}

{% docs int_vehicle_lifecycle__days_reception_to_driver_assignment %}
Whole days elapsed from vehicle reception to its first driver assignment event.
{% enddocs %}

{% docs int_vehicle_lifecycle__days_gps_to_driver_assignment %}
Whole days elapsed from the first GPS installation to the first driver assignment event.
{% enddocs %}

{% docs int_vehicle_lifecycle__resolved_driver_assignment_at %}
Canonical driver-assignment timestamp. It uses the first `driver_assigned` event when available and falls back to the vehicle master `delivered_date`.
{% enddocs %}

{% docs int_vehicle_lifecycle__driver_assignment_timestamp_source %}
Source selected for the canonical driver-assignment timestamp: `driver_assigned_event`, `delivered_date_fallback` or `missing`.
{% enddocs %}

{% docs int_vehicle_lifecycle__has_delivery_assignment_timestamp_conflict %}
Boolean indicating that `delivered_date` and the first `driver_assigned` event occur on different calendar dates.
{% enddocs %}

{% docs int_vehicle_lifecycle__delivery_assignment_day_difference %}
Signed whole-day difference from `delivered_date` to the first `driver_assigned` event. Positive values mean the assignment event occurred later.
{% enddocs %}
