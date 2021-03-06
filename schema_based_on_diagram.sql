CREATE TABLE patients (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR,
  date_of_birth DATE
);

CREATE TABLE medical_histories (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  admitted_at TIMESTAMP,
  patient_id INT,
  status VARCHAR,
  CONSTRAINT fk_patients
    FOREIGN KEY(patient_id)
      REFERENCES patients(id)
);

CREATE INDEX patient_id_asc ON medical_histories(patient_id ASC);

CREATE TABLE treatments (
  id INT PRIMARY KEY GENERATED ALWAYS AS DEFAULT,
  type VARCHAR,
  name VARCHAR
);

CREATE TABLE invoices (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history_id INT REFERENCES medical_histories(id)
);

CREATE TABLE invoice_items (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  unit_price DECIMAL,
  quantity INT,
  total_price DECIMAL,
  invoice_id INT REFERENCES invoices(id),
  treatment_id INT REFERENCES treatments(id)
);

CREATE INDEX invoice_id_asc ON invoice_items(invoice_id ASC);
CREATE INDEX treatment_id_asc ON invoice_items(invoice_id ASC);

CREATE INDEX medical_histories_id_asc ON invoices(medical_history_id ASC);

-- Join tables
CREATE TABLE medical_histories_treatments(
  medical_history_id INT REFERENCES medical_histories(id),
  treatment_id INT REFERENCES treatments(id),
  PRIMARY KEY (medical_history_id, treatment_id)
);

CREATE INDEX medical_histories_treatments_mh_asc ON medical_histories_treatments(medical_history_id ASC);
CREATE INDEX medical_histories_treatments_ti_asc ON medical_histories_treatments(treatment_id ASC);

