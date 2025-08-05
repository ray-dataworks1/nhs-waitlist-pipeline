import pandas as pd
import numpy as np
import random
from faker import Faker
from faker.providers import person, address, date_time
from datetime import datetime, timedelta

fake = Faker('en_GB')
Faker.seed(2024)
random.seed(2024)
np.random.seed(2024)

# 1. Trusts
trust_names = [
    'North London NHS Trust', 'Cambridge University Hospitals', 'South Thames NHS Trust',
    'West Midlands University Hospitals', 'East London NHS Trust', 'Norfolk & Norwich University Hospitals'
]
trust_regions = ['London', 'East', 'London', 'West Midlands', 'London', 'East']
trust_postcodes = ['N1 1AA', 'CB2 0QQ', 'SE1 6JP', 'B15 2TH', 'E1 4DG', 'NR4 7UY']

trusts = pd.DataFrame({
    'ID': range(1, 7),
    'name': trust_names,
    'region': trust_regions,
    # (could add postcode, left out for simplicity)
})

# 2. GPs
gp_names = [
    "Dr Sarah Hussain", "Dr Michael Evans", "Dr Priya Patel", "Dr James O'Connor", "Dr Louise Edwards",
    "Dr Andrew Chan", "Dr Fatima Begum", "Dr Oliver Wright", "Dr Emily Brown", "Dr Daniel Walker"
]
gp_practices = [
    "The Limes Medical Centre", "City Health Surgery", "West End Practice", "St Mary's Group", "Oak Tree Surgery",
    "Riverside Medical Practice", "Green Lane Surgery", "Eastfield Health Centre", "Cambridge Road Surgery", "Chadwell Health Practice"
]
gp_postcodes = ['E17 7JN', 'CB1 3DF', 'SE5 8AZ', 'N4 2JJ', 'E1 5AW', 'CB4 2NF', 'E13 8SL', 'CB2 1PH', 'E10 7HQ', 'E18 1AB']

gps = pd.DataFrame({
    'ID': range(1, 11),
    'name': gp_names,
    'practice': gp_practices,
    'postcode': gp_postcodes
})

# 3. Patients
ethnicities = [
    "White British", "Black African", "Black Caribbean", "South Asian", "East Asian", "Mixed", "Other"
]
genders = ['Male', 'Female', 'Other']
london_postcodes = ['E17 7JN', 'E5 0BP', 'N1 1AA', 'E1 4DG', 'SE1 6JP', 'E13 8SL', 'E10 7HQ', 'E18 1AB', 'N4 2JJ', 'E1 5AW']
cambridge_postcodes = ['CB1 3DF', 'CB2 0QQ', 'CB4 2NF', 'CB2 1PH']
other_postcodes = ['B15 2TH', 'NR4 7UY']

# Age distribution: 25% elderly (70+), 35% adult (40-69), 30% young adult (18-39), 10% child (under 18)
def dob_by_age_band():
    band = np.random.choice(['elderly', 'adult', 'young_adult', 'child'], p=[0.25, 0.35, 0.3, 0.1])
    today = datetime.today()
    if band == 'elderly':
        return (today - timedelta(days=random.randint(70*365, 92*365))).date()
    elif band == 'adult':
        return (today - timedelta(days=random.randint(40*365, 69*365))).date()
    elif band == 'young_adult':
        return (today - timedelta(days=random.randint(18*365, 39*365))).date()
    else:
        return (today - timedelta(days=random.randint(2*365, 17*365))).date()

def assign_risk(age, comorbidity_count):
    # Age + comorbidities for risk (simple heuristic)
    if age >= 70 or comorbidity_count >= 3:
        return 'High'
    elif age >= 40 or comorbidity_count == 2:
        return 'Medium'
    else:
        return 'Low'

