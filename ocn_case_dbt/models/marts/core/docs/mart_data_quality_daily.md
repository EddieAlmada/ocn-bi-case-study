{% docs mart_data_quality_daily %}
Daily observability mart that summarizes known source and transformation quality issues without removing the affected source records.
{% enddocs %}

{% docs mart_data_quality_daily__data_quality_observation_id %}
Surrogate key identifying one quality metric for one observation date and data layer.
{% enddocs %}

{% docs mart_data_quality_daily__observation_date %}
Date on which the quality metrics were evaluated.
{% enddocs %}

{% docs mart_data_quality_daily__data_layer %}
dbt layer where the quality issue is observed.
{% enddocs %}

{% docs mart_data_quality_daily__severity %}
Governed operational severity assigned to the quality issue.
{% enddocs %}

{% docs mart_data_quality_daily__issue_type %}
Stable machine-readable name of the measured quality issue.
{% enddocs %}

{% docs mart_data_quality_daily__affected_rows %}
Number of source or analytical rows affected by the quality issue.
{% enddocs %}

{% docs mart_data_quality_daily__has_issue %}
Boolean indicating whether at least one affected row was detected.
{% enddocs %}
