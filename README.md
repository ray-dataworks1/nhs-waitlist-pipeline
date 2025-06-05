# NHS Waitlist Pipeline

A modular analytics engineering project focused on elective surgery waitlists across NHS Trusts. Built using dbt Core and BigQuery.

## Project Goals

- Surface overdue elective surgery cases across sites and specialties.
- Model risk-stratified backlogs to inform prioritisation.
- Detect capacity mismatches using operational data.

## Key Models

| Model | Purpose |
|-------|---------|
| `stg_waitlist` | Clean and standardise source waitlist data |
| `fct_overdue_cases` | Flag overdue patients based on RTT rules |
| `dim_risk_cohort` | Risk classification by tier |
| `fct_capacity_audit` | Tracks mismatch between demand and treatment slots |

## Tools Used

- [dbt Core](https://docs.getdbt.com/)
- BigQuery (Warehouse)
- Git / GitHub
- Markdown (docs)

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
