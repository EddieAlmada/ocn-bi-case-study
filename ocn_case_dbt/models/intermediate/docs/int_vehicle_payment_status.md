{% docs int_vehicle_payment_status %}
Daily vehicle payment observations enriched with delinquency indicators and a standardized DPD bucket.
{% enddocs %}

{% docs int_vehicle_payment_status__is_past_due %}
Boolean indicating whether days past due is greater than zero; null when DPD is unknown.
{% enddocs %}

{% docs int_vehicle_payment_status__is_over_7_days_past_due %}
Boolean indicating whether days past due is greater than seven; null when DPD is unknown.
{% enddocs %}

{% docs int_vehicle_payment_status__dpd_bucket %}
Standardized delinquency range derived from days past due, including `unknown` when DPD is null.
{% enddocs %}
