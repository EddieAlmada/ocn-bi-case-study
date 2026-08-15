{% docs mart_fleet_health_current %}
Current-state Fleet Health mart with one row per vehicle. It combines the vehicle master with the latest currently effective status transition and assigns every vehicle to exactly one governed fleet-composition group. Use this model for current fleet composition and operational drill-down; use `mart_fleet_health_daily` for historical trends.
{% enddocs %}

{% docs mart_fleet_health_current__current_status %}
Latest currently effective vehicle status, preferring an open status-transition record and falling back to the vehicle master.
{% enddocs %}

{% docs mart_fleet_health_current__current_standardized_category %}
Standardized version of the latest available category used by the governed fleet-composition logic.
{% enddocs %}

{% docs mart_fleet_health_current__current_standardized_sub_category %}
Standardized version of the latest available sub-category used by the governed fleet-composition logic.
{% enddocs %}

{% docs mart_fleet_health_current__current_driver_id %}
Latest available driver or associate identifier, falling back to the last driver recorded in the vehicle master.
{% enddocs %}

{% docs mart_fleet_health_current__current_status_started_at %}
Timestamp at which the latest status-transition record became effective. Null when no status history is available.
{% enddocs %}

{% docs mart_fleet_health_current__normalized_current_status %}
Lowercase, underscore-separated representation of the latest available status.
{% enddocs %}

{% docs mart_fleet_health_current__fleet_composition %}
Mutually exclusive current fleet classification. Precedence is withdrawn, workshop, active and then idle. Active requires a current driver or an assignment status; vehicles that match no higher-priority rule default to idle.
{% enddocs %}

{% docs mart_fleet_health_current__dbt_updated_at %}
Timestamp at which dbt materialized the current Fleet Health record.
{% enddocs %}
