# OCN Metric Glossary and Governance

## Purpose

This document is the governed reference for metrics used in dbt marts, Databricks dashboards, Genie, and Dashboards. It defines business meaning, formulas, required filters, aggregation rules, assumptions, and known limitations.

Metric definitions must not be reimplemented differently in a dashboard. Proposed changes should update this document and the corresponding dbt model documentation in the same pull request.

## General governance rules

- Use `vin` as the vehicle identifier and `count(distinct vin)` for vehicle counts unless a metric explicitly uses another grain.
- Use `contract_number` for contract-level Collections metrics.
- Use standardized fields in analytical products. Do not expose raw `state`, `vehicle_state`, `category`, or `sub_category` outside staging.
- Use `state_name` as the governed geographic field.
- Use `park_name` in Operational reporting. It is derived from `state_name`, not from a dedicated physical PARK master.
- Recalculate ratios from their numerators and denominators. Do not average pre-aggregated rates.
- Return `null` when a denominator is zero. A missing measurement must not be presented as zero.
- Current-state KPIs must not aggregate historical daily rows unless a date filter is applied.
- Historical calculations must use information available as of the reporting date and must not use future events.
- Duration metrics are expressed in calendar days unless explicitly stated otherwise.
- Rule-based risk scores are prioritization tools and must not be described as statistical probabilities.

## Governed analytical models

### `mart_fleet_health_current`

- Grain: one row per VIN.
- Purpose: current fleet composition and vehicle-level Fleet Health analysis.
- Current-state source for Fleet Size and Unproductive Fleet Percentage.

### `mart_fleet_health_daily`

- Grain: one row per date and Fleet Health dimensional segment.
- Purpose: historical Fleet Health trends.
- Rates must be recalculated from vehicle-count measures.

### `mart_vehicle_operations`

- Grain: one row per VIN.
- Purpose: PARK inventory, operational velocity, workshop performance, and GPS-to-assignment analysis.

### `mart_collections_risk_daily`

- Grain: one row per business date and contract.
- Purpose: delinquency, default-risk prioritization, operational risk context, and early-warning lists.
- Use `is_latest_business_date = true` for current-state reporting.

### `mart_inventory_turnover_monthly`

- Grain: one row per month, country, and `state_name`.
- Purpose: monthly asset-efficiency and inventory-turnover reporting.

## Fleet Health metrics

### Total Fleet

- Business definition: number of unique vehicles currently represented in the fleet.
- Owner: Fleet Manager.
- Source: `mart_fleet_health_current`.
- Formula: `count(distinct vin)`.
- Required filters: none for the full current fleet; apply `state_name`, brand, model, or PARK filters only when a segmented result is intended.
- Aggregation: distinct count; never sum counts produced at incompatible dimensional grains.

### Fleet Composition

- Business definition: mutually exclusive current operational classification of every vehicle.
- Source field: `mart_fleet_health_current.fleet_composition`.
- Allowed values: `active`, `idle`, `workshop`, `withdrawn`.
- Classification precedence: `withdrawn` first, then `workshop`, then `active`, and finally `idle`.
- Assumption: vehicles that match no withdrawn, workshop, or active rule default to idle.
- Validation: the sum of all four groups must equal Total Fleet.

### Unproductive Fleet

- Business definition: vehicles currently classified as idle, workshop, or withdrawn.
- Owner: Fleet Manager.
- Numerator: distinct VINs where `fleet_composition in ('idle', 'workshop', 'withdrawn')`.
- Denominator: Total Fleet.
- Formula:

```sql
try_divide(
    count(distinct case
        when fleet_composition in ('idle', 'workshop', 'withdrawn') then vin
    end),
    count(distinct vin)
)
```

- Display format: percentage with one decimal place.
- Decision enabled: helps Fleet reassign idle units and address workshop delays before depreciation accelerates.

## Operational Velocity metrics

### Average Days to Assignment

- Business definition: average calendar days from vehicle reception to the canonical driver-assignment timestamp.
- Owner: Operations Lead.
- Source: `mart_vehicle_operations.days_reception_to_driver_assignment`.
- Formula: `avg(days_reception_to_driver_assignment)` over non-null, valid observations.
- Naming rule: do not label this metric “Days to Ready.” It measures assignment, not the `vehicle_ready` event.
- Assignment timestamp precedence: first driver-assigned event, then `delivered_date` as fallback.
- Limitation: fallback observations must remain identifiable through `driver_assignment_timestamp_source`.
- Decision enabled: identifies onboarding bottlenecks delaying productive vehicle deployment.

### Average Days to Ready

- Business definition: average calendar days from reception to the first `vehicle_ready` event.
- Source: `mart_vehicle_operations.days_reception_to_ready`.
- Formula: `avg(days_reception_to_ready)` over non-null, non-negative observations.
- Decision enabled: identifies preparation bottlenecks before a vehicle becomes deployable.

### GPS-to-Driver Assignment Gap

