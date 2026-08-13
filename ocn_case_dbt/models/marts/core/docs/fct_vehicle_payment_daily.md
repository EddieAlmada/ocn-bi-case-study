{% docs fct_vehicle_payment_daily %}
Daily payment fact at vehicle and contract grain, enriched with DPD movement, payment recency and a transparent operational risk classification.
{% enddocs %}

{% docs fct_vehicle_payment_daily__previous_dpd %}
DPD observed on the immediately preceding available business date for the same VIN and contract.
{% enddocs %}

{% docs fct_vehicle_payment_daily__dpd_change %}
Difference between current DPD and the previous available DPD observation.
{% enddocs %}

{% docs fct_vehicle_payment_daily__days_since_last_payment %}
Whole days elapsed between the most recently received payment and the business date.
{% enddocs %}

{% docs fct_vehicle_payment_daily__operational_risk_level %}
Rule-based payment risk classification: current, medium, high, critical or unknown. This is an operational rule and not an ML prediction.
{% enddocs %}
