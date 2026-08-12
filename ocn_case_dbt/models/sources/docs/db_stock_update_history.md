{% docs db_stock_update_history %}
Event log of updates and workflow steps applied to stock vehicles.

Each row represents a single action or status change in the stock management
process (for example, contract generation, GPS installation, or vehicle sent
to stock), along with the user who performed it and an optional description.
{% enddocs %}

{% docs db_stock_update_history__contract %}
Hashed contract identifier associated with the event.
{% enddocs %}

{% docs db_stock_update_history__vin %}
Hashed vehicle identification number associated with the event.
{% enddocs %}

{% docs db_stock_update_history__history_id %}
Unique identifier for the update event.
{% enddocs %}

{% docs db_stock_update_history__step %}
Workflow step or event type (for example, CONTRATO GENERADO, GPS instalado).
{% enddocs %}

{% docs db_stock_update_history__time %}
Timestamp when the update occurred.
{% enddocs %}

{% docs db_stock_update_history__user_id %}
Hashed identifier of the user who performed the update.
{% enddocs %}

{% docs db_stock_update_history__description %}
Optional free-text detail about the update.
{% enddocs %}
