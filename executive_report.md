# Executive Fleet & Operations Dashboard

## Management Summary Report

---

## 1. Problem Statement

Our fleet management operation faces three interconnected challenges that directly impact revenue generation and asset efficiency.

### Asset Underutilization Crisis

With **7,701 vehicles** in the fleet, **51.95% remain unproductive**:

- **Idle:** 3,228
- **Workshop:** 644
- **Withdrawn:** 129

This creates depreciation costs without generating revenue.

Current inventory turnover stands at **0.64**, meaning vehicles complete less than one full cycle per month. This slow conversion rate indicates assets are sitting idle for extended periods, accumulating carrying costs while their market value deteriorates.

### Operational Bottlenecks

Multiple friction points create significant delays across the vehicle deployment lifecycle:

- **31 days** from vehicle reception to driver assignment
- **15 days** from GPS installation to driver assignment
- **196 days** average workshop turnaround

Most concerning is the workshop turnaround time. Vehicles spend **more than six months in service**, removing them from revenue generation and creating a significant operational drag.

### Collections Risk Exposure

Default risk is critically elevated:

- **34.96%** of the portfolio is over 7 days past due
- Average risk score: **30.6 / 100**
- **3,334 vehicles (43% of fleet)** trigger early-warning indicators

These indicators are driven by prolonged status durations, unresolved operational issues, or delinquency signals.

Operational instability appears to be contributing directly to collections challenges, creating a feedback loop in which delayed assignments increase default probability.

### Business Impact

> **Over half the fleet generates zero revenue while incurring $X in daily depreciation. Extended workshop cycles and assignment delays result in $Y in lost revenue days annually. Elevated collections risk threatens $Z in potential write-offs. Combined, these inefficiencies erode margins by an estimated XX% annually.**

---

## 2. Approach

The **Executive Fleet & Operations Dashboard** provides real-time visibility and diagnostic capabilities across three integrated domains.

### Fleet & Asset Health Analytics

Fleet composition tracking segments **7,701 vehicles** into:

- **Productive:** 3,700
- **Unproductive:** 4,001
- **Idle:** 3,228

This enables proactive reallocation of idle vehicles before depreciation accelerates.

Additional capabilities include:

- Geographic inventory heatmaps identifying PARK-level surpluses and deficits across Mexico
- Redistribution planning based on geographic demand
- Inventory turnover monitoring
- Monthly trend analysis to identify seasonal patterns and capacity constraints

**Current inventory turnover:** `0.64`

### Operational Deep Dive

Cycle-time metrics quantify:

| Metric | Current |
|---|---:|
| Reception to Assignment | 31 days |
| GPS to Driver Assignment | 15 days |
| Workshop Turnaround | 196 days |

Analysis across brands, models, and locations exposes the configurations and operating locations creating the greatest capacity constraints.

Actionable alert lists identify vehicles requiring immediate intervention based on prolonged workshop age.

- **Vehicles currently in workshop:** 644
- Many vehicles exceed **200 days** in workshop

Comparative analysis also reveals which brands and PARKs demonstrate operational efficiency versus those creating systematic delays.

### Collections Risk Management

Risk distribution analysis segments the portfolio by probability-of-default bands for targeted collections activity.

Key risk indicators include:

- **7+ DPD rate:** approximately 35%
- **Early-warning vehicles:** 3,334
- **Fleet under early warning:** 43%

The early-warning system identifies vehicles with:

- Prolonged status durations
- Unresolved operational issues
- Delinquency indicators
- Frequent status transitions

Correlation analysis connects operational instability, inventory time, and risk scores, enabling root-cause intervention instead of purely reactive collections.

### Data Foundation

The dashboard integrates:

- Daily collections-risk snapshots
- Current fleet-health status
- Monthly inventory turnover
- Vehicle-level operational metrics
- Production data-mart sources

This provides decision-makers with consistent and trustworthy operational insights.

---

## 3. Impact

The dashboard enables data-driven interventions that directly improve financial performance.

### Improved Asset Productivity

Fleet managers can proactively reassign **3,228 currently idle vehicles** before depreciation accelerates.

**Target:** Reduce unproductive fleet from **52% to &lt;35% within 90 days**.

Geographic rebalancing using PARK inventory heatmaps can minimize:

