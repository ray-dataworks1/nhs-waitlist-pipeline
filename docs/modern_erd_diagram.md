@startuml NHS_Waitlist_Modern

' ========= Dimensions =========
entity "dim_patient" as dim_patient {
  *patient_sk : int <<PK>>
  patient_id_nk : int
  nhs_number : string
  first_name : string
  last_name : string
  dob : date
  gender : string
  postcode : string
  ethnicity : string
  risk_level : string
}

entity "dim_gp" as dim_gp {
  *gp_sk : int <<PK>>
  gp_id_nk : int
  gp_name : string
  practice_name : string
  practice_postcode : string
}

entity "dim_trust" as dim_trust {
  *trust_sk : int <<PK>>
  trust_id_nk : int
  trust_name : string
  region : string
}

entity "dim_specialty" as dim_specialty {
  *specialty_sk : int <<PK>>
  specialty_name : string
}

entity "dim_condition" as dim_condition {
  *condition_sk : int <<PK>>
  condition_name : string
  severity : string
}

' ========= Facts / Events =========

' Grain: one row per referral event
entity "fct_referral" as fct_referral {
  *referral_sk : int <<PK>>
  referral_id_nk : int
  patient_sk : int <<FK>>
  gp_sk : int <<FK>>
  trust_sk : int <<FK>>
  specialty_sk : int <<FK>>
  referral_date : date
  referral_status : string
}

' Grain: one row per appointment
entity "fct_appointment" as fct_appointment {
  *appointment_sk : int <<PK>>
  appointment_id_nk : int
  patient_sk : int <<FK>>
  trust_sk : int <<FK>>
  specialty_sk : int <<FK>>
  referral_date : date
  appt_date : date
  appt_status : string
  wait_weeks : int
  overdue_flag : boolean
}

' Grain: one row per procedure instance
entity "fct_procedure" as fct_procedure {
  *procedure_sk : int <<PK>>
  procedure_id_nk : int
  patient_sk : int <<FK>>
  specialty_sk : int <<FK>>
  procedure_name : string
  planned_date : date
  actual_date : date
  status : string
  procedure_wait_days : int
}

' Optional bridge if you want many conditions per patient snapshot
entity "bridge_patient_condition" as bridge_pc {
  *patient_sk : int <<FK>>
  *condition_sk : int <<FK>>
  active_flag : boolean
  as_of_date : date
}

' Grain: one row per patient x specialty x trust x snapshot_date (status on that day)
entity "fct_waitlist_snapshot" as fct_waitlist_snapshot {
  *snapshot_date : date <<PK>>
  *patient_sk : int <<FK>><<PK>>
  *specialty_sk : int <<FK>><<PK>>
  trust_sk : int <<FK>>
  current_status : string  ' waiting / booked / completed / cancelled
  wait_weeks : int
  overdue_flag : boolean
}

' Grain: one row per trust x specialty x week
entity "fct_capacity_audit" as fct_capacity_audit {
  *week_start_date : date <<PK>>
  *trust_sk : int <<FK>><<PK>>
  *specialty_sk : int <<FK>><<PK>>
  slots_planned : int
  slots_attended : int
  cancellations : int
  fill_rate : decimal
}

' ========= Relationships =========
dim_patient ||--o{ fct_referral : "patient"
dim_gp      ||--o{ fct_referral : "gp"
dim_trust   ||--o{ fct_referral : "to trust"
dim_specialty ||--o{ fct_referral : "specialty"

dim_patient   ||--o{ fct_appointment : "patient"
dim_trust     ||--o{ fct_appointment : "at trust"
dim_specialty ||--o{ fct_appointment : "specialty"

dim_patient   ||--o{ fct_procedure : "patient"
dim_specialty ||--o{ fct_procedure : "specialty"

dim_patient   ||--o{ bridge_pc : "has"
dim_condition ||--o{ bridge_pc : "maps to"

dim_patient   ||--o{ fct_waitlist_snapshot : "patient"
dim_trust     ||--o{ fct_waitlist_snapshot : "trust"
dim_specialty ||--o{ fct_waitlist_snapshot : "specialty"

dim_trust     ||--o{ fct_capacity_audit : "trust"
dim_specialty ||--o{ fct_capacity_audit : "specialty"

@enduml
