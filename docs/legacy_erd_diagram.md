# NHS Waitlist ERD


```plantuml

@startuml 
entity "patients" as patients {
  *patient_id : int <<PK>>
  nHS_number : string
  first_name : string
  last_name : string
  dob : date
  gender : string
  postcode : string
  ethnicity : string
  risk_level : string
}

entity "gp" as gp {
  *gp_id : int <<PK>>
  gp_name : string
  practice_name : string
  practice_postcode : string
}

entity "trusts" as trusts {
  *trust_id : int <<PK>>
  trust_name : string
  region : string
}

entity "referrals" as referrals {
  *referral_id : int <<PK>>
  patient_id : int <<FK>>
  gp_id : int <<FK>>
  referral_date : date
  specialty : string
  reason : string
  referral_status : string
  trust_id : int <<FK>>
  notes : string
}

entity "appointments" as appointments {
  *appointment_id : int <<PK>>
  patient_id : int <<FK>>
  trust_id : int <<FK>>
  specialty : string
  appt_date : date
  appt_status : string
  referral_date : date
  wait_weeks : int
}

entity "procedures" as procedures {
  *procedure_id : int <<PK>>
  patient_id : int <<FK>>
  procedure_name : string
  planned_date : date
  actual_date : date
  status : string
}

entity "conditions" as conditions {
  *condition_id : int <<PK>>
  patient_id : int <<FK>>
  condition_name : string
  severity : string
  active : string
}

patients ||--o{ referrals : "has"
gp ||--o{ referrals : "makes"
trusts ||--o{ referrals : "receives"

patients ||--o{ appointments : "books"
trusts ||--o{ appointments : "provides"

patients ||--o{ procedures : "undergoes"
patients ||--o{ conditions : "has"


@enduml
