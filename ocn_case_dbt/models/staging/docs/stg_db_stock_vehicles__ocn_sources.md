{% docs stg_db_stock_vehicles__state_name %}
Standardized Mexican state name derived from the source `vehicle_state` PARK or hub code. Unrecognized or missing codes remain null while the original source code is preserved in staging only.
{% enddocs %}

{% docs stg_db_stock_vehicles__standardized_category %}
Standardized operational category derived from the source `category`. It is lowercase, accent-free and underscore-separated, with governed bilingual aliases for common operational categories. The original source value is preserved.
{% enddocs %}

{% docs stg_db_stock_vehicles__standardized_sub_category %}
Standardized operational sub-category derived from the source `sub_category` using the same rules as standardized category. The original source value is preserved.
{% enddocs %}
