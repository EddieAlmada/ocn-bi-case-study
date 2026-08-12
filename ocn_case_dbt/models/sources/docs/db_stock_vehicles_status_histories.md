{% docs db_stock_vehicles_status_histories %}
Historical record of stock vehicle status transitions.

Tracks changes in category, sub-category, step, and status for vehicles in stock,
including previous values before each transition. Supports analysis of legal,
operational, and lifecycle workflows over time.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__contract_number %}
Hashed contract identifier linked to the vehicle.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__vin %}
Hashed vehicle identification number.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__schema_version %}
Version of the source document schema.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__stock_vehicle_status_histories_id %}
Unique identifier for the status history record.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__associate_id %}
Hashed identifier of the associate or driver linked to the vehicle.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__canceled_at %}
Timestamp when the status record was canceled, if applicable.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__category %}
Current high-level category of the vehicle (for example, legal, insurance).
{% enddocs %}

{% docs db_stock_vehicles_status_histories__commments %}
Optional comments attached to the status change. Source field name retains the original spelling.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__created_at %}
Timestamp when the status history record was created.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__date_in %}
Date the vehicle entered the current status or sub-process.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__date_out %}
Date the vehicle exited the status or sub-process, if applicable.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__is_canceled %}
Flag indicating whether the status record was canceled.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__is_completed %}
Flag indicating whether the status step was completed.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__sub_category %}
Detailed sub-category within the current category (for example, report-filing, impound-lot).
{% enddocs %}

{% docs db_stock_vehicles_status_histories__previous_category %}
Category before the status transition.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__previous_status %}
Status value before the transition.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__previous_step %}
Workflow step before the transition.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__previous_sub_category %}
Sub-category before the status transition.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__status %}
Current status of the vehicle in the workflow (for example, active, inactive).
{% enddocs %}

{% docs db_stock_vehicles_status_histories__step %}
Current workflow step name (for example, Entregado).
{% enddocs %}

{% docs db_stock_vehicles_status_histories__stockid %}
Hashed identifier of the stock vehicle record.
{% enddocs %}

{% docs db_stock_vehicles_status_histories__userid %}
Hashed identifier of the user associated with the status change.
{% enddocs %}
