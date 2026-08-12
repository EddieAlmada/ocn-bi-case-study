{% docs db_stock_vehicles %}
Current-state master record for vehicles in the OCN stock fleet.

Contains vehicle attributes (brand, model, year, VIN), contract and billing
information, GPS and physical status, delivery dates, and workflow state. This
is the primary dimension table for stock vehicle analysis.
{% enddocs %}

{% docs db_stock_vehicles__schema_version %}
Version of the source document schema.
{% enddocs %}

{% docs db_stock_vehicles__stock_vehicles_id %}
Unique identifier for the stock vehicle record.
{% enddocs %}

{% docs db_stock_vehicles__adendum_service_count %}
Count of addendum services associated with the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__agency_payment_date %}
Date of agency-related payment, if applicable.
{% enddocs %}

{% docs db_stock_vehicles__bill %}
Hashed or encoded bill reference.
{% enddocs %}

{% docs db_stock_vehicles__bill_amount %}
Amount on the vehicle bill.
{% enddocs %}

{% docs db_stock_vehicles__bill_date %}
Date the bill was issued.
{% enddocs %}

{% docs db_stock_vehicles__bill_number %}
Bill number or hashed bill identifier.
{% enddocs %}

{% docs db_stock_vehicles__brand %}
Vehicle manufacturer (for example, BYD, VW).
{% enddocs %}

{% docs db_stock_vehicles__can_finish_process %}
Flag indicating whether the stock process can be completed.
{% enddocs %}

{% docs db_stock_vehicles__car_number %}
Hashed internal car or contract reference number.
{% enddocs %}

{% docs db_stock_vehicles__category %}
High-level vehicle category (for example, legal, insurance).
{% enddocs %}

{% docs db_stock_vehicles__color %}
Vehicle color.
{% enddocs %}

{% docs db_stock_vehicles__contract %}
Hashed contract identifier.
{% enddocs %}

{% docs db_stock_vehicles__country %}
Country where the vehicle operates.
{% enddocs %}

{% docs db_stock_vehicles__created_at %}
Timestamp when the stock vehicle record was created.
{% enddocs %}

{% docs db_stock_vehicles__delivered_date %}
JSON array of delivery timestamps.
{% enddocs %}

{% docs db_stock_vehicles__delivery_confirmation %}
Delivery confirmation details.
{% enddocs %}

{% docs db_stock_vehicles__extension_car_number %}
Extension or alternate car number reference.
{% enddocs %}

{% docs db_stock_vehicles__gps_installed %}
Flag indicating whether GPS has been installed.
{% enddocs %}

{% docs db_stock_vehicles__gps_number %}
GPS device number or hashed identifier.
{% enddocs %}

{% docs db_stock_vehicles__gps_serie %}
GPS serial number or hashed identifier.
{% enddocs %}

{% docs db_stock_vehicles__is_blocked %}
Flag indicating whether the vehicle is blocked from processing.
{% enddocs %}

{% docs db_stock_vehicles__is_electric %}
Flag indicating whether the vehicle is electric.
{% enddocs %}

{% docs db_stock_vehicles__km %}
Odometer reading in kilometers.
{% enddocs %}

{% docs db_stock_vehicles__maintenance_history %}
Maintenance history details, if recorded.
{% enddocs %}

{% docs db_stock_vehicles__mi %}
Odometer reading in miles.
{% enddocs %}

{% docs db_stock_vehicles__model %}
Vehicle model name.
{% enddocs %}

{% docs db_stock_vehicles__motor_number %}
Engine or motor serial number.
{% enddocs %}

{% docs db_stock_vehicles__new_car %}
Flag indicating whether the vehicle is new.
{% enddocs %}

{% docs db_stock_vehicles__owner %}
Vehicle owner entity (for example, OCN, DPC).
{% enddocs %}

{% docs db_stock_vehicles__payment_count %}
Number of payments recorded for the vehicle or contract.
{% enddocs %}

{% docs db_stock_vehicles__physical_status %}
Physical handling status (for example, AWAITING_RECEIPT).
{% enddocs %}

{% docs db_stock_vehicles__platform %}
Platform or channel associated with the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__qr_code %}
QR code identifier linked to the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__readmission_date %}
Date the vehicle was readmitted to stock, if applicable.
{% enddocs %}

{% docs db_stock_vehicles__readmission_reason %}
Reason for readmission to stock.
{% enddocs %}

{% docs db_stock_vehicles__ready_to_deliver %}
Flag indicating whether the vehicle is ready for delivery.
{% enddocs %}

{% docs db_stock_vehicles__reception_date %}
Date the vehicle was received into stock.
{% enddocs %}

{% docs db_stock_vehicles__state %}
Geographic state or region code (for example, tij, cdmx).
{% enddocs %}

{% docs db_stock_vehicles__status %}
Overall stock status (for example, active, legal-process, awaiting-insurance).
{% enddocs %}

{% docs db_stock_vehicles__step %}
JSON object describing the current workflow step and step number.
{% enddocs %}

{% docs db_stock_vehicles__sub_category %}
Detailed sub-category within the current status.
{% enddocs %}

{% docs db_stock_vehicles__transferred_to %}
Destination or entity the vehicle was transferred to.
{% enddocs %}

{% docs db_stock_vehicles__updated_at %}
Timestamp of the last update to the record.
{% enddocs %}

{% docs db_stock_vehicles__vehicle_docs_complete %}
Flag indicating whether required vehicle documentation is complete.
{% enddocs %}

{% docs db_stock_vehicles__vehicle_physically_received %}
Flag indicating whether the vehicle was physically received.
{% enddocs %}

{% docs db_stock_vehicles__vehicle_state %}
Short code for the vehicle's operational state or hub.
{% enddocs %}

{% docs db_stock_vehicles__version %}
Vehicle trim or version name.
{% enddocs %}

{% docs db_stock_vehicles__vin %}
Hashed vehicle identification number.
{% enddocs %}

{% docs db_stock_vehicles__vin_number_validated %}
Flag indicating whether the VIN has been validated.
{% enddocs %}

{% docs db_stock_vehicles__year %}
Model year of the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__contract_number %}
Hashed contract identifier linked to the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__last_driver_index %}
Index of the most recent driver assigned to the vehicle.
{% enddocs %}

{% docs db_stock_vehicles__last_driver_id %}
Hashed identifier of the most recent driver.
{% enddocs %}