- Surplus inventory and carrying costs
- Local shortages and lost revenue opportunities

Improving inventory turnover from **0.64 to 1.0+** would enable substantially more vehicle assignments from the same fleet base.

### Accelerated Revenue Generation

Reducing reception-to-assignment time from **31 days to &lt;15 days** could add **16+ revenue days per vehicle**.

Eliminating the **15-day GPS-to-driver gap** would enable faster assignment of vehicles that are technically ready but administratively delayed.

Reducing workshop turnaround from **196 days to &lt;30 days** could return **500+ vehicles** to productive status.

That is equivalent to increasing productive fleet capacity by approximately **6.5%** without purchasing additional vehicles.

### Risk-Adjusted Collections Strategy

Collections teams can prioritize:

- Vehicles already over **7 DPD**
- **3,334 early-warning vehicles**
- Vehicles combining delinquency signals with operational instability

Early intervention can prevent operational issues from escalating into critical delinquency.

Understanding the relationship between operational instability and collections risk enables preventive action before accounts become seriously delinquent.

### Measurable Outcomes

| Area | Expected Impact |
|---|---|
| **Revenue Impact** | 16 additional revenue days × 7,701 vehicles × $X daily rate = **$Y annual revenue recovery** |
| **Cost Reduction** | Reduce unproductive fleet from 52% to 35%, generating **$Z in depreciation and carrying-cost savings** |
| **Risk Mitigation** | Reduce 7+ DPD from 35% to &lt;20%, preventing **$W in potential write-offs** |
| **Capital Efficiency** | Increase turnover from 0.64 to 1.2, generating **87% more throughput without fleet expansion** |

### Strategic Value

> This integrated view transforms fleet management from reactive firefighting to predictive optimization, aligning asset deployment, operations, and collections around a unified performance framework.

---

## 4. Recommendations to Implement

## Immediate Actions: 0–30 Days

### A. Workshop Crisis Response

**Problem:** A **196-day average turnaround** removes **644 vehicles** from productive use.

#### Actions

1. **Launch a workshop audit**
   - Identify the top 100 vehicles by workshop age
   - Prioritize vehicles exceeding 200 days
   - Classify each vehicle as:
     - Awaiting parts
     - Awaiting approval
     - Service in progress
     - Administrative hold

2. **Implement an expedited release protocol**
   - Establish a **48-hour approval SLA** for vehicles under administrative hold

3. **Launch brand-specific interventions**
   - Rank manufacturers by workshop turnaround
   - Engage brands averaging more than 250 days
   - Negotiate expedited parts, service support, or buyback options

**Target:** Reduce workshop turnaround to **&lt;90 days** and return **300+ vehicles** to productive status.

---

### B. GPS-to-Driver Assignment Acceleration

**Problem:** A **15-day gap** delays assignment for technically ready vehicles.

#### Actions

1. **Daily GPS assignment review**
   - Conduct a daily review of vehicles with GPS installed but no driver assigned

2. **Pre-assign GPS to incoming inventory**
   - Complete GPS installation and assignment during the reception process rather than after the driver-assignment decision

**Target:** Reduce the GPS assignment gap to **&lt;3 days**, adding approximately **12 revenue days per vehicle**.

---

### C. Idle Inventory Redeployment

**Problem:** **3,228 vehicles**, or approximately **42% of the fleet**, are idle while some PARKs experience shortages.

#### Actions

1. **Use the PARK Inventory Heatmap**
   - Identify the top 5 surplus locations
   - Identify the top 5 deficit locations

2. **Implement weekly reallocation**
   - Transfer **50–100 vehicles per week** from surplus to deficit PARKs

3. **Prioritize existing inventory**
   - Establish a business rule preventing new purchases until idle inventory falls below 20%

**Target:** Reduce idle inventory from **3,228 to &lt;1,500 within 60 days**.

---

## Short-Term Initiatives: 30–90 Days

### D. Reception-to-Assignment Process Reengineering

**Problem:** A **31-day average cycle time** delays revenue generation.

#### Actions

1. **Process mapping**
   - Document the complete reception-to-assignment workflow
   - Identify:
     - Handoff delays
     - Approval bottlenecks
     - Documentation gaps