- Business definition: calendar days between first GPS installation and canonical driver assignment.
- Source: `mart_vehicle_operations.gps_to_driver_assignment_days`.
- Formula: `avg(gps_to_driver_assignment_days)` over non-null observations.
- Data-quality rule: negative values are warnings and must be investigated rather than silently included.
- Decision enabled: identifies technically ready vehicles waiting for a driver assignment.

### PARK Inventory

- Business definition: current unique vehicles held at each governed operational location, excluding withdrawn vehicles.
- Source: `mart_vehicle_operations`.
- Dimension: `park_name`.
- Required filter: `is_inventory_vehicle = true`.
- Formula: `count(distinct vin)`.
- Assumption: no dedicated physical PARK identifier exists in the source. `park_name` is derived exclusively from standardized `state_name` and falls back to `Unknown`.
- Limitation: `park_name` represents a governed geographic or hub approximation, not a guaranteed physical yard identifier.
- Decision enabled: reveals locations with excess or insufficient inventory.

### Workshop Visit Count

- Business definition: number of status-history records classified as workshop or maintenance visits.
- Source: `mart_vehicle_operations.workshop_visit_count`.
- Aggregation: `sum(workshop_visit_count)`.
- Limitation: multiple workshop records may represent separate visits or operational sub-statuses depending on source behavior.

### Measurable Workshop Visit Count

- Business definition: workshop visits for which a valid exit timestamp can be observed or governedly inferred.
- Source: `mart_vehicle_operations.completed_workshop_visit_count`.
- Exit timestamp precedence:
  1. Valid `date_out` later than `date_in`.
  2. For a completed record, the first subsequent valid transition outside workshop or maintenance.
- Invalid dates and dates before the year 2000 are excluded.

### Inferred Workshop Visit Count

- Business definition: measurable workshop visits whose exit was inferred from a subsequent non-workshop transition because `date_out` was missing.
- Source: `mart_vehicle_operations.inferred_workshop_visit_count`.
- Use: disclose inference coverage alongside Workshop Turnaround.
- Assumption: the first valid subsequent non-workshop transition represents the operational exit from workshop.

### Workshop Turnaround

- Business definition: weighted average calendar days from workshop entry to measurable workshop exit.
- Owner: Operations Lead.
- Numerator: `sum(completed_workshop_days)`.
- Denominator: `sum(completed_workshop_visit_count)`.
- Formula:

```sql
try_divide(
    sum(completed_workshop_days),
    sum(completed_workshop_visit_count)
)
```

- Required behavior: return `null` when no visits are measurable; do not display zero.
- Aggregation rule: do not use `avg(workshop_turnaround_days)` for brand, model, or total reporting. Use the ratio of sums.
- Open workshop visits are excluded from completed turnaround and analyzed through `current_workshop_age_days`.
- Source limitation: the provided source has workshop records but no populated workshop `date_out`; therefore measurable turnaround currently depends on governed inference.
- Decision enabled: highlights brands and models causing excessive operational downtime.

### Current Workshop Age

- Business definition: elapsed calendar days in the current workshop status for vehicles presently in workshop.
- Source: `mart_vehicle_operations.current_workshop_age_days`.
- Formula: current date minus current workshop status start date.
- Use: open-work-order monitoring; never mix it into completed Workshop Turnaround.

## Collections Risk metrics

### Vehicles Over Seven Days Past Due

- Business definition: percentage of current vehicles whose associated contract is more than seven days past due.
- Owner: Collections Head.
- Source: `mart_collections_risk_daily`.
- Required filter: `is_latest_business_date = true`.
- Numerator: distinct VINs where `is_over_7_days_past_due = true`.
- Denominator: distinct VINs with a current payment observation.
- Formula:

```sql
try_divide(
    count(distinct case when is_over_7_days_past_due then vin end),
    count(distinct vin)
)
```

- Decision enabled: quantifies the share of vehicles requiring immediate Collections attention.

### Default Risk Score

- Business definition: transparent 0–100 operational prioritization score combining delinquency and vehicle-status risk signals.
- Owner: Collections Head.
- Source: `mart_collections_risk_daily.default_risk_score`.
- Required filter for current reporting: `is_latest_business_date = true`.
- Base score:
  - DPD greater than 30: 75 points.
  - DPD from 8 through 30: 50 points.
  - DPD from 1 through 7: 20 points.
  - Current or missing DPD: 0 points.
- Additions:
  - DPD increased from the previous observation: 5 points.
  - Vehicle is unproductive: 5 points.
  - Current status is prolonged: 10 points.
  - Current status is unresolved and unproductive: 10 points.
- Maximum: 100 points.
- Limitation: this is not a probability of default, credit model, or statistically calibrated prediction.

### Default Risk Band

- Business definition: governed distribution bucket derived from Default Risk Score.
- Source: `mart_collections_risk_daily.default_risk_band`.
- Bands:
  - `low`: 0–24.
  - `medium`: 25–49.
  - `high`: 50–74.
  - `critical`: 75–100.
- Distribution metric: distinct contracts or VINs by band, with the chosen entity stated in the visualization title.
- Required filter for current distribution: `is_latest_business_date = true`.
- Decision enabled: helps Collections allocate effort according to risk severity.

