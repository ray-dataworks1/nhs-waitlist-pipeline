# MediMart: NHS Waitlist Analytics Accelerator

## Project Summary

**MediMart** is an end-to-end NHS analytics accelerator, built as a simulated MVP to demonstrate modern, stakeholder-driven analytics engineering in UK healthcare. The project models the real-world elective care journey—from GP referral to Trust waitlist and final treatment—surfacing overdue cases, risk-stratified backlogs, and operational capacity mismatches for Trusts and ICSs.

**This repo demonstrates:**
- Migrating from legacy NHS/Power BI workflows to modern, modular analytics pipelines.
- Clear, testable logic with explainable metrics and “data lineage” at every stage.
- Rapid prototyping with UK NHS-inspired, fully synthetic data—optimized for analytics, not anonymisation.

---
📌 Project at a Glance

🚀 Tech Stack: dbt + Snowflake + PlantUML (docs)

📊 Data Model: 8 staging, 6 intermediate, 3 marts, 4 seeds

✅ Core Deliverables: fct_waitlist (unified waitlist fact), fct_capacity_audit (capacity vs. demand), specialty + patient dimensions

🔎 Stakeholders: NHS Trust Clinical Leads, ICS Operations Managers

🔬 Known Issues / Next Steps

Nulls → specialty_sk contains nulls due to incomplete reference data; would resolve with enforced FK constraints + cleaning seed table.

Row inflation → fct_capacity_audit row counts inflated due to non-unique join; next step is surrogate key + distincts in upstream CTE.

Test coverage → Currently running not_null + unique; need to add relationships + accepted_values.

Dashboard gap → Mart outputs not yet visualised in Metabase/Power BI; next step is producing breach rate + backlog dashboards.

Future Enhancements

Incremental waitlist model for real-time refreshes

Social determinants + patient experience metrics

Spatial analytics at ICS/Trust level

📝 Lessons Learned

Designed fact/dimension model around real NHS stakeholder questions (breaches, capacity, risk).

Debugged null + runaway joins using row audits + surrogate keys.

Learned to trade off between “perfect pipeline” vs. “document and ship.”

## Data Provenance & Project Design

All data is **synthetic and UK-centric** (not Synthea/US-based), hand-crafted to reflect NHS structures, naming, and regional conventions.  
Core datasets include patients, GP referrals, Trusts, appointments, conditions, and procedures.  
Data is designed for rapid analytics prototyping and dashboarding. See [`/data`](./data) for full CSVs.

---

## Strategic Objectives

- **Reduce overdue elective cases:** Surface breaches and enable targeted interventions.
- **Prioritise high-risk patients:** Drive fair, clinically-informed stratification and reporting.
- **Reveal and resolve capacity mismatches:** Give operations teams a true view of backlog, resource gaps, and appointment/slot alignment.

---

## Stakeholder Personas

**Dr. Aisha Patel — Clinical Lead, NHS Trust**  
> “I need reliable, up-to-date visibility of patients breaching wait times, so we can intervene before outcomes deteriorate. Risk scoring must be clinically fair—not just a numbers game.”

**Ms. Emily Smith — ICS Operations Manager**  
> “I’m responsible for making sure our Trusts allocate resources efficiently. I want to track risk by site, condition, and tier, and spot where capacity isn’t meeting demand.”

---

## Stakeholder Discovery

| Area               | Stakeholder Question                                                     | Why It Matters                          |
|--------------------|--------------------------------------------------------------------------|-----------------------------------------|
| **Overdue Cases**  | Which patients have breached their expected wait time?                   | Prevents deteriorating outcomes         |
|                    | What are the common causes of delay?                                    | Surfaces fixable inefficiencies         |
|                    | Can we define a KPI to reduce breaches?                                 | Enables measurable improvements         |
| **Risk Backlogs**  | How many high-risk patients are in backlog?                             | Ensures fairness in prioritisation      |
|                    | Are delays/cancellations more likely for high-risk groups?              | Measures equity, guides resource use    |
| **Capacity**       | Are appointments aligning with demand?                                  | Assesses capacity planning in real-time |
|                    | Where are overbookings/cancellations most common?                       | Highlights operational bottlenecks      |
|                    | Would more non-clinical support help?                                   | Explores interventions, cost savings    |