2. **Parallel processing**
   - Run GPS installation, inspection, and contract preparation simultaneously rather than sequentially

3. **Delegate assignment authority**
   - Allow PARK managers to approve standard vehicle assignments without escalation

**Target:** Reduce reception-to-assignment time to **&lt;15 days**.

---

### E. Early Warning Vehicle Intervention Program

**Problem:** **3,334 vehicles (43% of fleet)** are in early-warning status due to prolonged or unresolved conditions.

#### Actions

1. **Daily triage**
   - Review the Early Warning table each day
   - Categorize vehicles by root cause:
     - Operational
     - Payment-related

2. **Cross-functional task force**
   - Hold weekly Fleet Operations and Collections reviews

3. **Status-duration escalation**
   - Automatically escalate vehicles remaining in a single unresolved status for more than **30 days**

**Target:** Reduce early-warning vehicles from **3,334 to &lt;1,500**, or approximately **20% of fleet**.

---

### F. Collections Risk Stratification

**Problem:** Approximately **35% of vehicles are more than 7 DPD**, while collections resources are distributed broadly.

#### Actions

1. **Risk-based routing**
   - High/Critical risk → Senior collectors
   - Low/Medium risk → Junior collectors or automated outreach

2. **Proactive outreach**
   - Contact accounts at **3 DPD** when operational-instability indicators are also present

3. **Recovery protocols**
   - For vehicles over **30 DPD** with unresolved operational issues, evaluate asset recovery instead of prolonged collections activity

**Target:** Reduce 7+ DPD from **35% to &lt;20% within 90 days**.

---

## Strategic Initiatives: 90+ Days

### G. Predictive Maintenance & Brand Rationalization

**Problem:** Certain brands consistently demonstrate longer workshop turnaround times.

#### Actions

1. **Brand performance analysis**
   - Rank brands using workshop-turnaround performance

2. **Purchasing policy**
   - Deprioritize brands averaging more than **180 workshop days**

3. **Predictive maintenance pilots**
   - Implement preventive-maintenance programs for high-performing vehicle configurations

**Target:**

- Reduce workshop visit frequency by **25%**
- Reduce average workshop turnaround to **&lt;45 days**

---

### H. Inventory Turnover Optimization

**Problem:** A **0.64 turnover rate** indicates fleet inventory cycles slower than monthly.

#### Actions

1. **Dynamic pricing**
   - Use variable pricing to accelerate assignment of vehicles aged more than **60 days**

2. **Assignment incentives**
   - Reward assignment of existing idle inventory instead of new-purchase requests

3. **Fleet right-sizing**
   - If turnover consistently reaches **1.2+**, evaluate whether fleet size can be reduced without sacrificing revenue

**Target:** Achieve **1.0+ monthly inventory turnover**, then evaluate fleet optimization.

---

### I. Integrated Operations Dashboard Adoption

**Problem:** Operational silos prevent cross-functional problem-solving.

#### Actions

1. **Weekly executive review**
   - CEO
   - Fleet
   - Operations
   - Collections

   Leadership reviews the same dashboard and jointly resolves cross-functional bottlenecks.

2. **KPI scorecards**

| Function | Primary KPI |
|---|---|
| Fleet Managers | Unproductive Fleet % |
| Operations | Days to Assignment |
| Collections | 7+ DPD Rate |

3. **Data literacy training**
   - Train managers to interpret dashboard metrics and act without unnecessary escalation

**Target:** Establish the dashboard as the **primary operational management tool**.

---

## 5. Expected Outcomes: 12 Months

| KPI | Current | 12-Month Target | Expected Improvement |
|---|---:|---:|---|
| **Unproductive Fleet** | 52% | &lt;30% | 1,700+ vehicles moved to productive status |
| **Inventory Turnover** | 0.64 | 1.2+ | 87% increase in fleet velocity |
| **Days to Assignment** | 31 days | &lt;12 days | 19 additional revenue days per vehicle |
| **Workshop Turnaround** | 196 days | &lt;45 days | 151 days of downtime eliminated per visit |
| **7+ DPD Rate** | 35% | &lt;15% | 57% reduction in default exposure |
| **Early Warning Vehicles** | 3,334 | &lt;1,000 | 70% reduction in at-risk assets |

---
