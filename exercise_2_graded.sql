/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */
CREATE TABLE IF NOT EXISTS medication_stock (
    medication_id INT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS nurses (
    nurse_id SERIAL PRIMARY KEY,
    nurse_name VARCHAR(50) NOT NULL,
    shift VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS treatments (
    treatment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    nurse_id INT NOT NULL,
    treatment_type VARCHAR(100) NOT NULL,
    treatment_date TIMESTAMP NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (nurse_id) REFERENCES nurses(nurse_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS doctor_patient (
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    PRIMARY KEY (doctor_id, patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

INSERT INTO medication_stock (medication_id, medication_name, quantity)
VALUES 
(1, 'Aspirin', 50),
(2, 'Lisinopril', 30),
(3, 'Metformin', 20),
(4, 'Atorvastatin', 45),
(5, 'Paracetamol', 15);

INSERT INTO patients (patient_name, age)
VALUES 
('John Smith', 75), ('Mary Johnson', 82), ('Robert Davis', 78),
('Patricia Wilson', 85), ('Michael Brown', 72), ('Linda Taylor', 88),
('David Martinez', 69), ('Elizabeth Anderson', 76), ('William Thomas', 81),
('Jennifer Lee', 79);

INSERT INTO doctors (doctor_name, specialization)
VALUES 
('Dr. James Wilson', 'Cardiology'),
('Dr. Sandra Lee', 'Geriatrics'),
('Dr. Robert Chen', 'Cardiology'),
('Dr. Emily Davis', 'Neurology'),
('Dr. Michael Brown', 'Geriatrics');

INSERT INTO nurses (nurse_name, shift)
VALUES 
('Nurse Amy White', 'Morning'),
('Nurse Brian Green', 'Afternoon'),
('Nurse Catherine Black', 'Morning'),
('Nurse Daniel Gray', 'Night');

INSERT INTO doctor_patient (doctor_id, patient_id)
VALUES 
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5), (2, 6), (2, 7),
(3, 8), (3, 9), (3, 10), (3, 2), (3, 4),
(4, 1), (4, 5), (4, 7),
(5, 6), (5, 8), (5, 9), (5, 10), (5, 1);

INSERT INTO treatments (patient_id, doctor_id, nurse_id, treatment_type, treatment_date)
VALUES 
(1, 1, 1, 'Medication', '2024-01-05 09:30:00'::TIMESTAMP),
(2, 3, 3, 'Physiotherapy', '2024-01-06 10:15:00'::TIMESTAMP),
(3, 1, 2, 'Medication', '2024-01-05 14:20:00'::TIMESTAMP),
(4, 2, 1, 'Check-up', '2024-01-07 08:45:00'::TIMESTAMP),
(5, 4, 2, 'Medication', '2024-01-08 15:30:00'::TIMESTAMP),
(6, 5, 3, 'Physiotherapy', '2024-01-09 09:10:00'::TIMESTAMP),
(7, 2, 4, 'Check-up', '2024-01-10 20:00:00'::TIMESTAMP),
(8, 3, 1, 'Medication', '2024-01-11 09:50:00'::TIMESTAMP),
(9, 5, 3, 'Physiotherapy', '2024-01-12 10:20:00'::TIMESTAMP),
(10, 3, 2, 'Check-up', '2024-01-13 14:40:00'::TIMESTAMP);

-- Q1: List all patients' names and ages
SELECT patient_name AS "Patient Name", age AS "Patient Age"
FROM patients;

-- Q2: List all doctors specialized in 'Cardiology'
SELECT doctor_name AS "Cardiologist Name", specialization AS "Specialization"
FROM doctors
WHERE specialization = 'Cardiology';

-- Q3: Find all patients older than 80
SELECT patient_name AS "Patient Over 80", age AS "Patient Age"
FROM patients
WHERE age > 80;

-- Q4: List all patients sorted by age ascending
SELECT patient_name AS "Patient Name", age AS "Patient Age"
FROM patients
ORDER BY age ASC;

-- Q5: Count doctors by specialization
SELECT specialization AS "Specialization", COUNT(doctor_id) AS "Doctor Count"
FROM doctors
GROUP BY specialization;

-- Q6: List patients and their assigned doctors
SELECT 
    p.patient_name AS "Patient Name",
    d.doctor_name AS "Assigned Doctor"
FROM patients p
INNER JOIN doctor_patient dp ON p.patient_id = dp.patient_id
INNER JOIN doctors d ON dp.doctor_id = d.doctor_id;

-- Q7: Show treatment records with patient and doctor names
SELECT 
    t.treatment_type AS "Treatment Type",
    t.treatment_date AS "Treatment Date",
    p.patient_name AS "Patient Name",
    d.doctor_name AS "Doctor Name"
FROM treatments t
INNER JOIN patients p ON t.patient_id = p.patient_id
INNER JOIN doctors d ON t.doctor_id = d.doctor_id;

-- Q8: Count number of patients managed by each doctor
SELECT 
    d.doctor_name AS "Doctor Name",
    COUNT(dp.patient_id) AS "Patient Count"
FROM doctors d
LEFT JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
GROUP BY d.doctor_id, d.doctor_name;

-- Q9: Calculate average age of patients
SELECT AVG(age) AS average_age
FROM patients;

-- Q10: Find the most common treatment type
SELECT treatment_type AS "Most Common Treatment"
FROM treatments
GROUP BY treatment_type
ORDER BY COUNT(treatment_id) DESC
LIMIT 1;

-- Q11: List patients older than the average age
SELECT patient_name AS "Above Average Age Patient", age AS "Patient Age"
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: List doctors managing more than 5 patients
SELECT 
    d.doctor_name AS "Doctor Name",
    COUNT(dp.patient_id) AS "Patient Count"
FROM doctors d
INNER JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(dp.patient_id) > 5;

-- Q13: List all treatments provided by morning shift nurses with patient names
SELECT 
    t.treatment_type AS "Treatment Type",
    t.treatment_date AS "Treatment Date",
    p.patient_name AS "Patient Name",
    n.nurse_name AS "Nurse Name"
FROM treatments t
INNER JOIN patients p ON t.patient_id = p.patient_id
INNER JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'Morning';

-- Q14: Find the latest treatment record for each patient
SELECT 
    p.patient_name AS "Patient Name",
    t.treatment_type AS "Latest Treatment Type",
    t.treatment_date AS "Latest Treatment Date"
FROM patients p
INNER JOIN treatments t ON p.patient_id = t.patient_id
INNER JOIN (
    SELECT patient_id, MAX(treatment_date) AS latest_date
    FROM treatments
    GROUP BY patient_id
) AS latest_treat ON t.patient_id = latest_treat.patient_id 
                  AND t.treatment_date = latest_treat.latest_date;

-- Q15: List all doctors and the average age of their patients
SELECT 
    d.doctor_name AS "Doctor Name",
    ROUND(AVG(p.age)::NUMERIC, 1) AS "Average Patient Age"
FROM doctors d
LEFT JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
LEFT JOIN patients p ON dp.patient_id = p.patient_id
GROUP BY d.doctor_id, d.doctor_name;

-- Q16: List doctors managing more than 3 patients
SELECT doctor_name AS "Doctor with >3 Patients"
FROM doctors d
INNER JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(dp.patient_id) > 3;

-- Q17: List patients who have not received any treatment
SELECT patient_name AS "Untreated Patient"
FROM patients
WHERE patient_id NOT IN (
    SELECT DISTINCT patient_id FROM treatments
);

-- Q18: List medications with stock below average
SELECT medication_name AS "Low Stock Medication", quantity AS "Stock Quantity"
FROM medication_stock
WHERE quantity < (
    SELECT AVG(quantity)::INT FROM medication_stock
);

-- Q19: Rank patients by age within each doctor group (oldest first)
SELECT 
    d.doctor_name AS "Doctor Name",
    p.patient_name AS "Patient Name",
    p.age AS "Patient Age",
    ROW_NUMBER() OVER (PARTITION BY d.doctor_id ORDER BY p.age DESC) AS "Age Rank"
FROM doctors d
INNER JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
INNER JOIN patients p ON dp.patient_id = p.patient_id
ORDER BY d.doctor_name, "Age Rank";

-- Q20: For each specialization, find the doctor with the oldest patient
SELECT 
    final.specialization AS "Specialization",
    final.doctor_name AS "Doctor with Oldest Patient",
    final.oldest_patient_age AS "Oldest Patient Age",
    final.oldest_patient_name AS "Oldest Patient Name"
FROM (
    SELECT 
        d.specialization,
        d.doctor_name,
        MAX(p.age) AS oldest_patient_age,
        STRING_AGG(DISTINCT p.patient_name, ', ') AS oldest_patient_name,
        MAX(p.age) OVER (PARTITION BY d.specialization) AS max_age_in_specialization
    FROM doctors d
    LEFT JOIN doctor_patient dp ON d.doctor_id = dp.doctor_id
    LEFT JOIN patients p ON dp.patient_id = p.patient_id
    GROUP BY d.doctor_id, d.specialization, d.doctor_name
) AS final
WHERE final.oldest_patient_age = final.max_age_in_specialization;






