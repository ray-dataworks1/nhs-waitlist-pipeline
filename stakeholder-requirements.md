# Stakeholder Discovery: NHS Elective Surgery Waitlists

**Project Goal:**  
Develop a modular analytics engineering pipeline to surface overdue elective cases, risk-stratified backlogs, and capacity mismatches across NHS Trusts.

---

## 1. Strategic Objectives

This project aims to empower Trusts, Integrated Care Systems (ICSs), and operational teams to:

- Identify and reduce overdue elective cases.
- Prioritise high-risk patients through fair, clinically informed stratification.
- Reveal and mitigate capacity mismatches in elective care pathways.

---

## 2. Stakeholder Key Questions

### Overdue Cases

| Stakeholder Question | Why It Matters |
|----------------------|----------------|
| Which elective surgery patients have breached their expected wait time? | Identifies patients at risk of deteriorating outcomes. |
| What are the most common causes of delay (e.g. clinician backlog, admin error)? | Surfaces root causes of inefficiency and informs resourcing decisions. |
| Can we define a KPI to reduce overdue cases by x% over y months? | Enables trackable improvement plans and performance management. |
| Are there patterns in delay by Trust, specialty, or clinical team? | Supports targeted interventions and workforce planning. |

### Risk-Stratified Backlogs

| Stakeholder Question | Why It Matters |
|----------------------|----------------|
| How many patients in the elective backlog are clinically high-risk? | Enables prioritisation for those with greatest clinical urgency. |
| What percentage of high-risk patients are experiencing delays, cancellations, or DNAs? | Measures the quality and equity of the care pipeline. |
| How are risk models defined, and do they account for response likelihood, condition progression, or community care pathways? | Ensures fairness and clinical relevance in stratification logic. |
| Can backlog trends be broken down by Trust, condition type, and risk tier? | Supports strategic ICS-wide planning and triage. |

### Capacity Mismatches

| Stakeholder Question | Why It Matters |
|----------------------|----------------|
| Are appointment slots aligning with the volume of required treatment? | Assesses whether capacity planning meets real-time need. |
| Where are overbooking, under-utilisation, or reactive cancellations most common? | Highlights operational gaps and potential staff bottlenecks. |
| Would introducing intermediary (non-clinical) support improve treatment throughput? | Explores low-cost, high-impact interventions to improve flow. |
| How accurate and standardised is capacity logging across sites? | Improves data integrity and comparability across Trusts. |

---

## 3. Modelling Considerations

- **Overdue Logic:** A breach is defined as a case that exceeds RTT or local wait time guidance by more than one week.
- **Risk Stratification:** Basic gap analyses may omit complexity. A more robust model should include response likelihood, community care indicators, and clinician input.
- **Capacity Mismatch:** Requires reliable access to appointment logs, cancellation metadata, and treatment timestamps.

---

## 4. MVP Deliverables

| Module | Description |
|--------|-------------|
| `fct_overdue_cases` | Model to flag and report on overdue patients, with Trust-level breakdowns. |
| `dim_risk_cohort` | Joinable dimension table containing risk tier metadata per patient. |
| `fct_capacity_audit` | Model comparing planned vs actual capacity, highlighting mismatches. |

---

## 5. Notes for Future Development

- Expand risk stratification to incorporate external data sources (e.g. social determinants, primary care flags).
- Integrate patient experience data for richer context behind delays or cancellations.
- Incorporate spatial analysis (e.g. patient proximity to hospitals) to inform regional planning.

---

## Summary

This project applies core analytics engineering principles to a clinically sensitive use case within the NHS. The outlined workflow integrates domain knowledge with modular, testable models to improve transparency and patient outcomes across elective surgery pathways.
