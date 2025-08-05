## You are an NHS analytics consultant. Generate a synthetic, realistic NHS elective care dataset for analytics prototyping, using the following ERD:

- patients (ID, NHS number, names, DOB, gender, postcode, ethnicity, risk_level)
- gp (ID, name, practice, postcode)
- trusts (ID, name, region)
- referrals (ID, patient_id, gp_id, referral_date, specialty, reason, referral_status, trust_id, notes)
- appointments (ID, patient_id, trust_id, specialty, appt_date, appt_status, referral_date, wait_weeks)
- procedures (ID, patient_id, procedure_name, planned_date, actual_date, status)
- conditions (ID, patient_id, condition_name, severity, active)

## Data requirements:
- 300 patients (UK names, realistic ages, diverse ethnicity and postcodes from London, Cambridge, etc.)
- 10 GPs, 6 Trusts (plausible names, real UK postcodes, mix of regions)
- Each patient: 1–3 conditions (comorbidities, severity, active/inactive), randomised
- Each patient: 1–2 referrals (mix of specialties, dates, statuses), assigned via GPs to Trusts
- Appointments: varied status (Scheduled, Completed, Cancelled, Overdue, No-show), some overdue (>18 weeks), some no-show/cancelled, some completed on time, with wait_weeks calculated from referral to appt_date
- Procedures: assigned to subset of referrals, with realistic delays between planned/actual dates, some cancelled or delayed
- Demographics: realistic gender/ethnicity/risk_level mix; 25% high-risk (age, comorbidities), 50% medium, 25% low
- Edge cases: multi-referral patients, procedures cancelled, patients changing Trusts, patients with missing or conflicting postcodes/GPs
- Include plausible real-world data issues: blank notes, some nulls in actual_date for planned procedures, occasional mismatch in referral/appt specialty
- Use real NHS specialties, common referral reasons, UK date formats, and plausible status/progressions

## Output:
- CSVs for each table (patients.csv, gp.csv, trusts.csv, referrals.csv, appointments.csv, procedures.csv, conditions.csv) with headers
- Data must be **UK NHS-styled** (not US Synthea) and designed for analytics prototyping, not anonymisation

## Goal:
Support analytics questions on overdue cases, risk stratification, capacity, and equity, as in the README above.