patient_rows = []
for pid in range(1, 301):
    first = fake.first_name()
    last = fake.last_name()
    nhs_number = ''.join([str(random.randint(1, 9)) for _ in range(10)])
    dob = dob_by_age_band()
    gender = np.random.choice(genders, p=[0.48, 0.5, 0.02])
    ethnicity = np.random.choice(ethnicities, p=[0.56, 0.14, 0.08, 0.13, 0.04, 0.04, 0.01])
    all_postcodes = london_postcodes + cambridge_postcodes + other_postcodes
    postcode_probs = (
    [0.6/len(london_postcodes)] * len(london_postcodes) +
    [0.25/len(cambridge_postcodes)] * len(cambridge_postcodes) +
    [0.15/len(other_postcodes)] * len(other_postcodes)
    )
    postcode = np.random.choice(all_postcodes, p=postcode_probs)

    patient_rows.append({
        'ID': pid,
        'nhs_number': nhs_number,
        'first_name': first,
        'last_name': last,
        'DOB': dob.strftime('%d/%m/%Y'),
        'gender': gender,
        'postcode': postcode,
        'ethnicity': ethnicity,
        # risk_level assigned after conditions added
        'risk_level': None
    })
patients = pd.DataFrame(patient_rows)

# 4. Conditions
condition_list = [
    ("Hypertension", ["Mild", "Moderate", "Severe"]),
    ("Type 2 Diabetes", ["Mild", "Moderate", "Severe"]),
    ("Asthma", ["Mild", "Moderate", "Severe"]),
    ("COPD", ["Mild", "Moderate", "Severe"]),
    ("Depression", ["Mild", "Moderate", "Severe"]),
    ("Chronic Kidney Disease", ["Stage 1", "Stage 2", "Stage 3"]),
    ("Osteoarthritis", ["Mild", "Moderate", "Severe"]),
    ("Cancer", ["Remission", "Active", "Advanced"]),
    ("Obesity", ["Class I", "Class II", "Class III"]),
    ("Heart Failure", ["Mild", "Moderate", "Severe"])
]
condition_names = [c[0] for c in condition_list]

condition_rows = []
patient_comorbidities = {}
for pid in patients['ID']:
    n_conditions = np.random.choice([1, 2, 3], p=[0.50, 0.35, 0.15])
    conds = random.sample(condition_list, n_conditions)
    patient_comorbidities[pid] = n_conditions
    for cname, severities in conds:
        cond_row = {
            'ID': len(condition_rows) + 1,
            'patient_id': pid,
            'condition_name': cname,
            'severity': np.random.choice(severities),
            'active': np.random.choice(['Yes', 'No'], p=[0.75, 0.25])
        }
        condition_rows.append(cond_row)
conditions = pd.DataFrame(condition_rows)

# Update risk_level in patients
def get_patient_age(dob_str):
    dob = datetime.strptime(dob_str, '%d/%m/%Y')
    today = datetime.today()
    return (today - dob).days // 365

for i, row in patients.iterrows():
    age = get_patient_age(row['DOB'])
    comorbidity_count = patient_comorbidities[row['ID']]
    patients.at[i, 'risk_level'] = assign_risk(age, comorbidity_count)

# Rebalance for high/medium/low per requirement
# (Could forcibly adjust if necessary. For now, rely on the above for realism.)

# 5. Referrals
specialties = [
    "Cardiology", "Endocrinology", "Respiratory Medicine", "Rheumatology",
    "Orthopaedics", "Gastroenterology", "Neurology", "Urology",
    "General Surgery", "Dermatology"
]
reasons = [
    "Uncontrolled blood pressure", "Chronic joint pain", "Suspected cancer", "Poor glycaemic control",
    "Breathlessness", "Abnormal ECG", "Kidney function decline", "Unexplained weight loss",
    "Recurrent infections", "Chest pain"
]
statuses = ["Open", "Closed", "Pending", "Rejected"]

referral_rows = []
patient_referrals = {}  # Track referrals per patient
for pid in patients['ID']:
    n_refs = np.random.choice([1, 2], p=[0.7, 0.3])
    patient_referrals[pid] = []
    for _ in range(n_refs):
        gp_id = np.random.randint(1, 11)
        trust_id = np.random.randint(1, 7)
        specialty = np.random.choice(specialties)
        reason = np.random.choice(reasons)
        referral_date = fake.date_between(start_date='-2y', end_date='today')
        status = np.random.choice(statuses, p=[0.7, 0.1, 0.15, 0.05])
        # Blank notes about 20%, short string otherwise
        notes = fake.sentence(nb_words=8) if np.random.rand() > 0.2 else ""
        ref_row = {
            'ID': len(referral_rows) + 1,
            'patient_id': pid,
            'gp_id': gp_id,
            'referral_date': referral_date.strftime('%d/%m/%Y'),
            'specialty': specialty,
            'reason': reason,
            'referral_status': status,
            'trust_id': trust_id,
            'notes': notes
        }
        referral_rows.append(ref_row)
        patient_referrals[pid].append(len(referral_rows))  # Referral ID

