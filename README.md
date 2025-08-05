# MediMart: NHS Elective Surgery Waitlist Analytics Accelerator (Internal MVP)

## Project Summary
This project is a simulated internal MVP for Kubrick, designed to demonstrate stakeholder-driven analytics engineering for NHS healthcare clients. It surfaces overdue elective cases, risk-stratified backlogs, and capacity mismatches to support Trusts and ICSs in operational decision-making.  

### Data Source:
This project uses the Synthea synthetic health dataset. All tables are generated using Synthea and contain no real patient information, the stack will reflect legacy tooling used within the NHS and reflect on pain points and areas for improvement. This ensures GDPR/HIPAA compliance and allows safe, large-scale analytics engineering with a realistic yet innovative edge.


## Strategic Objectives
- Identify and reduce overdue elective cases.
- Prioritise high-risk patients using clinically-informed stratification.
- Reveal and mitigate capacity mismatches in elective care pathways.

## Stakeholder Personas

**Dr. Aisha Patel** — Clinical Lead, NHS Trust  
> *"I need a reliable, up-to-date view of which patients are breaching wait times, so we can intervene before outcomes deteriorate. I also need to ensure risk scoring is clinically fair—not just a numbers game."*

**Ms. Emily Smith** — Integrated Care Systems (ICS) Operations Manager  
> *"I’m responsible for ensuring our Trust is allocating resources efficiently across specialties. I want to track backlog risk by site, condition, and risk tier, and identify where capacity isn't meeting demand."*

## Stakeholder Discovery

| Area                | Stakeholder Question                                                     | Why It Matters                                         |
|---------------------|--------------------------------------------------------------------------|--------------------------------------------------------|
| **Overdue Cases**   | Which elective surgery patients have breached their expected wait time?  | Identifies patients at risk of deteriorating outcomes. |
|                     | What are the most common causes of delay?                               | Surfaces inefficiencies for resourcing decisions.      |
|                     | Can we define a KPI to reduce overdue cases?                            | Enables trackable improvement plans.                   |
|                     | Are there patterns in delay by Trust, specialty, or team?               | Supports targeted interventions.                       |
| **Risk Backlogs**   | How many patients in the backlog are clinically high-risk?              | Enables fair prioritisation.                           |
|                     | % of high-risk patients delayed/cancelled/DNAs?                         | Measures equity and quality of care.                   |
|                     | How robust is the risk model logic?                                     | Ensures fairness and clinical trust.                   |
| **Capacity**        | Are appointment slots aligning with demand?                             | Assesses real-time capacity planning.                  |
|                     | Where are overbooking/cancellations most common?                        | Highlights bottlenecks and operational gaps.           |
|                     | Would intermediary (non-clinical) support help?                         | Explores low-cost interventions.                       |
|                     | How standardised is capacity logging?                                   | Improves data integrity.                               |

## Modelling Considerations
- **Overdue Logic:** Breach = RTT or local guidance + 1 week
- **Risk Stratification:** Includes response likelihood, comorbidity, and community care indicators where available.
- **Capacity Mismatch:** Relies on appointment logs, cancellation data, and treatment timestamps.

## MVP Deliverables

| Module               | Description                                              |
|----------------------|---------------------------------------------------------|
| `stg_patients`       | Staging model for raw/synthetic patient data            |
| `stg_appointments`   | Staging for appointment/capacity events                 |
| `fct_overdue_cases`  | Flags and reports overdue cases, Trust-level breakdowns |
| `dim_risk_cohort`    | Dimension for patient risk tiers                        |
| `fct_capacity_audit` | Compares planned vs actual capacity                     |

## Folder Structure

/data # Synthetic data or schemas
/models
/staging
/intermediate
/marts
/docs # Data model diagram, stakeholder brief



## Future Development
- Incorporate external data (social determinants, GP flags)
- Patient experience analysis
- Spatial analysis (patient proximity to hospitals)

## [Data Model Diagram Placeholder]
*(See `/docs/data_model.png`)*


---

## **Technical Q&A Cheat Sheet**

**Q: “How did you define risk?”**  
A:  
> “For the MVP, I used age, comorbidity count, and recent admissions as risk factors, but designed the pipeline to be flexible so clinical input can update the rules.”

**Q: “What data did you use?”**  
A:  
> “All data was synthetic, generated to mimic real NHS elective surgery waitlists. No real patient info—fully GDPR safe.”

**Q: “How would you scale this for a real Trust?”**  
A:  
> “The modular dbt models and documentation are designed for handover. Next steps would be data pipeline automation and a clinical validation phase with NHS stakeholders.”

## Tools Used

- Microsoft SQL Server
- Power BI
- Git / GitHub
- Markdown (docs)


## Pain Points
Notice: all relationships are handled by raw IDs: no modularity, hard to trace lineage, difficult to extend.

All transformations must be hand-coded in stored procs/views, making them very hard to audit and less friendly for ramping up junior data and analytics engineers in any team production environment.

Power BI dashboards are disconnected from source versioning, and therefore functions as a disparate source of truth, less visible, iteratable and automatable in team environments.

## Implementation Notes
- Built in SQL Server with modular handcoded models.
- Designed for handover and extension by NHS data teams.
- All logic and requirements documented for transparency.
- 
## Stakeholder Discovery

See [`stakeholder-requirements.md`](./stakeholder-requirements.md)

## Setup Instructions

1. Clone the repo  
2. Set up your dbt profile for BigQuery  
3. Run:  
   ```bash
   dbt debug
   dbt run
   dbt test
   dbt docs generate && dbt docs serve