---

## Data Model

**Key Tables:**
- `patients`: Patient master data (risk, demographic, etc.)
- `gp`: GP/practice registry
- `referrals`: Primary care referrals to Trusts (with urgency and specialty)
- `trusts`: NHS Trust (hospital/ICS) registry
- `appointments`: Elective care bookings, wait tracking
- `procedures`: Planned/performed treatments
- `conditions`: Comorbidities/risk drivers

*See [`/docs/NHS_Waitlist_ERD.png`](./docs/NHS_Waitlist_ERD.png) for a data model diagram.*

---

## Migration Story: From Legacy to Modern Analytics
**Legacy Workflow:**
- Data scattered across Excel, on-prem SQL Server, and unversioned Power BI reports.
- Hand-coded, hard-to-audit SQL queries/views; lineage unclear; slow to adapt.
- Reporting and “single source of truth” logic is buried in disparate tools.

**Modern AE/DE Workflow:**
- All data loaded to warehouse and version-controlled with modular SQL/dbt models.
- Fact and dimension tables built for transparency, reproducibility, and rapid analytics.
- Stakeholder and ops needs drive data model, not legacy IT constraints.
- All transformations, lineage, and metric definitions fully documented and auditable.

---

## MVP Deliverables

| Module                 | Description                                                    |
|------------------------|----------------------------------------------------------------|
| `stg_patients`         | Cleaned and deduped patient data                               |
| `stg_appointments`     | Appointment/capacity event staging                             |
| `stg_referrals`        | Normalised GP referral journey                                 |
| `fct_waitlist`         | Unified waitlist fact table (core reporting layer)             |
| `dim_specialty`        | Specialities, cleaned and deduped                              |
| `fct_capacity_audit`   | Planned vs actual capacity audit for ops teams                 |

---

## Folder Structure

/data 
 Synthetic NHS-like CSVs for analytics

/models
dbt/SQL models for all layers

/staging 
Staging queries (legacy and modern stack examples)

/intermediate 
Intermediate/mart logic

/marts 
Final reporting tables

/docs 
Data model diagrams, stakeholder briefs, Q&A

/legacy 
Legacy SQL, sample Power BI/Excel exports

---

## Pain Points (Legacy)

- Relationships managed by opaque IDs, with little/no lineage or modularity.
- Logic and metric definitions buried in unversioned SQL/Power BI.
- High ramp-up for new/junior data engineers and slow iteration cycles.

---

## Implementation Notes

- **Platform:** SQL Server (legacy); dbt + BigQuery/Snowflake (modern)
- **Dashboards:** Power BI/Excel (legacy); Metabase/Tableau (modern)
- **Docs:** Markdown, PlantUML diagrams, and stakeholder requirements briefs.

---

## Technical Q&A Cheat Sheet

**Q: How did you define risk?**  
A: Age, comorbidity count, and prior admissions, with cohort assignment logic documented and adjustable.

**Q: What data did you use?**  
A: All data is synthetic, hand-crafted for analytics prototyping with UK NHS structure, *not* US Synthea.

**Q: How would you scale for a real Trust?**  
A: Modular data models can be adapted for any Trust; clinical validation and data pipeline automation are next steps.




---

## Setup Instructions

1. Clone the repo  
2. Load `/data/*.csv` into your warehouse or local database  
3. Run all staging, intermediate, and mart models in order  
4. Explore `/legacy/` for example legacy scripts and exports  
5. For dbt:
   ```bash
   dbt debug
   dbt run
   dbt test
   dbt docs generate && dbt docs serve
Future Development
Add social determinants, experience metrics, and spatial analytics

Prototype chatbot/ops support for admin staff

Expand with real NHS logic if given secure access (for demo purposes, only synthetic data used)

For details on stakeholder requirements and lineage, see /docs/stakeholder-requirements.md.
