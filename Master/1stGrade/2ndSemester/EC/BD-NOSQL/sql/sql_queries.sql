-- MEDICAMENTOS MAIS PRESCRITOS
SELECT 
    MEDICINE.M_NAME,
    COUNT(MEDICINE.IDMEDICINE)
    AS PRESCRIPTION_COUNT
FROM
    MEDICINE 
JOIN 
    PRESCRIPTION 
ON
    PRESCRIPTION.IDMEDICINE = MEDICINE.IDMEDICINE
GROUP BY
    MEDICINE.M_NAME
ORDER BY
    PRESCRIPTION_COUNT DESC;
    
-- QUARTOS MAIS VEZES UTILIZADOS
SELECT
    HOSPITALIZATION.ROOM_IDROOM,
    ROOM.ROOM_COST,
    ROOM.ROOM_TYPE,
    COUNT(HOSPITALIZATION.ROOM_IDROOM) AS TIMES_USED
FROM 
    ROOM
JOIN
    HOSPITALIZATION
ON 
    HOSPITALIZATION.ROOM_IDROOM = ROOM.IDROOM
GROUP BY
    HOSPITALIZATION.ROOM_IDROOM, ROOM.ROOM_COST, ROOM.ROOM_TYPE
ORDER BY
    TIMES_USED DESC;

-- MÉDICOS COM MAIS CONSULTAS
SELECT
    STAFF.EMP_FNAME || ' ' || STAFF.EMP_LNAME AS FULL_NAME,
    DOCTOR.QUALIFICATIONS,
    DEPARTMENT.DEPT_NAME,
    COUNT(APPOINTMENT.IDDOCTOR) AS APPOINTMENTS
FROM 
    APPOINTMENT
JOIN
    DOCTOR
ON 
    APPOINTMENT.IDDOCTOR = DOCTOR.EMP_ID
JOIN
    STAFF
ON
    DOCTOR.EMP_ID = STAFF.EMP_ID
JOIN
    DEPARTMENT
ON
    DEPARTMENT.IDDEPARTMENT = STAFF.IDDEPARTMENT
GROUP BY
    STAFF.EMP_FNAME || ' ' || STAFF.EMP_LNAME,
    DOCTOR.QUALIFICATIONS,
    DEPARTMENT.DEPT_NAME
ORDER BY
    APPOINTMENTS DESC;

-- ENFERMEIRAS MAIS ATRIBUIDAS
SELECT
    STAFF.EMP_FNAME || ' ' || STAFF.EMP_LNAME AS NURSE_FULL_NAME,
    DEPARTMENT.DEPT_NAME,
    COUNT(HOSPITALIZATION.RESPONSIBLE_NURSE) AS TIMES_ATTRIBUTED
FROM 
    HOSPITALIZATION
JOIN
    NURSE
ON 
    HOSPITALIZATION.RESPONSIBLE_NURSE= NURSE.STAFF_EMP_ID
JOIN
    STAFF
ON
    NURSE.STAFF_EMP_ID = STAFF.EMP_ID
JOIN
    DEPARTMENT
ON
    DEPARTMENT.IDDEPARTMENT = STAFF.IDDEPARTMENT
GROUP BY
    STAFF.EMP_FNAME || ' ' || STAFF.EMP_LNAME,
    DEPARTMENT.DEPT_NAME
ORDER BY
    TIMES_ATTRIBUTED DESC;

-- 10 PACIENTES COM MAIS EPISÓDIOS
SELECT 
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME AS FULL_NAME,
    COUNT(EPISODE.IDEPISODE) AS EPISODES
FROM 
    PATIENT
JOIN
    EPISODE
ON 
    EPISODE.IDEPISODE=PATIENT.IDPATIENT
GROUP BY
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME
ORDER BY
    EPISODES DESC
FETCH FIRST 10 ROWS ONLY;

-- 20 PACIENTES COM MAIORES GASTOS
SELECT 
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME AS  FULL_NAME,
    COUNT(EPISODE.IDEPISODE) AS NUM_EPISODIOS,
    SUM(BILL.ROOM_COST) AS CUSTOS_HOSPITALIZACAO,
    SUM(BILL.TEST_COST) AS CUSTOS_ANALISES,
    SUM(BILL.OTHER_CHARGES) AS OUTROS_CUSTOS,
    SUM(BILL.TOTAL) AS CUSTOS_TOTAIS
FROM
    PATIENT
JOIN
    EPISODE
ON
    PATIENT.IDPATIENT = EPISODE.PATIENT_IDPATIENT
JOIN
    BILL
ON
    BILL.IDEPISODE = EPISODE.IDEPISODE
GROUP BY
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME
ORDER BY
    CUSTOS_TOTAIS DESC
FETCH FIRST 20 ROWS ONLY;

-- TODOS OS PACIENTES QUE FIZERAM ANÁLISES
SELECT 
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME AS  FULL_NAME,
    COUNT(LAB_SCREENING.LAB_ID) AS NUM_TESTES
FROM 
    PATIENT
JOIN
    EPISODE
ON
    EPISODE.PATIENT_IDPATIENT = PATIENT.IDPATIENT
JOIN 
    LAB_SCREENING
ON
    LAB_SCREENING.EPISODE_IDEPISODE = EPISODE.IDEPISODE
--WHERE 
--    LAB_SCREENING.TEST_DATE >= SYSDATE - INTERVAL '1' YEAR
GROUP BY
    PATIENT.PATIENT_FNAME || ' ' || PATIENT.PATIENT_LNAME
ORDER BY
    NUM_TESTES DESC;

-- DIAGONÓSTICOS MAIS COMUNS DE PESSOAS QUE JÁ FORAM HOSPITALIZADAS
SELECT
    MEDICAL_HISTORY.CONDITION AS DIAGONÓSTICO,
    COUNT(HOSPITALIZATION.IDEPISODE) AS NUM_HOSPITALIZACOES
FROM
    PATIENT
JOIN
    MEDICAL_HISTORY
ON
    MEDICAL_HISTORY.IDPATIENT = PATIENT.IDPATIENT
JOIN
    EPISODE
ON
    PATIENT.IDPATIENT = EPISODE.PATIENT_IDPATIENT
JOIN
    HOSPITALIZATION
ON
    HOSPITALIZATION.IDEPISODE = EPISODE.IDEPISODE
GROUP BY
    MEDICAL_HISTORY.CONDITION
ORDER BY 
    NUM_HOSPITALIZACOES DESC;

--SEGUROS MAIS UTILIZADOS
SELECT
    COUNT(PATIENT.IDPATIENT) AS CLIENTES,
    INSURANCE.PROVIDER AS SEGURO,
    INSURANCE.COVERAGE AS COBERTURA
FROM
    PATIENT
JOIN
    INSURANCE
ON
    INSURANCE.POLICY_NUMBER = PATIENT.POLICY_NUMBER
GROUP BY
    INSURANCE.PROVIDER,
    INSURANCE.COVERAGE
ORDER BY
    CLIENTES DESC;