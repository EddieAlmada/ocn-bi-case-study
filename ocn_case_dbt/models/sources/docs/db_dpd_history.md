{% docs db_dpd_history %}
Daily snapshot of days past due (DPD) by contract and vehicle.

Each row records the delinquency status of a contract on a given business date,
including the number of days past due and the date of the most recent payment
received. Used to track payment performance and portfolio risk over time.
{% enddocs %}

{% docs db_dpd_history__business_date %}
Snapshot date for the DPD record.
{% enddocs %}

{% docs db_dpd_history__contract_number %}
Hashed identifier of the financing contract.
{% enddocs %}

{% docs db_dpd_history__vin %}
Hashed vehicle identification number.
{% enddocs %}

{% docs db_dpd_history__dpd %}
Days past due on the snapshot date. Zero indicates the contract is current.
{% enddocs %}

{% docs db_dpd_history__last_payment_received_date %}
Date of the most recent payment received for the contract.
{% enddocs %}
