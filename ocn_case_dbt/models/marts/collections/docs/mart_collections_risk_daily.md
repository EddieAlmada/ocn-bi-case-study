{% docs mart_collections_risk_daily %}
Daily Collections mart combining payment delinquency with point-in-time vehicle and status-transition context. It supports default-risk distributions, transition-versus-inventory correlation and transparent early-warning action lists without using future transitions.
{% enddocs %}

{% docs mart_collections_risk_daily__is_latest_business_date %}
Boolean identifying rows from the latest business date available in the mart. Use it for current score distributions and early-warning lists without duplicating vehicles across dates.
{% enddocs %}

{% docs mart_collections_risk_daily__is_vehicle_date_correlation_record %}
Boolean selecting exactly one contract row per VIN and business date. Apply this filter before correlating transition count with inventory time so vehicles with multiple contracts are not overweighted.
{% enddocs %}

{% docs mart_collections_risk_daily__status_transition_count %}
Cumulative number of vehicle status transitions recorded on or before the business date. Use this field with days in inventory for point-in-time correlation analysis.
{% enddocs %}

{% docs mart_collections_risk_daily__latest_status_started_at %}
Start timestamp of the latest status transition known as of the business date.
{% enddocs %}

{% docs mart_collections_risk_daily__latest_status_ended_at %}
End timestamp of the latest status transition known as of the business date. Null indicates that the transition remains open in the available source data.
{% enddocs %}

{% docs mart_collections_risk_daily__is_prolonged_status %}
Boolean indicating that the vehicle has remained in its effective status for more than 15 days as of the business date.
{% enddocs %}

{% docs mart_collections_risk_daily__is_unresolved_status %}
Boolean indicating that the latest known transition has no end timestamp and the vehicle is in an unproductive status.
{% enddocs %}

{% docs mart_collections_risk_daily__default_risk_score %}
Transparent rule-based score from 0 to 100. It combines DPD severity with worsening DPD, unproductive operation, prolonged status and unresolved status. This is a prioritization score, not a statistical probability of default.
{% enddocs %}

{% docs mart_collections_risk_daily__default_risk_band %}
Governed distribution band derived from the default risk score: low, medium, high or critical.
{% enddocs %}

{% docs mart_collections_risk_daily__is_early_warning %}
Boolean identifying critical delinquency, prolonged status, unresolved unproductive status or delinquency combined with an unproductive condition.
{% enddocs %}

{% docs mart_collections_risk_daily__early_warning_reason %}
Highest-priority rule-based reason for the Collections warning. This field is explanatory and not an ML prediction.
{% enddocs %}
