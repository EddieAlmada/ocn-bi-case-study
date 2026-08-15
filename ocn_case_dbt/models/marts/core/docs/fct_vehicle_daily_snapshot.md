{% docs fct_vehicle_daily_snapshot %}
Daily analytical snapshot with one row per VIN and date. It combines the vehicle master, effective status history and payment observations to support historical fleet KPIs.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__snapshot_date %}
Calendar date represented by the snapshot row.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__normalized_status %}
Lowercase, underscore-separated effective status on the snapshot date.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__fleet_composition %}
Mutually exclusive fleet classification as of the snapshot date using the governed Fleet Health precedence: withdrawn, workshop, active and then idle.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__days_in_inventory %}
Whole days elapsed from reception or creation to the snapshot date.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__days_in_current_status %}
Whole days elapsed from entry into the effective status to the snapshot date.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_idle %}
Boolean derived from normalized status, category and sub-category labels that indicate an idle vehicle.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_workshop %}
Boolean derived from normalized English or Spanish labels that indicate workshop or maintenance state.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_withdrawn %}
Boolean derived from normalized English or Spanish labels that indicate a withdrawn vehicle.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_assigned %}
Boolean indicating an associated driver or an effective status label representing assignment.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_over_45_days_in_stock %}
Boolean indicating that the vehicle has remained in inventory for more than 45 days as of the snapshot date.
{% enddocs %}

{% docs fct_vehicle_daily_snapshot__is_unproductive %}
Governed Fleet KPI flag equal to true when the vehicle is idle, in workshop or withdrawn.
{% enddocs %}