### Prolonged Status

- Business definition: vehicle has remained in its effective status for more than 15 calendar days.
- Source: `mart_collections_risk_daily.is_prolonged_status`.
- Assumption: 15 days is the current governed operational threshold and may be changed only through an approved metric-definition update.

### Unresolved Status

- Business definition: latest status transition remains open as of the business date and the vehicle is unproductive.
- Source: `mart_collections_risk_daily.is_unresolved_status`.
- Point-in-time rule: a transition closed after the reporting date is treated as unresolved on the earlier reporting date.

### Early Warning Vehicle

- Business definition: vehicle requiring action due to critical delinquency, prolonged status, unresolved unproductive status, or delinquency combined with unproductive operation.
- Source flag: `mart_collections_risk_daily.is_early_warning`.
- Required filters for current action list:
  - `is_latest_business_date = true`.
  - `is_early_warning = true`.
- Explanation field: `early_warning_reason`.
- Decision enabled: allows Collections to intervene before delinquency or operational blockers become critical.

### Status Transitions vs. Time in Inventory

- Business definition: statistical correlation between cumulative status-transition count and days in inventory as of the same business date.
- Fields: `status_transition_count`, `days_in_inventory`.
- Required filters:
  - `is_latest_business_date = true` for the current relationship, or one explicit business date for historical analysis.
  - `is_vehicle_date_correlation_record = true` to avoid overweighting VINs with multiple contracts.
- Formula: `corr(status_transition_count, days_in_inventory)`.
- Interpretation rule: correlation shows association, not causation.
- Decision enabled: identifies whether operational instability is associated with longer inventory holding time.

## Asset Efficiency metrics

### Assigned Vehicles

- Business definition: unique vehicles with a driver-assignment event during the reporting month.
- Source: `mart_inventory_turnover_monthly.assigned_vehicles`.
- Aggregation: sum across mutually exclusive geographic segments within the same month.

### Average Monthly Stock

- Business definition: average of daily vehicle stock counts during the month, excluding assigned and withdrawn vehicles.
- Source: `mart_inventory_turnover_monthly.avg_monthly_stock`.
- Aggregation: sum across mutually exclusive geographic segments within the same month.
- Do not sum this measure across multiple months and describe it as a monthly average.

### Inventory Turnover

- Business definition: monthly assigned vehicles divided by average monthly stock.
- Owner: CFO.
- Numerator: `sum(assigned_vehicles)`.
- Denominator: `sum(avg_monthly_stock)` for the same month and selected geography.
- Formula:

```sql
try_divide(
    sum(assigned_vehicles),
    sum(avg_monthly_stock)
)
```

- Required behavior: return `null` when average monthly stock is zero.
- Aggregation rule: calculate separately by month. Do not average `inventory_turnover_rate` across months or locations.
- Decision enabled: shows how efficiently inventory is converted into productive assignments.

## Data-quality and assumption register

### Geography and PARK

- Raw `state` is empty in the supplied vehicle source.
- Location codes are stored in source `vehicle_state`.
- Staging maps `vehicle_state` codes to standardized `state_name`.
- Raw `state` and `vehicle_state` remain staging-only fields.
- Analytical models use only `state_name`; Operational reporting aliases it to `park_name`.

### Workshop timestamps

- Workshop records have populated `date_in` but no populated `date_out` in the supplied data.
- Some records are logically completed through `is_completed`.
- Workshop exit may be inferred only for completed records with a later valid non-workshop transition.
- Inferred measurements must remain separately countable and disclosed.

### Driver assignment

- Canonical assignment uses the first driver-assigned event.
- `delivered_date` is the governed fallback when the event is unavailable.
- Conflicts between both timestamps remain visible through data-quality fields and tests.

### Timestamp quality

- Literal strings such as `null` are converted to SQL null through tolerant casting.
- Malformed or implausible timestamps must not contribute to duration metrics.
- Negative lifecycle gaps are monitored as warnings and require investigation.

## Visualization governance

Every dashboard visualization must include a concise decision justification. A justification states who uses the visual and what action it enables.

Examples:

- Fleet composition: “Enables Fleet to reassign idle units before depreciation accelerates.”
- PARK heatmap: “Helps Fleet rebalance inventory between locations with excess and constrained supply.”
- Workshop turnaround: “Helps Operations prioritize brands and models driving prolonged downtime.”
- GPS-to-assignment gap: “Reveals technically ready vehicles waiting for productive deployment.”
- Default-risk distribution: “Helps Collections allocate effort according to severity.”
- Early-warning list: “Enables intervention before delinquency and unresolved status issues become critical.”
- Inventory turnover: “Shows the CFO how efficiently stock is converted into productive assignments.”

## Change management

For every metric change:

1. State the business reason and metric owner.
2. Update the formula, grain, filters, and assumptions in this glossary.
3. Update the dbt model and its `doc()` documentation.
4. Add or update data tests for uniqueness, accepted values, valid ranges, and denominator behavior.
5. Rebuild affected models and validate historical and current outputs.
6. Update Databricks, Genie, and Dashboards calculations to use the governed definition.