referrals = pd.DataFrame(referral_rows)

# 6. Appointments
appt_statuses = ["Scheduled", "Completed", "Cancelled", "Overdue", "No-show"]
appointments_rows = []

for i, ref in referrals.iterrows():
    # Each referral gets 1–2 appointments, some overdue
    n_appts = np.random.choice([1, 2], p=[0.7, 0.3])
    ref_date = datetime.strptime(ref['referral_date'], '%d/%m/%Y')
    for j in range(n_appts):
        # Calculate plausible appt date
        wait_weeks = np.random.randint(2, 52)
        appt_date = ref_date + timedelta(weeks=wait_weeks)
        # Status: overdue if wait > 18 weeks and not completed, else random
        if wait_weeks > 18 and np.random.rand() < 0.4:
            appt_status = "Overdue"
        else:
            appt_status = np.random.choice(appt_statuses, p=[0.4, 0.35, 0.1, 0.05, 0.1])
        # Edge: 10% mismatched specialty
        appt_specialty = ref['specialty'] if np.random.rand() > 0.1 else np.random.choice(specialties)
        appointments_rows.append({
            'ID': len(appointments_rows) + 1,
            'patient_id': ref['patient_id'],
            'trust_id': ref['trust_id'],
            'specialty': appt_specialty,
            'appt_date': appt_date.strftime('%d/%m/%Y'),
            'appt_status': appt_status,
            'referral_date': ref['referral_date'],
            'wait_weeks': wait_weeks
        })

appointments = pd.DataFrame(appointments_rows)

# 7. Procedures (not every referral has a procedure)
procedure_names = [
    "Hip Replacement", "Angioplasty", "Colonoscopy", "Echocardiogram", "Cataract Surgery",
    "Biopsy", "Gastroscopy", "Arthroscopy", "Pacemaker Insertion", "Renal Dialysis"
]
proc_statuses = ["Completed", "Planned", "Cancelled", "Delayed"]
procedures_rows = []

# Assign to about 45% of referrals, and some edge cases (cancelled, missing actual_date, etc)
for i, ref in referrals.iterrows():
    if np.random.rand() < 0.45:
        patient_id = ref['patient_id']
        proc_name = np.random.choice(procedure_names)
        planned_date = datetime.strptime(ref['referral_date'], '%d/%m/%Y') + timedelta(weeks=np.random.randint(4, 36))
        # 10% missing actual_date
        status = np.random.choice(proc_statuses, p=[0.55, 0.2, 0.15, 0.1])
        actual_date = None
        if status == "Completed":
            delay_weeks = np.random.randint(0, 8)
            actual_date = planned_date + timedelta(weeks=delay_weeks)
        elif status == "Delayed":
            actual_date = planned_date + timedelta(weeks=np.random.randint(8, 26))
        elif status == "Cancelled":
            if np.random.rand() < 0.7:
                actual_date = ""
            else:
                actual_date = planned_date + timedelta(weeks=np.random.randint(1, 12))
        else:
            actual_date = "" if np.random.rand() < 0.6 else planned_date + timedelta(weeks=np.random.randint(1, 8))
        procedures_rows.append({
            'ID': len(procedures_rows) + 1,
            'patient_id': patient_id,
            'procedure_name': proc_name,
            'planned_date': planned_date.strftime('%d/%m/%Y'),
            'actual_date': "" if actual_date in [None, ""] else actual_date.strftime('%d/%m/%Y'),
            'status': status
        })

procedures = pd.DataFrame(procedures_rows)

# --- CSV OUTPUT ---
patients.to_csv('patients.csv', index=False)
gps.to_csv('gp.csv', index=False)
trusts.to_csv('trusts.csv', index=False)
referrals.to_csv('referrals.csv', index=False)
appointments.to_csv('appointments.csv', index=False)
procedures.to_csv('procedures.csv', index=False)
conditions.to_csv('conditions.csv', index=False)

print("Synthetic NHS dataset generated! (patients.csv, gp.csv, trusts.csv, referrals.csv, appointments.csv, procedures.csv, conditions.csv)")
