/***************************
   Create Sequences
****************************/
CREATE SEQUENCE SEQ_PRESCRIPTION_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_BILL_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_DEPARTMENT_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_EPISODE_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_HIST_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_LAB_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_PATIENT_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_MED_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_ROOM_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_EMP_ID
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_POLICY_ID
START WITH 1
INCREMENT BY 1
NOCACHE;


/***************************
   Create Tables, PK and FK
****************************/


CREATE TABLE appointment (
    scheduled_on     DATE,
    appointment_date DATE,
    appointment_time VARCHAR2(5 BYTE),
    iddoctor  NUMBER(*, 0) NOT NULL,
    idepisode        NUMBER(*, 0) NOT NULL
);

ALTER TABLE appointment ADD CONSTRAINT appointment_pk PRIMARY KEY ( idepisode );

CREATE TABLE bill (
    idbill        NUMBER(*, 0) DEFAULT "SEQ_BILL_ID"."NEXTVAL" NOT NULL,
    room_cost     NUMBER(10, 2),
    test_cost     NUMBER(10, 2),
    other_charges NUMBER(10, 2),
    total         NUMBER(10, 2),
    idepisode     NUMBER(*, 0) NOT NULL,
    registered_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    payment_status VARCHAR2(10) CONSTRAINT check__bill_payment_status CHECK
                                     (payment_status IN ('PROCESSED', 'PENDING', 'FAILURE'))

);

ALTER TABLE bill ADD CONSTRAINT bill_pk PRIMARY KEY ( idbill );


CREATE TABLE department (
    iddepartment NUMBER(*, 0) DEFAULT "SEQ_DEPARTMENT_ID"."NEXTVAL" NOT NULL,
    dept_head    VARCHAR2(45 BYTE) NOT NULL,
    dept_name    VARCHAR2(45 BYTE) NOT NULL,
    emp_count    NUMBER(*, 0)
);

CREATE UNIQUE INDEX pk_department ON
    department (
        iddepartment
    ASC );

ALTER TABLE department ADD CONSTRAINT pk_department PRIMARY KEY ( iddepartment );

CREATE TABLE doctor (
    emp_id         NUMBER(*, 0) NOT NULL,
    qualifications VARCHAR2(45 BYTE) NOT NULL
);

ALTER TABLE doctor ADD CONSTRAINT doctor_pk PRIMARY KEY ( emp_id );

CREATE TABLE emergency_contact (
    contact_name VARCHAR2(45 BYTE) NOT NULL,
    phone        VARCHAR2(30 BYTE) NOT NULL 
                                    CONSTRAINT check_phone_number 
                                    CHECK (REGEXP_LIKE(phone, '^\d{3}.\d{3}.\d{4}$')),
    relation     VARCHAR2(45 BYTE) NOT NULL,
    idpatient    NUMBER(*, 0) NOT NULL
);

ALTER TABLE emergency_contact ADD CONSTRAINT emergency_contact_pk PRIMARY KEY ( idpatient,
                                                                                           phone );

CREATE TABLE episode (
    idepisode         NUMBER(*, 0) DEFAULT "SEQ_EPISODE_ID"."NEXTVAL" NOT NULL,
    patient_idpatient NUMBER(*, 0) NOT NULL
);

CREATE UNIQUE INDEX pk_episode ON
    episode (
        idepisode
    ASC );

ALTER TABLE episode ADD CONSTRAINT pk_episode PRIMARY KEY ( idepisode );

CREATE TABLE hospitalization (
    admission_date      DATE NOT NULL,
    discharge_date      DATE,
    room_idroom         NUMBER(*, 0) NOT NULL,
    idepisode           NUMBER(*, 0) NOT NULL,
    responsible_nurse   NUMBER(*, 0) NOT NULL
);

ALTER TABLE hospitalization ADD CONSTRAINT hospitalization_pk PRIMARY KEY ( idepisode );

CREATE TABLE insurance (
    policy_number  VARCHAR2(45 BYTE),
    provider       VARCHAR2(45 BYTE),
    insurance_plan VARCHAR2(45 BYTE),
    co_pay         NUMBER(10, 2),
    coverage       VARCHAR2(20 BYTE),
    maternity      CHAR(1 BYTE),
    dental         CHAR(1 BYTE),
    optical        CHAR(1 BYTE)
);

CREATE UNIQUE INDEX pk_insurance ON
    insurance (
        policy_number
    ASC );

ALTER TABLE insurance ADD CONSTRAINT pk_insurance PRIMARY KEY ( policy_number );

CREATE TABLE lab_screening (
    lab_id                  NUMBER(*, 0) DEFAULT "SEQ_LAB_ID"."NEXTVAL" NOT NULL,
    test_cost               NUMBER(10, 2),
    test_date               DATE,
    idtechnician            NUMBER(*, 0) NOT NULL,
    episode_idepisode       NUMBER(*, 0) NOT NULL
);

ALTER TABLE lab_screening ADD CONSTRAINT lab_screening_pk PRIMARY KEY ( lab_id );

CREATE TABLE MEDICAL_HISTORY (
    record_id   NUMBER(*, 0) DEFAULT "SEQ_HIST_ID"."NEXTVAL" NOT NULL,
    condition VARCHAR2(45 BYTE),
    record_date DATE,
    idpatient   NUMBER(*, 0) NOT NULL
);

ALTER TABLE MEDICAL_HISTORY ADD CONSTRAINT MEDICAL_HISTORY_pk PRIMARY KEY ( record_id );

CREATE TABLE medicine (
    idmedicine NUMBER(*, 0) DEFAULT "SEQ_MED_ID"."NEXTVAL" NOT NULL,
    m_name     VARCHAR2(45 BYTE) NOT NULL,
    m_quantity NUMBER(*, 0) NOT NULL,
    m_cost     NUMBER(10, 2)
);

ALTER TABLE medicine ADD CONSTRAINT medicine_pk PRIMARY KEY ( idmedicine );

CREATE TABLE nurse (
    staff_emp_id NUMBER(*, 0) NOT NULL
);

ALTER TABLE nurse ADD CONSTRAINT nurse_pk PRIMARY KEY ( staff_emp_id );

CREATE TABLE patient (
    idpatient     NUMBER(*, 0) DEFAULT "SEQ_PATIENT_ID"."NEXTVAL" NOT NULL,
    patient_fname VARCHAR2(45 BYTE) NOT NULL,
    patient_lname VARCHAR2(45 BYTE) NOT NULL,
    blood_type    VARCHAR2(3 BYTE) NOT NULL 
                                CONSTRAINT check_blood
                                CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    phone         VARCHAR2(12 BYTE) NOT NULL
                                    CONSTRAINT check_patient_phone_number 
                                    CHECK (REGEXP_LIKE(phone, '^\d{3}.\d{3}.\d{4}$')),
    email         VARCHAR2(50 BYTE),
    gender        VARCHAR2(10 BYTE),
    policy_number VARCHAR2(45 BYTE),
    BIRTHDAY DATE NOT NULL
);

CREATE UNIQUE INDEX pk_patient ON
    patient (
        idpatient
    ASC );

ALTER TABLE patient ADD CONSTRAINT pk_patient PRIMARY KEY ( idpatient );

CREATE TABLE prescription (
    idprescription    NUMBER(*, 0) DEFAULT "SEQ_PRESCRIPTION_ID"."NEXTVAL" NOT NULL,
    prescription_date DATE,
    dosage            NUMBER(*, 0),
    idmedicine        NUMBER(*, 0) NOT NULL,
    idepisode         NUMBER(*, 0) NOT NULL
);

ALTER TABLE prescription ADD CONSTRAINT prescription_pk PRIMARY KEY ( idprescription );

CREATE TABLE room (
    idroom    NUMBER(*, 0) DEFAULT "SEQ_ROOM_ID"."NEXTVAL" NOT NULL,
    room_type VARCHAR2(45 BYTE),
    room_cost NUMBER(10, 2)
);

CREATE UNIQUE INDEX pk_room ON
    room (
        idroom
    ASC );

ALTER TABLE room ADD CONSTRAINT pk_room PRIMARY KEY ( idroom );

CREATE TABLE staff (
    emp_id          NUMBER(*, 0) DEFAULT "SEQ_EMP_ID"."NEXTVAL" NOT NULL,
    emp_fname       VARCHAR2(45 BYTE) NOT NULL,
    emp_lname       VARCHAR2(45 BYTE) NOT NULL,
    date_joining    DATE,
    date_seperation DATE,
    email           VARCHAR2(50 BYTE),
    address         VARCHAR2(50 BYTE) NOT NULL,
    ssn             NUMBER(*, 0) NOT NULL,
    iddepartment    NUMBER(*, 0) NOT NULL,
    is_active_status   VARCHAR2(1) NOT NULL 
                                CONSTRAINT check_staff_status 
                                CHECK (is_active_status IN ('Y', 'N'))
);

CREATE UNIQUE INDEX pk_staff ON
    staff (
        emp_id
    ASC );

ALTER TABLE staff ADD CONSTRAINT pk_staff PRIMARY KEY ( emp_id );

CREATE TABLE technician (
    staff_emp_id NUMBER(*, 0) NOT NULL
);

ALTER TABLE technician ADD CONSTRAINT technician_pk PRIMARY KEY ( staff_emp_id );

ALTER TABLE appointment
    ADD CONSTRAINT appointment_doctor_fk FOREIGN KEY ( iddoctor )
        REFERENCES doctor ( emp_id );

ALTER TABLE appointment
    ADD CONSTRAINT fk_appointment_episode1 FOREIGN KEY ( idepisode )
        REFERENCES episode ( idepisode );

ALTER TABLE bill
    ADD CONSTRAINT fk_bill_episode1 FOREIGN KEY ( idepisode )
        REFERENCES episode ( idepisode );

ALTER TABLE doctor
    ADD CONSTRAINT fk_doctor_staff1 FOREIGN KEY ( emp_id )
        REFERENCES staff ( emp_id );

ALTER TABLE emergency_contact
    ADD CONSTRAINT fk_emergency_contact_patient1 FOREIGN KEY ( idpatient )
        REFERENCES patient ( idpatient );

ALTER TABLE episode
    ADD CONSTRAINT fk_episode_patient1 FOREIGN KEY ( patient_idpatient )
        REFERENCES patient ( idpatient );

ALTER TABLE hospitalization
    ADD CONSTRAINT fk_hospitalization_episode1 FOREIGN KEY ( idepisode )
        REFERENCES episode ( idepisode );

ALTER TABLE hospitalization
    ADD CONSTRAINT fk_hospitalization_nurse1 FOREIGN KEY ( responsible_nurse )
        REFERENCES nurse ( staff_emp_id );

ALTER TABLE hospitalization
    ADD CONSTRAINT fk_hospitalization_room1 FOREIGN KEY ( room_idroom )
        REFERENCES room ( idroom );

ALTER TABLE lab_screening
    ADD CONSTRAINT fk_lab_screening_episode1 FOREIGN KEY ( episode_idepisode )
        REFERENCES episode ( idepisode );

ALTER TABLE lab_screening
    ADD CONSTRAINT fk_lab_screening_technician1 FOREIGN KEY ( idtechnician )
        REFERENCES technician ( staff_emp_id );

ALTER TABLE MEDICAL_HISTORY
    ADD CONSTRAINT fk_MEDICAL_HISTORY_patient1 FOREIGN KEY ( idpatient )
        REFERENCES patient ( idpatient );

ALTER TABLE nurse
    ADD CONSTRAINT fk_nurse_staff1 FOREIGN KEY ( staff_emp_id )
        REFERENCES staff ( emp_id );

ALTER TABLE patient
    ADD CONSTRAINT fk_patient_insurance FOREIGN KEY ( policy_number )
        REFERENCES insurance ( policy_number );

ALTER TABLE prescription
    ADD CONSTRAINT fk_prescription_episode1 FOREIGN KEY ( idepisode )
        REFERENCES episode ( idepisode );

ALTER TABLE prescription
    ADD CONSTRAINT fk_prescription_medicine1 FOREIGN KEY ( idmedicine )
        REFERENCES medicine ( idmedicine );

ALTER TABLE staff
    ADD CONSTRAINT fk_staff_department1 FOREIGN KEY ( iddepartment )
        REFERENCES department ( iddepartment );

ALTER TABLE technician
    ADD CONSTRAINT fk_technician_staff1 FOREIGN KEY ( staff_emp_id )
        REFERENCES staff ( emp_id );

/***************************
   Create View
****************************/

CREATE VIEW PatientAppointmentView AS
SELECT 
    a.scheduled_on AS appointment_scheduled_date,
    a.appointment_date AS appointment_date,
    a.appointment_time AS appointment_time,
    d.emp_id AS doctor_id,
    d.qualifications AS doctor_qualifications,
    dept.dept_name AS department_name,
    p.patient_fname AS patient_first_name,
    p.patient_lname AS patient_last_name,
    p.blood_type AS patient_blood_type,
    p.phone AS patient_phone,
    p.email AS patient_email,
    p.gender AS patient_gender
FROM 
    appointment a
JOIN 
    doctor d ON a.iddoctor = d.emp_id
JOIN
    staff s ON d.emp_id = s.emp_id
JOIN 
    department dept ON s.iddepartment = dept.iddepartment
JOIN 
    episode e ON a.idepisode = e.idepisode
JOIN 
    patient p ON e.patient_idpatient = p.idpatient;
    

/***************************
   Create Procedure
****************************/
    
CREATE OR REPLACE PROCEDURE sp_update_bill_status (
    p_bill_id bill.idbill%TYPE,
    p_paid_value bill.total%TYPE
) 
IS
    v_total bill.total%TYPE;
BEGIN
    -- Retrieve the total value of the bill
    SELECT
        total
    INTO
        v_total
    FROM
        bill
    WHERE
        idbill = p_bill_id;

    -- Check if the paid value is less than the total value of the bill
    IF p_paid_value < v_total THEN
        -- If paid value is less than total, update status to FAILURE
        UPDATE bill
        SET
            payment_status = 'FAILURE'
        WHERE
            idbill = p_bill_id;
            
        -- Raise an error
        raise_application_error(-20001, 'Paid value is inferior to the total value of the bill.');
    ELSE 
        -- If paid value is equal to total, update status to PROCESSED
        UPDATE bill
        SET
            payment_status = 'PROCESSED'
        WHERE
            idbill = p_bill_id;
        
    END IF;
END;
/


/***************************
   Create Trigger
****************************/
CREATE OR REPLACE TRIGGER trg_generate_bill
AFTER UPDATE OF discharge_date ON hospitalization
FOR EACH ROW
DECLARE
    v_room_cost    NUMBER;
    v_test_cost    NUMBER;
    v_other_charges  NUMBER;
    v_total_cost   NUMBER;
BEGIN
    -- Check if the discharge date has been updated
    IF :OLD.discharge_date IS NULL AND :NEW.discharge_date IS NOT NULL THEN
        -- Calculate the room cost for the associated hospitalization
        SELECT NVL(SUM(room_cost), 0)
        INTO v_room_cost
        FROM room
        WHERE idroom = :NEW.room_idroom;

        -- Calculate the test cost for the associated hospitalization
        SELECT NVL(SUM(test_cost), 0)
        INTO v_test_cost
        FROM lab_screening
        WHERE episode_idepisode = :NEW.idepisode;

        -- Calculate the other charges for prescriptions for the associated hospitalization
        SELECT NVL(SUM(m_cost * dosage), 0)
        INTO v_other_charges
        FROM prescription p
        JOIN medicine m ON p.idmedicine = m.idmedicine
        WHERE p.idepisode = :NEW.idepisode;

        -- Calculate the total cost of the bill for the associated episode
        v_total_cost := v_room_cost + v_test_cost + v_other_charges;

        -- Insert the bill with the total cost for the associated episode
        INSERT INTO bill (idepisode, room_cost, test_cost, other_charges, total, payment_status, registered_at)
        VALUES (:NEW.idepisode, v_room_cost, v_test_cost, v_other_charges, v_total_cost, 'PENDING', SYSDATE);
        
    END IF;
END;
/


SET DEFINE OFF;
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('John Smith','Cardiology_1','2');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Michael Williams','Emergency_2','3');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Emily Johnson','Diagnostic_3','3');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Jessica Brown','Cardiology_4','2');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Christopher Lee','Emergency_1','2');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Matthew Martinez','Diagnostic_1','1');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Sophia Hernandez','Cardiology_3','3');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Ethan Lopez','Cardiology_2','3');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Travis Smith','Diagnostic_2','3');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Amanda Taylor','Pediatrics','2');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Daniel Garcia','Orthopedics','2');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Olivia Rodriguez','Neurology','1');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Noah Martinez','Oncology','1');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Isabella Hernandez','Radiology','5');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('William Johnson','Surgery','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Sophia Lopez','Ophthalmology','5');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Ethan Brown','Gynecology','5');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Olivia Wilson','Urology','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Alexander Lee','Dermatology','6');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Mia Garcia','Hematology','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('James Martinez','Endocrinology','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Sophia Anderson','Pulmonology','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Oliver Wilson','Nephrology','4');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Ava Hernandez','Otolaryngology','5');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Lucas Lopez','Rheumatology','5');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Emma Brown','Dentistry','10');
Insert into DEPARTMENT (DEPT_HEAD,DEPT_NAME,EMP_COUNT) values ('Daniel Lee','Psychiatry','4');


Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL001','ABC Insurance','Standard Plan','50','Full Coverage','Y','N','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL002','XYZ Insurance','Premium Plan','30','Partial Coverage','N','Y','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL003','DEF Insurance','Basic Plan','20','Limited Coverage','Y','N','N');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL004','GHI Insurance','Gold Plan','40','Full Coverage','N','Y','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL005','JKL Insurance','Silver Plan','35','Partial Coverage','Y','N','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL006','MNO Insurance','Bronze Plan','25','Limited Coverage','N','Y','N');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL007','PQR Insurance','Platinum Plan','60','Full Coverage','Y','Y','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL008','STU Insurance','Family Plan','45','Partial Coverage','Y','Y','N');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL009','VWX Insurance','Corporate Plan','55','Full Coverage','N','N','Y');
Insert into INSURANCE (POLICY_NUMBER,PROVIDER,INSURANCE_PLAN,CO_PAY,COVERAGE,MATERNITY,DENTAL,OPTICAL) values ('POL010','YZA Insurance','Student Plan','15','Limited Coverage','N','N','N');


Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('John','Doe','A+','123-456-7890','john.doe@example.com','Male','POL001',TO_DATE('1985-07-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Jane','Smith','O-','987-654-3210','jane.smith@example.com','Female','POL002',TO_DATE('1990-03-20', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Michael','Johnson','B+','567-890-1234','michael.johnson@example.com','Male','POL003',TO_DATE('1982-11-10', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Emily','Brown','AB-','789-012-3456','emily.brown@example.com','Female','POL004',TO_DATE('1978-04-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('William','Martinez','A-','234-567-8901','william.martinez@example.com','Male','POL005',TO_DATE('1995-09-03', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Garcia','O+','890-123-4567','sophia.garcia@example.com','Female','POL006',TO_DATE('1989-12-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('James','Lopez','B-','456-789-0123','james.lopez@example.com','Male','POL007',TO_DATE('1976-06-30', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Olivia','Lee','AB+','901-234-5678','olivia.lee@example.com','Female','POL008',TO_DATE('1987-02-12', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Benjamin','Gonzalez','O-','678-901-2345','benjamin.gonzalez@example.com','Male','POL009',TO_DATE('1980-08-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Emma','Perez','A+','345-678-9012','emma.perez@example.com','Female','POL010',TO_DATE('1992-01-05', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Jacob','Rodriguez','B+','123-123-1234','jacob.rodriguez@example.com','Male','POL001',TO_DATE('1983-10-22', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Isabella','Hernandez','AB-','456-456-4567','isabella.hernandez@example.com','Female','POL002',TO_DATE('1986-05-17', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ethan','Lopez','A-','789-789-7890','ethan.lopez@example.com','Male','POL003',TO_DATE('1984-08-29', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Mia','Gomez','O+','111-222-3333','mia.gomez@example.com','Female','POL004',TO_DATE('1998-03-14', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Alexander','Diaz','B-','444-555-6666','alexander.diaz@example.com','Male','POL005',TO_DATE('1992-05-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ava','Rivera','AB+','777-888-9999','ava.rivera@example.com','Female','POL006',TO_DATE('1987-09-21', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('William','Smith','O-','333-444-5555','william.smith@example.com','Male','POL007',TO_DATE('1980-03-12', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Gonzalez','A+','666-777-8888','sophia.gonzalez@example.com','Female','POL008',TO_DATE('1988-11-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Michael','Martinez','B+','999-000-1111','michael.martinez@example.com','Male','POL009',TO_DATE('1975-08-03', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Olivia','Perez','AB-','222-333-4444','olivia.perez@example.com','Female','POL002',TO_DATE('1996-02-14', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Liam','Torres','A-','123-456-7890','liam.torres@example.com','Male','POL001',TO_DATE('1991-07-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Emma','Flores','O+','234-567-8901','emma.flores@example.com','Female','POL002',TO_DATE('1983-11-30', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Noah','Ramirez','B+','345-678-9012','noah.ramirez@example.com','Male','POL003',TO_DATE('1979-09-05', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Olivia','Gutierrez','AB-','456-789-0123','olivia.gutierrez@example.com','Female','POL004',TO_DATE('1986-04-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('William','Nguyen','A+','567-890-1234','william.nguyen@example.com','Male','POL005',TO_DATE('1990-12-02', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ava','Tran','B-','678-901-2345','ava.tran@example.com','Female','POL006',TO_DATE('1984-05-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('James','Kim','AB+','789-012-3456','james.kim@example.com','Male','POL007',TO_DATE('1981-10-20', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Le','O-','890-123-4567','sophia.le@example.com','Female','POL008',TO_DATE('1977-06-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Logan','Do','A-','901-234-5678','logan.do@example.com','Male','POL009',TO_DATE('1993-08-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Amelia','Huynh','B+','012-345-6789','amelia.huynh@example.com','Female','POL002',TO_DATE('1989-01-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ethan','Vo','O-','123-456-7890','ethan.vo@example.com','Male','POL001',TO_DATE('1978-04-22', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Isabella','Phan','A+','234-567-8901','isabella.phan@example.com','Female','POL002',TO_DATE('1995-09-13', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Mason','Duong','B-','345-678-9012','mason.duong@example.com','Male','POL003',TO_DATE('1982-11-28', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Oliver','Truong','AB+','456-789-0123','oliver.truong@example.com','Male','POL004',TO_DATE('1974-10-07', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Charlotte','Ngo','O+','567-890-1234','charlotte.ngo@example.com','Female','POL005',TO_DATE('1983-05-21', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Lucas','Vuong','B+','678-901-2345','lucas.vuong@example.com','Male','POL006',TO_DATE('1980-12-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Amelia','Pham','A-','789-012-3456','amelia.pham@example.com','Female','POL007',TO_DATE('1977-09-28', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Benjamin','Le','AB-','890-123-4567','benjamin.le@example.com','Male','POL008',TO_DATE('1975-04-14', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Evelyn','Bui','B-','901-234-5678','evelyn.bui@example.com','Female','POL009',TO_DATE('1990-11-30', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Alexander','Ho','A+','012-345-6789','alexander.ho@example.com','Male','POL002',TO_DATE('1988-08-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Nguyen','O+','123-456-7890','sophia.nguyen@example.com','Female','POL001',TO_DATE('1982-03-17', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Jackson','Tran','A-','234-567-8901','jackson.tran@example.com','Male','POL002',TO_DATE('1989-10-10', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Madison','Dinh','AB+','345-678-9012','madison.dinh@example.com','Female','POL003',TO_DATE('1985-07-05', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Aiden','Vo','B+','456-789-0123','aiden.vo@example.com','Male','POL004',TO_DATE('1979-02-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Scarlett','Huynh','O-','567-890-1234','scarlett.huynh@example.com','Female','POL005',TO_DATE('1986-11-27', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Daniel','Do','A+','678-901-2345','daniel.do@example.com','Male','POL006',TO_DATE('1983-08-07', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Victoria','Lam','B-','789-012-3456','victoria.lam@example.com','Female','POL007', TO_DATE('1983-09-20', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Joseph','Mai','AB-','890-123-4567','joseph.mai@example.com','Male','POL008', TO_DATE('1977-08-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Natalie','Trinh','O+','901-234-5678','natalie.trinh@example.com','Female','POL009', TO_DATE('1990-05-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Samuel','Vo','A-','012-345-6789','samuel.vo@example.com','Male','POL002', TO_DATE('1985-11-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Olivia','Nguyen','AB+','123-450-9876','olivia.nguyen@example.com','Female','POL001', TO_DATE('1987-04-12', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ethan','Tran','B+','234-509-8765','ethan.tran@example.com','Male','POL002', TO_DATE('1992-02-03', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Emma','Dinh','O-','345-098-7654','emma.dinh@example.com','Female','POL003', TO_DATE('1988-07-17', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Noah','Vo','A+','450-987-6543','noah.vo@example.com','Male','POL004', TO_DATE('1983-12-05', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Isabella','Huynh','AB-','509-876-5432','isabella.huynh@example.com','Female','POL005', TO_DATE('1984-10-30', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('William','Do','B-','098-765-4321','william.do@example.com','Male','POL006', TO_DATE('1990-01-14', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Lam','O+','987-654-3210','sophia.lam@example.com','Female','POL007', TO_DATE('1986-06-28', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('James','Mai','A-','876-543-2109','james.mai@example.com','Male','POL008', TO_DATE('1982-09-03', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Charlotte','Trinh','AB+','765-432-1098','charlotte.trinh@example.com','Female','POL009', TO_DATE('1995-03-22', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Logan','Vo','B+','654-321-0987','logan.vo@example.com','Male','POL002', TO_DATE('1993-08-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ava','Nguyen','O+','543-210-9876','ava.nguyen@example.com','Female','POL001', TO_DATE('1989-05-27', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Mason','Pham','A-','432-109-8765','mason.pham@example.com','Male','POL002', TO_DATE('1981-11-11', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Harper','Ho','B+','321-098-7654','harper.ho@example.com','Female','POL003', TO_DATE('1987-07-07', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Elijah','Truong','AB-','210-987-6543','elijah.truong@example.com','Male','POL004', TO_DATE('1980-01-30', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Amelia','Le','O-','109-876-5432','amelia.le@example.com','Female','POL005', TO_DATE('1988-04-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Benjamin','Ngo','B-','098-765-4321','benjamin.ngo@example.com','Male','POL006', TO_DATE('1994-10-12', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Evelyn','Ly','AB+','987-654-3210','evelyn.ly@example.com','Female','POL007', TO_DATE('1993-07-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Alexander','Dang','A+','876-543-2109','alexander.dang@example.com','Male','POL008', TO_DATE('1988-12-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Abigail','Vuong','O+','765-432-1098','abigail.vuong@example.com','Female','POL009', TO_DATE('1986-09-10', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Michael','Duong','B+','654-321-0987','michael.duong@example.com','Male','POL002', TO_DATE('1991-04-28', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Olivia','Tran','O-','987-654-3210','olivia.tran@example.com','Female','POL001', TO_DATE('1985-08-14', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('James','Vo','A-','876-543-2109','james.vo@example.com','Male','POL002', TO_DATE('1983-01-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Emma','Luu','B+','765-432-1098','emma.luu@example.com','Female','POL003', TO_DATE('1982-06-07', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Lucas','Ha','AB+','654-321-0987','lucas.ha@example.com','Male','POL004', TO_DATE('1992-11-20', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Avery','Hoang','O+','543-210-9876','avery.hoang@example.com','Female','POL005', TO_DATE('1989-03-02', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('William','Bui','A+','432-109-8765','william.bui@example.com','Male','POL006', TO_DATE('1994-07-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sophia','Phan','B-','321-098-7654','sophia.phan@example.com','Female','POL007', TO_DATE('1987-10-29', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Logan','Trinh','AB-','210-987-6543','logan.trinh@example.com','Male','POL008', TO_DATE('1980-05-06', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Mia','Nguyen','O-','109-876-5432','mia.nguyen@example.com','Female','POL009', TO_DATE('1983-12-25', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Benjamin','Vu','A-','098-765-4321','benjamin.vu@example.com','Male','POL002', TO_DATE('1992-09-08', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ella','Le','O+','987-654-3210','ella.le@example.com','Female','POL001', TO_DATE('1991-06-17', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Alexander','Ho','B+','876-543-2109','alexander.ho@example.com','Male','POL002', TO_DATE('1986-02-04', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Sofia','Pham','A-','765-432-1098','sofia.pham@example.com','Female','POL003', TO_DATE('1988-09-23', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Henry','Tran','AB-','654-321-0987','henry.tran@example.com','Male','POL004', TO_DATE('1985-04-18', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Scarlett','Dang','O-','543-210-9876','scarlett.dang@example.com','Female','POL005', TO_DATE('1982-10-31', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Ethan','Duong','B+','432-109-8765','ethan.duong@example.com','Male','POL006', TO_DATE('1990-08-15', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Madison','Nguyen','A+','321-098-7654','madison.nguyen@example.com','Female','POL007', TO_DATE('1984-12-20', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Jacob','Lam','AB+','210-987-6543','jacob.lam@example.com','Male','POL008', TO_DATE('1983-11-17', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Amelia','Tran','O+','109-876-5432','amelia.tran@example.com','Female','POL009', TO_DATE('1988-08-29', 'YYYY-MM-DD'));
Insert into PATIENT (PATIENT_FNAME,PATIENT_LNAME,BLOOD_TYPE,PHONE,EMAIL,GENDER,POLICY_NUMBER,BIRTHDAY) values ('Michael','Do','A-','098-765-4321','michael.do@example.com','Male','POL002', TO_DATE('1995-01-12', 'YYYY-MM-DD'));

Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('1','Paracetamol','50','10');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('2','Ibuprofen','30','15');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('3','Amoxicillin','20','20');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('4','Ciprofloxacin','25','25');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('5','Lisinopril','40','30');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('6','Atorvastatin','35','20');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('7','Metformin','45','25');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('8','Levothyroxine','40','35');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('9','Simvastatin','30','20');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('10','Amlodipine','35','30');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('11','Hydrochlorothiazide','25','15');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('12','Losartan','30','25');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('13','Azithromycin','20','20');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('14','Omeprazole','40','10');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('15','Prednisone','35','15');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('16','Metoprolol','30','30');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('17','Warfarin','25','25');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('18','Fluoxetine','20','20');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('19','Alprazolam','25','30');
Insert into MEDICINE (IDMEDICINE,M_NAME,M_QUANTITY,M_COST) values ('20','Hydrocodone','30','25');

Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','100');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','150');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','250');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','300');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','70');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','500');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','400');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','120');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','280');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','90');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','220');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','320');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','550');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','420');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','100');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','150');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','250');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','300');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','70');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','500');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','400');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','120');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','280');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','90');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','220');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','320');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','550');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','420');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','100');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','150');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','250');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','300');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','70');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','500');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','400');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Single','120');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Double','180');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Suite','280');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Standard','90');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Deluxe','220');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('VIP','320');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Economy','80');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Family','200');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Penthouse','550');
Insert into ROOM (ROOM_TYPE,ROOM_COST) values ('Executive','420');

Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('John Doe','111-222-3333','Father','1');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Jane Smith','222-333-4444','Mother','2');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Alice Johnson','333-444-5555','Sister','3');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Bob Brown','444-555-6666','Brother','4');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Sarah Wilson','555-666-7777','Spouse','5');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Michael Clark','666-777-8888','Friend','6');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Emily White','777-888-9999','Relative','7');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('David Lee','888-999-0000','Parent','8');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Jennifer Martinez','999-000-1111','Sibling','9');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Daniel Harris','000-111-2222','Friend','10');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Emma Thompson','111-222-3323','Sibling','1');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Matthew Evans','222-333-4444','Spouse','7');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Olivia Rodriguez','333-444-5555','Parent','4');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('James Wilson','444-555-6666','Sibling','6');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Ava Anderson','555-666-7777','Friend','7');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Logan Taylor','666-777-8888','Spouse','77');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Sophia Scott','777-888-9999','Relative','66');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Ethan Lewis','888-999-0000','Sibling','55');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Mia Martinez','999-000-1111','Parent','44');
Insert into EMERGENCY_CONTACT (CONTACT_NAME,PHONE,RELATION,IDPATIENT) values ('Noah Harris','000-111-2222','Friend','22');

INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Flu', to_date('2023-01-15','YYYY-MM-DD'), 1);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Allergy', to_date('2023-03-05', 'YYYY-MM-DD'), 2);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Broken Arm', to_date('2023-04-20', 'YYYY-MM-DD'), 3);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Pneumonia', to_date('2023-07-10', 'YYYY-MM-DD'), 4);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Headache', to_date('2023-09-08', 'YYYY-MM-DD'), 5);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Asthma', to_date('2023-10-15', 'YYYY-MM-DD'), 6);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Diabetes', to_date('2023-12-25', 'YYYY-MM-DD'), 7);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Hypertension', to_date('2024-02-14', 'YYYY-MM-DD'), 8);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Arthritis', to_date('2024-04-01', 'YYYY-MM-DD'), 9);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Migraine', to_date('2024-06-18', 'YYYY-MM-DD'), 10);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Common Cold', to_date('2023-02-10', 'YYYY-MM-DD'), 11);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Anxiety', to_date('2023-05-05', 'YYYY-MM-DD'), 12);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Stomach Ulcer', to_date('2023-08-22', 'YYYY-MM-DD'), 13);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Bronchitis', to_date('2023-10-30', 'YYYY-MM-DD'), 14);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Rheumatoid Arthritis', to_date('2023-12-10', 'YYYY-MM-DD'), 15);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Insomnia', to_date('2024-01-18', 'YYYY-MM-DD'), 6);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('High Cholesterol', to_date('2024-03-03', 'YYYY-MM-DD'), 5);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Concussion', to_date('2024-05-20', 'YYYY-MM-DD'), 3);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Gastritis', to_date('2024-07-15', 'YYYY-MM-DD'), 1);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Osteoporosis', to_date('2024-09-05', 'YYYY-MM-DD'), 3);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Gastritis', to_date('2024-07-15', 'YYYY-MM-DD'), 1);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Common Cold', to_date('2023-02-10', 'YYYY-MM-DD'), 6);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Anxiety', to_date('2023-05-05', 'YYYY-MM-DD'), 6);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Stomach Ulcer', to_date('2023-08-22', 'YYYY-MM-DD'), 5);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Bronchitis', to_date('2023-10-30', 'YYYY-MM-DD'), 4);
INSERT INTO MEDICAL_HISTORY (condition, record_date, idpatient) VALUES ('Rheumatoid Arthritis', to_date('2023-12-10', 'YYYY-MM-DD'), 1);

Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jillian','Gordon',to_date('18.08.25','RR.MM.DD'),null,'juan14@example.net','"435 Dylan Neck Suite 993','329594711','25','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('James','Williams',to_date('18.04.10','RR.MM.DD'),to_date('23.01.05','RR.MM.DD'),'henryjennifer@example.net','Kleinhaven, CT 37220"','527613638','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Joshua','Carter',to_date('18.03.15','RR.MM.DD'),null,'michael82@example.org','"Unit 4429 Box 5356','724148400','27','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Joe','Ferguson',to_date('18.08.10','RR.MM.DD'),null,'vsullivan@example.org','DPO AE 27029"','531094042','17','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Travis','Ramos',to_date('19.10.15','RR.MM.DD'),null,'leah21@example.org','"12795 Solis Landing Apt. 269','857991076','21','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Lisa','Hayes',to_date('23.05.10','RR.MM.DD'),null,'mprice@example.com','Trevorfurt, IN 02637"','685569160','1','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Dawn','Hopkins',to_date('19.11.28','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'jenkinsheather@example.com','"02444 Anderson Street Suite 139','215259434','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Dawn','Roberts',to_date('19.12.01','RR.MM.DD'),null,'laurie35@example.net','Leeville, SD 39088"','391666874','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jessica','Jones',to_date('19.01.05','RR.MM.DD'),null,'larrykrause@example.net','"548 Bonilla Extensions','410402409','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Rachel','Wilson',to_date('19.07.10','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'jenna85@example.org','West Robertshire, MH 77607"','745100367','20','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Kimberly','Blankenship',to_date('19.01.05','RR.MM.DD'),null,'melissa35@example.org','"641 Tyler Fork Suite 201','281673265','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Keith','Simmons',to_date('18.12.01','RR.MM.DD'),null,'tylerthompson@example.org','Browntown, WY 84829"','899470207','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('William','Grant',to_date('19.07.10','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'seanlyons@example.org','"41829 Andrew Course Apt. 567','804408507','20','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Andrew','Deleon',to_date('18.09.15','RR.MM.DD'),null,'dominiquemcdaniel@example.com','North Kayla, ME 24616"','184426607','27','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Emily','Rowe',to_date('18.04.10','RR.MM.DD'),to_date('23.01.05','RR.MM.DD'),'thompsonsuzanne@example.org','"2191 Little Fall Apt. 951','457794054','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Kenneth','Ayers',to_date('18.08.25','RR.MM.DD'),null,'emily66@example.net','New Sarahberg, IA 31150"','719506165','25','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Daniel','Mills',to_date('18.08.10','RR.MM.DD'),null,'lthompson@example.org','"389 Jeffrey Mountain','481584738','17','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Tina','Gilbert',to_date('19.10.15','RR.MM.DD'),null,'danjones@example.net','Lindaview, MA 29212"','522524152','21','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Scott','Holmes',to_date('23.05.10','RR.MM.DD'),null,'tammy41@example.net','"107 Velasquez Corner','105899430','1','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jennifer','Ball',to_date('19.11.28','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'brandymartinez@example.com','Lake Tina, IA 30662"','404767927','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Stacy','Logan',to_date('19.12.01','RR.MM.DD'),null,'uturner@example.net','"771 Jennifer Bypass','633814140','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jeffrey','Jones',to_date('19.01.05','RR.MM.DD'),null,'uscott@example.com','Candicefurt, AS 18171"','258505600','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Cheryl','Christensen',to_date('18.12.01','RR.MM.DD'),null,'morganstephen@example.com','"219 Tammy Meadows','260911313','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('James','Carpenter',to_date('19.07.10','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'christineguzman@example.com','West Brianshire, NE 37671"','124291244','20','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Matthew','Espinoza',to_date('18.09.15','RR.MM.DD'),null,'roger32@example.net','"1163 Ethan Underpass Apt. 901','402431746','27','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Vickie','Gonzalez',to_date('18.04.10','RR.MM.DD'),to_date('23.01.05','RR.MM.DD'),'lolson@example.com','East Michael, CT 20442"','925078857','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Denise','Acosta',to_date('18.08.25','RR.MM.DD'),null,'emilylee@example.org','"844 Patel Keys','375062322','25','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Emily','Frederick',to_date('18.08.10','RR.MM.DD'),null,'caseyjoseph@example.com','Lake Lauren, ME 06845"','634799699','17','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Anthony','Larson',to_date('19.10.15','RR.MM.DD'),null,'richardsoncheryl@example.org','"98044 Wood Trafficway Suite 896','469016851','21','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Noah','Terry',to_date('23.05.10','RR.MM.DD'),null,'amandabooth@example.net','Billyhaven, KS 16701"','487128573','1','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Richard','Tran',to_date('19.11.28','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'onelson@example.net','"924 Johnson Glens','501902807','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Nicole','Elliott',to_date('19.12.01','RR.MM.DD'),null,'miguelrogers@example.org','Steveshire, KS 14385"','155620842','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('David','Barber',to_date('19.01.05','RR.MM.DD'),null,'christinawalker@example.net','"0145 Bowers Fort Suite 027','340817770','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Dillon','Jones',to_date('18.12.01','RR.MM.DD'),null,'joshuajohnson@example.net','South Deannaland, LA 85459"','833281856','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Diamond','Gonzalez',to_date('19.07.10','RR.MM.DD'),to_date('22.01.05','RR.MM.DD'),'sjoseph@example.com','"763 Rangel Roads Suite 571','525996493','20','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Deanna','Baker',to_date('18.09.15','RR.MM.DD'),null,'mcbridebriana@example.com','East Ryan, NY 85809"','616581558','27','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Teresa','Harris',to_date('18.04.10','RR.MM.DD'),to_date('23.01.05','RR.MM.DD'),'bsalas@example.net','"971 Chavez Garden Suite 571','930993929','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Patrick','Sparks',to_date('18.08.25','RR.MM.DD'),null,'nelsonmark@example.org','Port Emily, NE 23873"','909543569','25','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Lance','Scott',to_date('18.08.10','RR.MM.DD'),null,'peterdavis@example.com','"68405 Amanda Island','925578003','17','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Chelsea','Dodson',to_date('19.10.15','RR.MM.DD'),null,'daviscody@example.net','Lake Vickie, VI 12026"','642107275','21','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Juan','Harris',to_date('14.10.02','RR.MM.DD'),null,'fryrenee@example.net','"497 Alexander Camp','393607883','1','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Donna','Adams',to_date('14.10.02','RR.MM.DD'),null,'christopher30@example.net','Daltonhaven, MN 11752"','246634358','2','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Emily','Ryan',to_date('14.10.02','RR.MM.DD'),null,'mccormickbriana@example.net','"81336 Jacobson Cove Apt. 662','838811834','3','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jacob','Henry',to_date('14.10.02','RR.MM.DD'),null,'vanessabailey@example.com','Kimberlymouth, OK 53606"','471655403','4','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Joseph','Jones',to_date('14.10.02','RR.MM.DD'),null,'cshepard@example.org','"99962 Woods Path Apt. 757','566403689','5','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Allison','Miller',to_date('14.10.02','RR.MM.DD'),null,'zrichardson@example.org','Zacharyshire, MN 46324"','129657421','6','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jason','Costa',to_date('14.10.02','RR.MM.DD'),null,'edwardmorrow@example.com','"5589 Lance Corners','794001594','7','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jennifer','Haynes',to_date('14.10.02','RR.MM.DD'),null,'joshua90@example.net','Michaelburgh, OH 60130"','964443879','8','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Ashley','Stein',to_date('14.10.02','RR.MM.DD'),null,'krystal59@example.org','"8049 Adrian Throughway','414092098','9','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Holly','Palmer',to_date('14.10.02','RR.MM.DD'),null,'marygriffin@example.net','East Josephton, CO 34654"','726379798','10','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Martha','Smith',to_date('14.10.02','RR.MM.DD'),null,'rebecca99@example.net','"Unit 3517 Box 7175','625642285','11','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Christian','Robertson',to_date('14.10.02','RR.MM.DD'),null,'bushjoshua@example.net','DPO AE 73139"','891778968','12','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Lisa','Dudley',to_date('14.10.02','RR.MM.DD'),null,'kperkins@example.net','"1786 Debbie Terrace','336695154','13','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jennifer','Meyers',to_date('14.10.02','RR.MM.DD'),null,'johnsonluis@example.com','New Kathyfurt, CT 94630"','216467215','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Mr.','Matthew',to_date('14.10.02','RR.MM.DD'),null,'lblanchard@example.net','"7808 Melanie Rue','136100833','15','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Aaron','Turner',to_date('14.10.02','RR.MM.DD'),null,'rodriguezmonica@example.com','Shirleyhaven, RI 48773"','443298172','16','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Ellen','Wright',to_date('14.10.02','RR.MM.DD'),null,'michaellee@example.net','"19041 Nicholson Field Apt. 592','311230784','17','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jane','Stafford',to_date('14.10.02','RR.MM.DD'),null,'michaelrowe@example.com','East Andreaborough, DE 01264"','974891597','18','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Nichole','Mckinney',to_date('14.10.02','RR.MM.DD'),null,'phillipswilliam@example.com','"4645 Campos View','868868976','19','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Patricia','Carrillo',to_date('14.10.02','RR.MM.DD'),null,'nealbrandi@example.org','Port Kim, AR 99466"','810734855','20','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Edward','Allen',to_date('14.10.02','RR.MM.DD'),null,'xadams@example.com','"09780 Johnson Manor','479489642','21','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Kendra','Russell',to_date('14.10.02','RR.MM.DD'),null,'gregoryjohnson@example.net','Port Samuelmouth, NY 96222"','935471039','22','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Destiny','Nicholson',to_date('14.10.02','RR.MM.DD'),null,'dana26@example.org','"8796 Rodney Vista Apt. 090','434075072','23','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Alexander','Matthews',to_date('14.10.02','RR.MM.DD'),null,'jvelazquez@example.com','Stuartton, MA 32158"','573643588','24','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jeffrey','Vega',to_date('14.10.02','RR.MM.DD'),null,'jayers@example.org','"3237 Scott Centers','785307933','25','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Christina','Dalton',to_date('14.10.02','RR.MM.DD'),null,'josebriggs@example.net','East Nicholasland, IN 92402"','811295269','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Lauren','Campbell',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'rebeccayoung@example.net','"817 Julie Alley','159971018','27','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('David','Mason',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'coltonlam@example.org','Kimberlyland, CO 43722"','714135708','1','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Maria','Gentry',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'gallegoskathleen@example.net','"888 Castro Field','111377409','2','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Deborah','Collins',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'julie57@example.org','Freemanshire, FM 38384"','187814750','3','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Michael','Peterson',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'cmiller@example.net','"498 Thomas Glen Apt. 314','488436028','4','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('William','Caldwell',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'christianmorgan@example.com','North Bianca, MS 81219"','847172402','5','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Linda','White',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'janicedunn@example.net','"2256 Robert Trail Suite 219','132945328','6','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Michelle','Miller',to_date('14.10.02','RR.MM.DD'),to_date('18.10.02','RR.MM.DD'),'sarahpowers@example.net','West Andrew, AR 42462"','349210973','7','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Sherri','Owens',to_date('14.10.02','RR.MM.DD'),null,'austin03@example.net','"2933 Jennifer Rapids','559964649','8','N');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Robert','Day',to_date('14.10.02','RR.MM.DD'),null,'perkinsmaria@example.org','Aprilmouth, OH 09009"','429282057','9','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Andrea','Levine',to_date('14.10.02','RR.MM.DD'),null,'ianbrown@example.org','"950 Cynthia Causeway','737429945','10','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('James','Harris',to_date('14.10.02','RR.MM.DD'),null,'ofrazier@example.org','Willistown, IA 71156"','777328798','11','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('April','Gonzalez',to_date('14.10.02','RR.MM.DD'),null,'ymiller@example.org','"PSC 4366, Box 9602','968052725','12','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Chase','West',to_date('14.10.02','RR.MM.DD'),null,'hmassey@example.net','APO AA 58037"','833526949','13','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Richard','Mendez',to_date('14.10.02','RR.MM.DD'),null,'william33@example.net','"USNV Buck','881916036','14','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Christopher','Martinez',to_date('14.10.02','RR.MM.DD'),null,'hberg@example.net','FPO AP 18208"','205720841','15','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Lee','Collins',to_date('14.10.02','RR.MM.DD'),null,'turnerjon@example.com','"4849 Loretta Villages','754480635','16','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Jose','Romero',to_date('14.10.02','RR.MM.DD'),null,'mwhite@example.net','East Brian, IN 88067"','968791178','17','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Ashley','Lucas',to_date('14.10.02','RR.MM.DD'),null,'sandovalapril@example.net','"Unit 0632 Box 4702','567117161','18','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Duane','Duncan',to_date('14.10.02','RR.MM.DD'),null,'robin66@example.com','DPO AP 55248"','692796134','19','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Elizabeth','Scott',to_date('14.10.02','RR.MM.DD'),null,'nicholasmeyers@example.org','"670 Paul Isle','698260708','20','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Matthew','Luna',to_date('14.10.02','RR.MM.DD'),null,'jeremyvasquez@example.com','Brianstad, MT 55405"','248680279','21','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Rebecca','Reyes',to_date('14.10.02','RR.MM.DD'),null,'plewis@example.org','"00336 Savage Island','530811045','22','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Sarah','Powell',to_date('14.10.02','RR.MM.DD'),null,'calhounkelly@example.org','North Tanya, SC 55402"','380193465','23','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Antonio','Mccall',to_date('14.10.02','RR.MM.DD'),null,'juliakelly@example.net','"6608 Lisa Tunnel','651169317','24','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Sarah','Boyd',to_date('13.10.02','RR.MM.DD'),null,'dwatts@example.org','Matthewstad, MN 08177"','448343637','25','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('David','Hawkins',to_date('13.10.02','RR.MM.DD'),null,'michaelwarner@example.com','"993 Hunter Squares Apt. 437','370797821','26','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('David','Chapman',to_date('13.10.02','RR.MM.DD'),null,'garyriley@example.com','Port Sheilatown, CA 09096"','530216092','27','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Kimberly','Hernandez',to_date('13.10.02','RR.MM.DD'),null,'kingjacob@example.com','"006 Daugherty Forest','562577558','1','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Robert','Perez',to_date('13.10.02','RR.MM.DD'),null,'wagnersarah@example.net','South Danielmouth, TN 48233"','433087970','2','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('James','Palmer',to_date('13.10.02','RR.MM.DD'),null,'kjackson@example.org','"92590 Erickson Ramp','570917164','3','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Joshua','Clark',to_date('13.10.02','RR.MM.DD'),null,'samueljones@example.com','Frankbury, WA 21042"','914328842','4','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Brittany','Collins',to_date('13.10.02','RR.MM.DD'),null,'jennifer69@example.net','"6791 Riggs Avenue Suite 321','531214210','5','Y');
Insert into staff (EMP_FNAME,EMP_LNAME,DATE_JOINING,DATE_SEPERATION,EMAIL,ADDRESS,SSN,IDDEPARTMENT,IS_ACTIVE_STATUS) values ('Angela','Park',to_date('13.10.02','RR.MM.DD'),null,'williamsjames@example.net','West Michellefort, MO 61147"','705689027','6','Y');


Insert into nurse (STAFF_EMP_ID) values ('4');
Insert into nurse (STAFF_EMP_ID) values ('5');
Insert into nurse (STAFF_EMP_ID) values ('7');
Insert into nurse (STAFF_EMP_ID) values ('10');
Insert into nurse (STAFF_EMP_ID) values ('12');
Insert into nurse (STAFF_EMP_ID) values ('16');
Insert into nurse (STAFF_EMP_ID) values ('18');
Insert into nurse (STAFF_EMP_ID) values ('20');
Insert into nurse (STAFF_EMP_ID) values ('21');
Insert into nurse (STAFF_EMP_ID) values ('22');
Insert into nurse (STAFF_EMP_ID) values ('23');
Insert into nurse (STAFF_EMP_ID) values ('25');
Insert into nurse (STAFF_EMP_ID) values ('26');
Insert into nurse (STAFF_EMP_ID) values ('27');
Insert into nurse (STAFF_EMP_ID) values ('28');
Insert into nurse (STAFF_EMP_ID) values ('29');
Insert into nurse (STAFF_EMP_ID) values ('31');
Insert into nurse (STAFF_EMP_ID) values ('32');
Insert into nurse (STAFF_EMP_ID) values ('33');
Insert into nurse (STAFF_EMP_ID) values ('35');
Insert into nurse (STAFF_EMP_ID) values ('36');
Insert into nurse (STAFF_EMP_ID) values ('37');
Insert into nurse (STAFF_EMP_ID) values ('38');
Insert into nurse (STAFF_EMP_ID) values ('39');
Insert into nurse (STAFF_EMP_ID) values ('40');
Insert into nurse (STAFF_EMP_ID) values ('41');
Insert into nurse (STAFF_EMP_ID) values ('42');
Insert into nurse (STAFF_EMP_ID) values ('44');
Insert into nurse (STAFF_EMP_ID) values ('45');
Insert into nurse (STAFF_EMP_ID) values ('47');
Insert into nurse (STAFF_EMP_ID) values ('48');
Insert into nurse (STAFF_EMP_ID) values ('50');
Insert into nurse (STAFF_EMP_ID) values ('51');
Insert into nurse (STAFF_EMP_ID) values ('52');
Insert into nurse (STAFF_EMP_ID) values ('53');
Insert into nurse (STAFF_EMP_ID) values ('54');
Insert into nurse (STAFF_EMP_ID) values ('55');
Insert into nurse (STAFF_EMP_ID) values ('58');
Insert into nurse (STAFF_EMP_ID) values ('59');
Insert into nurse (STAFF_EMP_ID) values ('60');
Insert into nurse (STAFF_EMP_ID) values ('61');
Insert into nurse (STAFF_EMP_ID) values ('64');
Insert into nurse (STAFF_EMP_ID) values ('65');
Insert into nurse (STAFF_EMP_ID) values ('67');
Insert into nurse (STAFF_EMP_ID) values ('68');
Insert into nurse (STAFF_EMP_ID) values ('69');
Insert into nurse (STAFF_EMP_ID) values ('72');
Insert into nurse (STAFF_EMP_ID) values ('74');
Insert into nurse (STAFF_EMP_ID) values ('75');
Insert into nurse (STAFF_EMP_ID) values ('77');
Insert into nurse (STAFF_EMP_ID) values ('78');
Insert into nurse (STAFF_EMP_ID) values ('79');
Insert into nurse (STAFF_EMP_ID) values ('80');
Insert into nurse (STAFF_EMP_ID) values ('81');
Insert into nurse (STAFF_EMP_ID) values ('84');
Insert into nurse (STAFF_EMP_ID) values ('86');
Insert into nurse (STAFF_EMP_ID) values ('87');
Insert into nurse (STAFF_EMP_ID) values ('88');
Insert into nurse (STAFF_EMP_ID) values ('90');
Insert into nurse (STAFF_EMP_ID) values ('91');
Insert into nurse (STAFF_EMP_ID) values ('93');
Insert into nurse (STAFF_EMP_ID) values ('94');
Insert into nurse (STAFF_EMP_ID) values ('95');
Insert into nurse (STAFF_EMP_ID) values ('98');

Insert into technician (STAFF_EMP_ID) values ('43');
Insert into technician (STAFF_EMP_ID) values ('46');
Insert into technician (STAFF_EMP_ID) values ('49');
Insert into technician (STAFF_EMP_ID) values ('70');
Insert into technician (STAFF_EMP_ID) values ('73');
Insert into technician (STAFF_EMP_ID) values ('76');
Insert into technician (STAFF_EMP_ID) values ('97');
Insert into technician (STAFF_EMP_ID) values ('100');

Insert into doctor (EMP_ID,QUALIFICATIONS) values ('83','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('63','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('6','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('99','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('17','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('24','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('13','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('2','PhD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('85','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('1','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('89','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('57','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('8','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('82','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('66','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('9','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('15','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('34','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('11','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('56','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('96','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('62','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('30','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('14','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('92','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('3','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('19','MD');
Insert into doctor (EMP_ID,QUALIFICATIONS) values ('71','PhD');

Insert into EPISODE (PATIENT_IDPATIENT) values ('1');
Insert into EPISODE (PATIENT_IDPATIENT) values ('2');
Insert into EPISODE (PATIENT_IDPATIENT) values ('3');
Insert into EPISODE (PATIENT_IDPATIENT) values ('4');
Insert into EPISODE (PATIENT_IDPATIENT) values ('5');
Insert into EPISODE (PATIENT_IDPATIENT) values ('6');
Insert into EPISODE (PATIENT_IDPATIENT) values ('7');
Insert into EPISODE (PATIENT_IDPATIENT) values ('8');
Insert into EPISODE (PATIENT_IDPATIENT) values ('9');
Insert into EPISODE (PATIENT_IDPATIENT) values ('10');
Insert into EPISODE (PATIENT_IDPATIENT) values ('11');
Insert into EPISODE (PATIENT_IDPATIENT) values ('12');
Insert into EPISODE (PATIENT_IDPATIENT) values ('13');
Insert into EPISODE (PATIENT_IDPATIENT) values ('14');
Insert into EPISODE (PATIENT_IDPATIENT) values ('15');
Insert into EPISODE (PATIENT_IDPATIENT) values ('16');
Insert into EPISODE (PATIENT_IDPATIENT) values ('17');
Insert into EPISODE (PATIENT_IDPATIENT) values ('18');
Insert into EPISODE (PATIENT_IDPATIENT) values ('19');
Insert into EPISODE (PATIENT_IDPATIENT) values ('20');
Insert into EPISODE (PATIENT_IDPATIENT) values ('21');
Insert into EPISODE (PATIENT_IDPATIENT) values ('22');
Insert into EPISODE (PATIENT_IDPATIENT) values ('23');
Insert into EPISODE (PATIENT_IDPATIENT) values ('24');
Insert into EPISODE (PATIENT_IDPATIENT) values ('25');
Insert into EPISODE (PATIENT_IDPATIENT) values ('26');
Insert into EPISODE (PATIENT_IDPATIENT) values ('27');
Insert into EPISODE (PATIENT_IDPATIENT) values ('28');
Insert into EPISODE (PATIENT_IDPATIENT) values ('29');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('31');
Insert into EPISODE (PATIENT_IDPATIENT) values ('32');
Insert into EPISODE (PATIENT_IDPATIENT) values ('33');
Insert into EPISODE (PATIENT_IDPATIENT) values ('34');
Insert into EPISODE (PATIENT_IDPATIENT) values ('35');
Insert into EPISODE (PATIENT_IDPATIENT) values ('36');
Insert into EPISODE (PATIENT_IDPATIENT) values ('37');
Insert into EPISODE (PATIENT_IDPATIENT) values ('38');
Insert into EPISODE (PATIENT_IDPATIENT) values ('39');
Insert into EPISODE (PATIENT_IDPATIENT) values ('40');
Insert into EPISODE (PATIENT_IDPATIENT) values ('41');
Insert into EPISODE (PATIENT_IDPATIENT) values ('42');
Insert into EPISODE (PATIENT_IDPATIENT) values ('43');
Insert into EPISODE (PATIENT_IDPATIENT) values ('44');
Insert into EPISODE (PATIENT_IDPATIENT) values ('45');
Insert into EPISODE (PATIENT_IDPATIENT) values ('46');
Insert into EPISODE (PATIENT_IDPATIENT) values ('47');
Insert into EPISODE (PATIENT_IDPATIENT) values ('48');
Insert into EPISODE (PATIENT_IDPATIENT) values ('49');
Insert into EPISODE (PATIENT_IDPATIENT) values ('50');
Insert into EPISODE (PATIENT_IDPATIENT) values ('51');
Insert into EPISODE (PATIENT_IDPATIENT) values ('52');
Insert into EPISODE (PATIENT_IDPATIENT) values ('53');
Insert into EPISODE (PATIENT_IDPATIENT) values ('54');
Insert into EPISODE (PATIENT_IDPATIENT) values ('55');
Insert into EPISODE (PATIENT_IDPATIENT) values ('56');
Insert into EPISODE (PATIENT_IDPATIENT) values ('57');
Insert into EPISODE (PATIENT_IDPATIENT) values ('58');
Insert into EPISODE (PATIENT_IDPATIENT) values ('59');
Insert into EPISODE (PATIENT_IDPATIENT) values ('60');
Insert into EPISODE (PATIENT_IDPATIENT) values ('61');
Insert into EPISODE (PATIENT_IDPATIENT) values ('62');
Insert into EPISODE (PATIENT_IDPATIENT) values ('63');
Insert into EPISODE (PATIENT_IDPATIENT) values ('64');
Insert into EPISODE (PATIENT_IDPATIENT) values ('65');
Insert into EPISODE (PATIENT_IDPATIENT) values ('66');
Insert into EPISODE (PATIENT_IDPATIENT) values ('67');
Insert into EPISODE (PATIENT_IDPATIENT) values ('68');
Insert into EPISODE (PATIENT_IDPATIENT) values ('69');
Insert into EPISODE (PATIENT_IDPATIENT) values ('70');
Insert into EPISODE (PATIENT_IDPATIENT) values ('71');
Insert into EPISODE (PATIENT_IDPATIENT) values ('72');
Insert into EPISODE (PATIENT_IDPATIENT) values ('73');
Insert into EPISODE (PATIENT_IDPATIENT) values ('74');
Insert into EPISODE (PATIENT_IDPATIENT) values ('75');
Insert into EPISODE (PATIENT_IDPATIENT) values ('76');
Insert into EPISODE (PATIENT_IDPATIENT) values ('77');
Insert into EPISODE (PATIENT_IDPATIENT) values ('78');
Insert into EPISODE (PATIENT_IDPATIENT) values ('79');
Insert into EPISODE (PATIENT_IDPATIENT) values ('80');
Insert into EPISODE (PATIENT_IDPATIENT) values ('81');
Insert into EPISODE (PATIENT_IDPATIENT) values ('82');
Insert into EPISODE (PATIENT_IDPATIENT) values ('83');
Insert into EPISODE (PATIENT_IDPATIENT) values ('84');
Insert into EPISODE (PATIENT_IDPATIENT) values ('85');
Insert into EPISODE (PATIENT_IDPATIENT) values ('86');
Insert into EPISODE (PATIENT_IDPATIENT) values ('87');
Insert into EPISODE (PATIENT_IDPATIENT) values ('88');
Insert into EPISODE (PATIENT_IDPATIENT) values ('89');
Insert into EPISODE (PATIENT_IDPATIENT) values ('90');
Insert into EPISODE (PATIENT_IDPATIENT) values ('85');
Insert into EPISODE (PATIENT_IDPATIENT) values ('86');
Insert into EPISODE (PATIENT_IDPATIENT) values ('87');
Insert into EPISODE (PATIENT_IDPATIENT) values ('88');
Insert into EPISODE (PATIENT_IDPATIENT) values ('89');
Insert into EPISODE (PATIENT_IDPATIENT) values ('90');
Insert into EPISODE (PATIENT_IDPATIENT) values ('50');
Insert into EPISODE (PATIENT_IDPATIENT) values ('51');
Insert into EPISODE (PATIENT_IDPATIENT) values ('52');
Insert into EPISODE (PATIENT_IDPATIENT) values ('53');
Insert into EPISODE (PATIENT_IDPATIENT) values ('54');
Insert into EPISODE (PATIENT_IDPATIENT) values ('55');
Insert into EPISODE (PATIENT_IDPATIENT) values ('56');
Insert into EPISODE (PATIENT_IDPATIENT) values ('57');
Insert into EPISODE (PATIENT_IDPATIENT) values ('58');
Insert into EPISODE (PATIENT_IDPATIENT) values ('59');
Insert into EPISODE (PATIENT_IDPATIENT) values ('60');
Insert into EPISODE (PATIENT_IDPATIENT) values ('61');
Insert into EPISODE (PATIENT_IDPATIENT) values ('62');
Insert into EPISODE (PATIENT_IDPATIENT) values ('63');
Insert into EPISODE (PATIENT_IDPATIENT) values ('64');
Insert into EPISODE (PATIENT_IDPATIENT) values ('65');
Insert into EPISODE (PATIENT_IDPATIENT) values ('66');
Insert into EPISODE (PATIENT_IDPATIENT) values ('67');
Insert into EPISODE (PATIENT_IDPATIENT) values ('68');
Insert into EPISODE (PATIENT_IDPATIENT) values ('69');
Insert into EPISODE (PATIENT_IDPATIENT) values ('70');
Insert into EPISODE (PATIENT_IDPATIENT) values ('71');
Insert into EPISODE (PATIENT_IDPATIENT) values ('72');
Insert into EPISODE (PATIENT_IDPATIENT) values ('73');
Insert into EPISODE (PATIENT_IDPATIENT) values ('74');
Insert into EPISODE (PATIENT_IDPATIENT) values ('75');
Insert into EPISODE (PATIENT_IDPATIENT) values ('76');
Insert into EPISODE (PATIENT_IDPATIENT) values ('77');
Insert into EPISODE (PATIENT_IDPATIENT) values ('78');
Insert into EPISODE (PATIENT_IDPATIENT) values ('79');
Insert into EPISODE (PATIENT_IDPATIENT) values ('80');
Insert into EPISODE (PATIENT_IDPATIENT) values ('81');
Insert into EPISODE (PATIENT_IDPATIENT) values ('82');
Insert into EPISODE (PATIENT_IDPATIENT) values ('83');
Insert into EPISODE (PATIENT_IDPATIENT) values ('84');
Insert into EPISODE (PATIENT_IDPATIENT) values ('85');
Insert into EPISODE (PATIENT_IDPATIENT) values ('86');
Insert into EPISODE (PATIENT_IDPATIENT) values ('87');
Insert into EPISODE (PATIENT_IDPATIENT) values ('88');
Insert into EPISODE (PATIENT_IDPATIENT) values ('89');
Insert into EPISODE (PATIENT_IDPATIENT) values ('90');
Insert into EPISODE (PATIENT_IDPATIENT) values ('70');
Insert into EPISODE (PATIENT_IDPATIENT) values ('71');
Insert into EPISODE (PATIENT_IDPATIENT) values ('72');
Insert into EPISODE (PATIENT_IDPATIENT) values ('73');
Insert into EPISODE (PATIENT_IDPATIENT) values ('74');
Insert into EPISODE (PATIENT_IDPATIENT) values ('75');
Insert into EPISODE (PATIENT_IDPATIENT) values ('76');
Insert into EPISODE (PATIENT_IDPATIENT) values ('77');
Insert into EPISODE (PATIENT_IDPATIENT) values ('78');
Insert into EPISODE (PATIENT_IDPATIENT) values ('79');
Insert into EPISODE (PATIENT_IDPATIENT) values ('80');
Insert into EPISODE (PATIENT_IDPATIENT) values ('81');
Insert into EPISODE (PATIENT_IDPATIENT) values ('82');
Insert into EPISODE (PATIENT_IDPATIENT) values ('83');
Insert into EPISODE (PATIENT_IDPATIENT) values ('84');
Insert into EPISODE (PATIENT_IDPATIENT) values ('85');
Insert into EPISODE (PATIENT_IDPATIENT) values ('86');
Insert into EPISODE (PATIENT_IDPATIENT) values ('87');
Insert into EPISODE (PATIENT_IDPATIENT) values ('88');
Insert into EPISODE (PATIENT_IDPATIENT) values ('89');
Insert into EPISODE (PATIENT_IDPATIENT) values ('90');
Insert into EPISODE (PATIENT_IDPATIENT) values ('10');
Insert into EPISODE (PATIENT_IDPATIENT) values ('11');
Insert into EPISODE (PATIENT_IDPATIENT) values ('12');
Insert into EPISODE (PATIENT_IDPATIENT) values ('13');
Insert into EPISODE (PATIENT_IDPATIENT) values ('14');
Insert into EPISODE (PATIENT_IDPATIENT) values ('15');
Insert into EPISODE (PATIENT_IDPATIENT) values ('1');
Insert into EPISODE (PATIENT_IDPATIENT) values ('2');
Insert into EPISODE (PATIENT_IDPATIENT) values ('3');
Insert into EPISODE (PATIENT_IDPATIENT) values ('4');
Insert into EPISODE (PATIENT_IDPATIENT) values ('5');
Insert into EPISODE (PATIENT_IDPATIENT) values ('6');
Insert into EPISODE (PATIENT_IDPATIENT) values ('7');
Insert into EPISODE (PATIENT_IDPATIENT) values ('8');
Insert into EPISODE (PATIENT_IDPATIENT) values ('9');
Insert into EPISODE (PATIENT_IDPATIENT) values ('10');
Insert into EPISODE (PATIENT_IDPATIENT) values ('11');
Insert into EPISODE (PATIENT_IDPATIENT) values ('12');
Insert into EPISODE (PATIENT_IDPATIENT) values ('13');
Insert into EPISODE (PATIENT_IDPATIENT) values ('14');
Insert into EPISODE (PATIENT_IDPATIENT) values ('15');
Insert into EPISODE (PATIENT_IDPATIENT) values ('1');
Insert into EPISODE (PATIENT_IDPATIENT) values ('2');
Insert into EPISODE (PATIENT_IDPATIENT) values ('3');
Insert into EPISODE (PATIENT_IDPATIENT) values ('4');
Insert into EPISODE (PATIENT_IDPATIENT) values ('5');
Insert into EPISODE (PATIENT_IDPATIENT) values ('6');
Insert into EPISODE (PATIENT_IDPATIENT) values ('7');
Insert into EPISODE (PATIENT_IDPATIENT) values ('8');
Insert into EPISODE (PATIENT_IDPATIENT) values ('9');
Insert into EPISODE (PATIENT_IDPATIENT) values ('10');
Insert into EPISODE (PATIENT_IDPATIENT) values ('11');
Insert into EPISODE (PATIENT_IDPATIENT) values ('12');
Insert into EPISODE (PATIENT_IDPATIENT) values ('13');
Insert into EPISODE (PATIENT_IDPATIENT) values ('14');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');
Insert into EPISODE (PATIENT_IDPATIENT) values ('30');

Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'9','3','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'57','4','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'39','5','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'83','6','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'80','1','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'86','2','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'11','3','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'19','4','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'75','5','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.24','RR.MM.DD'),'50','6','145');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'30','1','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'8','2','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'91','3','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'9','4','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'79','5','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'2','6','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.28','RR.MM.DD'),'34','7','146');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'28','1','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'9','2','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'18','3','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'88','4','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'72','5','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.13','RR.MM.DD'),'75','6','147');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'60','1','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'83','2','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'83','3','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'73','4','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'98','5','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'34','6','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'78','7','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'1','8','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.25','RR.MM.DD'),'70','9','148');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'46','1','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'72','2','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'57','3','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'85','4','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'6','5','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'73','6','149');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.10','RR.MM.DD'),'49','1','150');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'20','1','151');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'72','2','151');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'86','3','151');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'89','4','151');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'90','1','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'60','2','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'26','3','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'96','4','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'29','5','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'15','6','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'70','7','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'60','8','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'39','9','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.05','RR.MM.DD'),'63','10','152');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'9','1','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'52','2','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'53','3','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'51','4','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'41','5','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.23','RR.MM.DD'),'88','6','153');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'63','1','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'65','2','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'64','3','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'7','4','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'8','5','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'63','6','154');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'42','1','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'38','2','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'60','3','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'58','4','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'65','5','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'86','6','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'49','7','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'43','8','155');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.29','RR.MM.DD'),'69','1','156');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.29','RR.MM.DD'),'27','2','156');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.24','RR.MM.DD'),'48','1','157');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.24','RR.MM.DD'),'61','2','157');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.24','RR.MM.DD'),'9','3','157');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.24','RR.MM.DD'),'22','4','157');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.24','RR.MM.DD'),'5','5','157');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'9','1','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'56','3','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'15','4','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'2','6','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'84','8','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.22','RR.MM.DD'),'96','2','159');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.22','RR.MM.DD'),'65','4','159');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.24','RR.MM.DD'),'62','1','160');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'86','1','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'78','2','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'56','3','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'10','4','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'82','5','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.21','RR.MM.DD'),'71','6','161');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.25','RR.MM.DD'),'35','1','162');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.25','RR.MM.DD'),'98','2','162');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.25','RR.MM.DD'),'1','3','162');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.09','RR.MM.DD'),'49','1','163');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.09','RR.MM.DD'),'10','2','163');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'43','1','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'73','2','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'3','3','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'61','4','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'21','5','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.26','RR.MM.DD'),'53','6','164');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'39','1','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'22','2','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'95','3','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'50','4','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'61','5','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'49','6','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'15','7','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.05.06','RR.MM.DD'),'45','8','165');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'25','1','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'13','2','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'26','3','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'4','4','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'70','5','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'90','6','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.08','RR.MM.DD'),'91','7','166');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.20','RR.MM.DD'),'14','1','167');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.20','RR.MM.DD'),'8','2','167');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.20','RR.MM.DD'),'38','3','167');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.20','RR.MM.DD'),'66','4','167');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'99','1','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'58','2','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'40','3','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'58','4','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'38','5','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'53','6','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.19','RR.MM.DD'),'17','7','168');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.16','RR.MM.DD'),'42','1','169');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.02.16','RR.MM.DD'),'41','2','169');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'51','1','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'36','2','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'39','3','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'5','4','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'23','5','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'27','6','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'41','7','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.07.10','RR.MM.DD'),'52','8','170');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.12.08','RR.MM.DD'),'24','1','171');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.12.08','RR.MM.DD'),'4','2','171');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.12.08','RR.MM.DD'),'80','3','171');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.12.08','RR.MM.DD'),'39','4','171');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.12.08','RR.MM.DD'),'1','5','171');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'56','1','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'80','2','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'40','3','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'27','4','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'83','5','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'52','6','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'35','7','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'78','8','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.05','RR.MM.DD'),'79','9','172');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.11','RR.MM.DD'),'3','1','173');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.11','RR.MM.DD'),'77','2','173');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.11','RR.MM.DD'),'63','3','173');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.11','RR.MM.DD'),'55','4','173');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'54','1','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'75','2','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'48','3','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'64','4','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'8','5','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'92','6','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'16','7','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'32','8','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.11','RR.MM.DD'),'82','9','174');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'31','1','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'42','2','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'46','3','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'2','4','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'99','5','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.03','RR.MM.DD'),'45','6','175');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'38','1','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'78','2','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'79','3','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'99','4','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'66','5','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'75','6','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'19','7','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'62','8','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'84','9','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.19','RR.MM.DD'),'37','10','176');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'67','1','177');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.31','RR.MM.DD'),'93','1','178');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'87','1','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'72','3','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'54','4','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'69','6','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'11','8','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'83','1','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'50','2','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'79','3','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'72','4','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'16','5','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'11','6','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.08','RR.MM.DD'),'81','7','180');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'30','1','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'4','3','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'16','4','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'84','6','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'74','8','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'26','2','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'9','3','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'18','5','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'18','7','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'14','2','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'48','4','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'58','5','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'17','1','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'90','3','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'94','5','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'18','6','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'96','8','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.09','RR.MM.DD'),'9','2','185');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'67','2','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'41','4','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'80','5','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'77','7','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'28','9','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.16','RR.MM.DD'),'80','3','187');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'63','1','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'69','2','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'32','3','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'59','4','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'45','5','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'84','6','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'92','7','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.19','RR.MM.DD'),'92','8','188');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'3','1','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'70','3','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'40','5','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'33','1','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'84','2','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'36','3','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'58','4','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'34','5','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'87','6','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'89','7','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'79','8','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.04','RR.MM.DD'),'75','9','190');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'41','1','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'96','3','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'45','4','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'41','6','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'49','8','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.28','RR.MM.DD'),'91','1','192');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.28','RR.MM.DD'),'7','2','192');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.28','RR.MM.DD'),'80','5','192');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.29','RR.MM.DD'),'20','3','193');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'68','3','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'81','7','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'38','1','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'41','5','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'33','1','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'17','2','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'51','3','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'22','4','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'12','5','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'68','6','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.16','RR.MM.DD'),'45','7','196');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.02','RR.MM.DD'),'13','2','197');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.02','RR.MM.DD'),'90','4','197');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'53','1','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'59','3','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'85','5','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'26','1','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'21','5','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'30','6','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'70','1','200');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'33','2','200');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'55','3','200');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'25','2','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'67','4','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'33','6','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'32','8','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'56','3','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'46','5','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.15','RR.MM.DD'),'13','1','39');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.10.02','RR.MM.DD'),'69','2','40');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'99','2','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'27','4','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'90','6','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'18','9','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.01','RR.MM.DD'),'23','2','43');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.01','RR.MM.DD'),'12','4','43');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.04','RR.MM.DD'),'21','1','44');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'79','2','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'23','4','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'84','6','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'74','3','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'11','5','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'45','7','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.14','RR.MM.DD'),'14','2','48');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.14','RR.MM.DD'),'3','4','48');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.15','RR.MM.DD'),'24','2','49');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.12.17','RR.MM.DD'),'90','1','50');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'33','3','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'81','5','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'69','1','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'38','3','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'54','5','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'95','7','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.27','RR.MM.DD'),'68','2','53');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.10','RR.MM.DD'),'91','1','58');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.10','RR.MM.DD'),'20','3','58');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.10','RR.MM.DD'),'70','5','58');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'4','2','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'60','4','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'70','6','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'27','8','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.12','RR.MM.DD'),'89','3','60');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.12','RR.MM.DD'),'34','5','60');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'61','2','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'11','4','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'30','6','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'5','8','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'60','10','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'1','2','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'71','4','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'58','6','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'19','1','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'2','3','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'68','5','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'1','7','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.26','RR.MM.DD'),'74','2','68');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.26','RR.MM.DD'),'81','4','68');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.11.14','RR.MM.DD'),'84','1','69');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.11.14','RR.MM.DD'),'77','3','69');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.11.14','RR.MM.DD'),'93','5','69');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.10','RR.MM.DD'),'78','2','70');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'91','1','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'79','4','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'11','6','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.29','RR.MM.DD'),'32','2','74');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.09','RR.MM.DD'),'36','2','81');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.02','RR.MM.DD'),'90','1','83');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'5','1','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'11','3','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'66','5','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'7','8','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'58','2','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'87','4','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'4','6','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'32','8','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'82','10','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'64','2','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'55','5','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'86','7','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'66','9','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'28','1','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'9','3','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'93','5','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'77','7','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'96','3','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'23','5','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'88','1','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'39','3','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'15','5','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'45','8','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'94','10','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'20','2','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'97','4','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'64','7','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'94','9','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'53','1','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.16','RR.MM.DD'),'89','1','187');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.16','RR.MM.DD'),'91','4','187');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.28','RR.MM.DD'),'40','4','192');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.29','RR.MM.DD'),'55','1','193');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.29','RR.MM.DD'),'90','4','193');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'12','2','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'48','4','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'67','6','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'58','2','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'79','4','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'29','6','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'58','6','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'91','8','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'33','2','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'21','4','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'82','7','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'81','7','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.04','RR.MM.DD'),'67','1','3');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.04','RR.MM.DD'),'47','3','3');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'46','2','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'44','5','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'29','1','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'47','3','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'54','5','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'97','6','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'74','1','96');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'65','3','96');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'86','4','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'5','6','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.03.01','RR.MM.DD'),'64','1','116');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'17','1','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'31','3','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'61','5','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'44','8','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'68','5','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'22','8','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'10','6','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'55','8','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'42','10','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'2','7','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'38','2','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'90','5','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'97','7','158');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.22','RR.MM.DD'),'92','1','159');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.22','RR.MM.DD'),'63','3','159');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.11.14','RR.MM.DD'),'32','2','69');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.10','RR.MM.DD'),'53','1','70');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'71','2','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'15','8','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.07','RR.MM.DD'),'5','3','98');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'95','3','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'5','5','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'11','7','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'41','9','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'65','2','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'21','9','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'78','2','177');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.31','RR.MM.DD'),'27','2','178');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'11','2','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'32','5','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'16','7','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.25','RR.MM.DD'),'81','9','179');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'31','2','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'60','5','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.15','RR.MM.DD'),'79','7','181');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'27','1','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'54','4','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.07','RR.MM.DD'),'52','6','182');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'31','1','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'11','3','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.05','RR.MM.DD'),'51','6','183');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'54','2','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'77','4','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.09.19','RR.MM.DD'),'92','7','184');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.11.09','RR.MM.DD'),'14','1','185');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'78','1','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'85','3','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'57','6','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.14','RR.MM.DD'),'69','8','186');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.16','RR.MM.DD'),'38','2','187');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'71','2','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'77','4','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.02','RR.MM.DD'),'34','6','189');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'21','2','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'72','5','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'63','7','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.17','RR.MM.DD'),'51','9','191');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.28','RR.MM.DD'),'1','3','192');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.29','RR.MM.DD'),'18','2','193');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'2','1','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.17','RR.MM.DD'),'71','5','194');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.02','RR.MM.DD'),'72','3','195');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.02','RR.MM.DD'),'33','1','197');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.02','RR.MM.DD'),'22','3','197');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'77','2','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'80','4','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.09','RR.MM.DD'),'87','7','198');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.17','RR.MM.DD'),'78','3','199');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'41','2','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'31','4','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'8','6','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'43','8','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'7','1','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'47','3','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'6','5','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'6','8','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.19','RR.MM.DD'),'76','2','14');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'65','1','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'46','3','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'84','5','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'65','7','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'58','2','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'80','5','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'70','7','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'91','9','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'34','2','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'73','4','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'53','6','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'75','8','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.04','RR.MM.DD'),'4','2','31');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'93','2','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'29','4','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'57','6','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'76','8','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.04','RR.MM.DD'),'89','2','42');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.04','RR.MM.DD'),'95','4','42');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.23','RR.MM.DD'),'17','2','54');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.23','RR.MM.DD'),'63','4','54');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'38','1','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'46','3','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'86','5','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'26','7','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.20','RR.MM.DD'),'46','2','56');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'13','2','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'35','4','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'59','6','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.23','RR.MM.DD'),'86','1','63');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.23','RR.MM.DD'),'16','3','63');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.18','RR.MM.DD'),'97','1','72');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.18','RR.MM.DD'),'5','3','72');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.24','RR.MM.DD'),'6','2','73');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'85','3','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'68','5','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'71','7','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'89','1','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'13','3','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'62','5','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'77','7','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.13','RR.MM.DD'),'79','1','109');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.13','RR.MM.DD'),'19','3','109');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'74','1','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'22','3','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'51','5','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.08.15','RR.MM.DD'),'88','1','112');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.07','RR.MM.DD'),'64','1','113');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.07','RR.MM.DD'),'24','3','113');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'33','1','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'26','5','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'100','8','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'43','2','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'51','6','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.15','RR.MM.DD'),'12','2','119');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.13','RR.MM.DD'),'38','1','120');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.13','RR.MM.DD'),'66','3','120');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.06.18','RR.MM.DD'),'48','1','122');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.06.18','RR.MM.DD'),'97','3','122');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.26','RR.MM.DD'),'76','2','125');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'50','1','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'37','4','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'35','6','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'51','8','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'6','3','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'98','6','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('13.12.21','RR.MM.DD'),'72','1','1');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('13.12.21','RR.MM.DD'),'47','2','1');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('13.12.21','RR.MM.DD'),'64','3','1');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('13.12.21','RR.MM.DD'),'9','4','1');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('13.12.21','RR.MM.DD'),'90','5','1');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'38','1','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'35','2','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'91','3','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'72','4','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'44','5','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'16','6','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.18','RR.MM.DD'),'49','8','2');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.04','RR.MM.DD'),'43','2','3');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.04','RR.MM.DD'),'50','4','3');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.29','RR.MM.DD'),'41','1','4');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'70','1','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'59','3','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'66','4','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.21','RR.MM.DD'),'78','6','5');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'14','2','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'50','4','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.28','RR.MM.DD'),'9','6','6');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'69','1','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'26','2','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'71','3','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'6','4','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'4','5','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'65','6','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.23','RR.MM.DD'),'56','7','7');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'31','1','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'49','2','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'66','3','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'80','4','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'69','5','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'84','6','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'60','7','8');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'11','1','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'88','3','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'13','5','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'86','7','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'9','9','9');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'82','1','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'40','2','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'27','3','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'51','4','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'87','5','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.28','RR.MM.DD'),'50','6','10');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'73','2','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'12','4','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'73','6','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.21','RR.MM.DD'),'71','7','11');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.27','RR.MM.DD'),'26','1','12');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.27','RR.MM.DD'),'28','2','12');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.27','RR.MM.DD'),'50','3','12');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.27','RR.MM.DD'),'4','4','12');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'63','1','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'69','2','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'2','3','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'78','4','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'62','5','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'61','6','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.21','RR.MM.DD'),'93','7','13');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.04.19','RR.MM.DD'),'77','1','14');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'45','1','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'30','2','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'16','3','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'43','4','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'18','5','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.24','RR.MM.DD'),'4','6','15');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'38','1','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'27','2','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'79','3','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'89','4','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'33','5','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.14','RR.MM.DD'),'56','6','16');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.08','RR.MM.DD'),'76','1','17');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.08','RR.MM.DD'),'13','2','17');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'62','1','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'11','2','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'49','3','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'6','4','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'77','5','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.27','RR.MM.DD'),'52','6','18');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'2','1','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'87','2','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'45','3','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'2','4','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'27','5','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.23','RR.MM.DD'),'49','6','19');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'18','1','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'76','2','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'27','3','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'48','4','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'90','5','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.23','RR.MM.DD'),'75','6','20');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'73','1','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'51','2','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'7','3','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'39','4','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'36','5','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.28','RR.MM.DD'),'20','6','21');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'45','1','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'14','2','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'36','3','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'24','4','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'71','5','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'42','6','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'20','7','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'54','8','22');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'12','1','23');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'46','2','23');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'17','3','23');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'45','1','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'44','2','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'53','3','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'14','4','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'55','5','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'2','6','24');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.11','RR.MM.DD'),'37','1','25');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'31','1','26');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'76','2','26');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'49','3','26');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'1','2','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'68','4','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.09.05','RR.MM.DD'),'22','6','27');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'25','1','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'86','3','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'21','4','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'76','6','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.15','RR.MM.DD'),'63','8','28');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'92','1','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'27','3','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'28','5','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'13','7','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.10','RR.MM.DD'),'58','9','29');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.27','RR.MM.DD'),'54','1','30');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.27','RR.MM.DD'),'93','2','30');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.27','RR.MM.DD'),'77','3','30');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.27','RR.MM.DD'),'100','4','30');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.27','RR.MM.DD'),'24','5','30');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.06.04','RR.MM.DD'),'10','1','31');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'92','1','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'6','2','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'70','3','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'73','4','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'46','5','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'65','6','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'24','7','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.09.11','RR.MM.DD'),'28','8','32');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'18','1','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'91','3','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'55','5','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.09','RR.MM.DD'),'49','7','33');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.16','RR.MM.DD'),'77','1','34');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.16','RR.MM.DD'),'76','2','34');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.16','RR.MM.DD'),'18','1','35');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.11','RR.MM.DD'),'15','1','36');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.11','RR.MM.DD'),'42','2','36');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.11','RR.MM.DD'),'94','3','36');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.11','RR.MM.DD'),'48','4','36');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'96','1','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'56','3','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'75','5','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.15','RR.MM.DD'),'65','7','37');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'57','1','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'54','2','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'45','4','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.27','RR.MM.DD'),'4','6','38');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.10.02','RR.MM.DD'),'3','1','40');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'76','1','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'19','3','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'42','5','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'34','7','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.23','RR.MM.DD'),'99','8','41');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.04','RR.MM.DD'),'42','1','42');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.04','RR.MM.DD'),'79','3','42');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.04','RR.MM.DD'),'58','5','42');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.01','RR.MM.DD'),'58','1','43');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.01','RR.MM.DD'),'85','3','43');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.01','RR.MM.DD'),'12','5','43');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'79','1','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'15','3','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.23','RR.MM.DD'),'40','5','45');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.20','RR.MM.DD'),'70','1','46');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.20','RR.MM.DD'),'91','3','46');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.20','RR.MM.DD'),'22','4','46');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'46','1','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'1','2','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'49','4','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.12','RR.MM.DD'),'72','6','47');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.14','RR.MM.DD'),'49','1','48');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.14','RR.MM.DD'),'93','3','48');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.15','RR.MM.DD'),'88','1','49');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.15','RR.MM.DD'),'17','3','49');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'56','1','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'79','2','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'49','4','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.06','RR.MM.DD'),'74','6','51');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'64','2','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'63','4','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.20','RR.MM.DD'),'24','6','52');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.27','RR.MM.DD'),'98','1','53');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.27','RR.MM.DD'),'94','3','53');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.27','RR.MM.DD'),'30','4','53');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.23','RR.MM.DD'),'60','1','54');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.23','RR.MM.DD'),'15','3','54');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.01.23','RR.MM.DD'),'5','5','54');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'40','2','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'74','4','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.21','RR.MM.DD'),'26','6','55');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.20','RR.MM.DD'),'71','1','56');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.04.20','RR.MM.DD'),'19','3','56');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'42','1','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'48','3','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'98','5','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'44','7','57');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.10','RR.MM.DD'),'70','2','58');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.10','RR.MM.DD'),'19','4','58');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'22','1','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'16','3','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'46','5','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('17.11.08','RR.MM.DD'),'88','7','59');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.12','RR.MM.DD'),'52','1','60');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.12','RR.MM.DD'),'93','2','60');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.12','RR.MM.DD'),'61','4','60');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'43','1','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'73','3','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'16','5','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'29','7','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.13','RR.MM.DD'),'4','9','61');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.12','RR.MM.DD'),'33','1','62');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.23','RR.MM.DD'),'8','2','63');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'77','1','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'85','3','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'94','5','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.01','RR.MM.DD'),'72','7','64');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'35','2','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'9','4','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.08.13','RR.MM.DD'),'97','6','65');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.09','RR.MM.DD'),'16','1','66');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.27','RR.MM.DD'),'84','1','67');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.26','RR.MM.DD'),'47','1','68');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.26','RR.MM.DD'),'79','3','68');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('16.12.26','RR.MM.DD'),'9','5','68');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.11.14','RR.MM.DD'),'4','4','69');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.02.10','RR.MM.DD'),'60','3','70');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'9','3','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('15.12.05','RR.MM.DD'),'8','5','71');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.11.18','RR.MM.DD'),'26','2','72');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.01.24','RR.MM.DD'),'75','1','73');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.11.29','RR.MM.DD'),'73','1','74');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'94','1','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'49','2','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'48','4','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'3','6','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),'61','8','75');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'70','2','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'61','4','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'41','6','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'98','7','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'18','9','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'49','1','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'56','2','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'59','3','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'28','4','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'97','5','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.01.31','RR.MM.DD'),'32','7','93');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'33','1','94');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'52','2','94');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'3','3','94');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'79','4','94');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.22','RR.MM.DD'),'28','5','94');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.29','RR.MM.DD'),'40','1','95');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.29','RR.MM.DD'),'19','2','95');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.29','RR.MM.DD'),'45','3','95');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.29','RR.MM.DD'),'98','4','95');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.29','RR.MM.DD'),'50','5','95');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'62','2','96');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'9','1','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'98','2','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'94','3','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'28','4','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'1','5','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.10.21','RR.MM.DD'),'91','6','97');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.07','RR.MM.DD'),'64','1','98');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.07','RR.MM.DD'),'33','2','98');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.07','RR.MM.DD'),'33','4','98');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.28','RR.MM.DD'),'66','1','99');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.28','RR.MM.DD'),'59','2','99');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'41','1','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'93','2','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'97','4','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'43','6','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'83','8','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.08.23','RR.MM.DD'),'16','10','100');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'60','1','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'72','2','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'76','3','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'83','4','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'27','5','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'57','6','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.09.11','RR.MM.DD'),'55','7','101');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'54','1','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'97','2','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'88','3','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'63','4','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'8','5','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.05.31','RR.MM.DD'),'65','6','102');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'35','1','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'85','2','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'93','3','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'9','4','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'35','5','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.16','RR.MM.DD'),'59','6','103');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.03','RR.MM.DD'),'94','1','104');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.03','RR.MM.DD'),'47','2','104');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.03','RR.MM.DD'),'24','3','104');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.03','RR.MM.DD'),'17','4','104');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'48','1','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'2','2','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'24','3','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'70','4','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'55','5','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.12.31','RR.MM.DD'),'98','6','105');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'59','1','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'21','2','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'86','3','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'57','4','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'86','5','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'4','6','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'55','7','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.14','RR.MM.DD'),'22','8','106');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.04.29','RR.MM.DD'),'6','1','107');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'31','1','108');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'82','2','108');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'97','3','108');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'50','4','108');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.04','RR.MM.DD'),'45','5','108');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.13','RR.MM.DD'),'10','2','109');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.13','RR.MM.DD'),'83','4','109');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.05.13','RR.MM.DD'),'87','5','109');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.15','RR.MM.DD'),'31','1','110');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.15','RR.MM.DD'),'28','2','110');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.15','RR.MM.DD'),'80','3','110');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.15','RR.MM.DD'),'25','4','110');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.15','RR.MM.DD'),'8','5','110');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'62','2','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'28','4','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.11','RR.MM.DD'),'13','6','111');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.08.15','RR.MM.DD'),'48','2','112');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.08.15','RR.MM.DD'),'30','3','112');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.07','RR.MM.DD'),'86','2','113');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.03.07','RR.MM.DD'),'28','4','113');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.15','RR.MM.DD'),'66','1','114');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.15','RR.MM.DD'),'18','2','114');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.05.15','RR.MM.DD'),'89','3','114');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'88','2','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'38','3','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.05.24','RR.MM.DD'),'86','7','115');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.03.01','RR.MM.DD'),'39','2','116');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'56','4','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.10.26','RR.MM.DD'),'70','7','117');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'83','1','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'6','2','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'65','3','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'33','4','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'46','5','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'5','6','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'53','7','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.13','RR.MM.DD'),'66','8','118');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.15','RR.MM.DD'),'7','1','119');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.15','RR.MM.DD'),'13','3','119');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.13','RR.MM.DD'),'98','2','120');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.13','RR.MM.DD'),'8','4','120');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.13','RR.MM.DD'),'28','5','120');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'76','1','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'59','2','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'65','3','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'63','4','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'72','5','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.23','RR.MM.DD'),'68','6','121');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.06.18','RR.MM.DD'),'74','2','122');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'45','1','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'99','2','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'94','3','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'44','4','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'64','5','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'34','6','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),'41','7','123');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.05','RR.MM.DD'),'90','1','124');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.05','RR.MM.DD'),'24','2','124');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.05','RR.MM.DD'),'92','3','124');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.05','RR.MM.DD'),'12','4','124');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.26','RR.MM.DD'),'9','1','125');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.26','RR.MM.DD'),'75','3','125');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'57','2','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'17','3','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'10','5','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.08.06','RR.MM.DD'),'8','7','126');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'25','1','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'12','2','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.06.27','RR.MM.DD'),'43','4','127');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'14','1','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'50','2','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'76','3','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'46','4','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'85','5','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'77','6','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.06.04','RR.MM.DD'),'88','7','128');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'98','1','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'83','3','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'35','5','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'40','6','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'25','9','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.22','RR.MM.DD'),'84','1','130');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.22','RR.MM.DD'),'82','2','130');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.22','RR.MM.DD'),'32','3','130');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.22','RR.MM.DD'),'71','4','130');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'19','2','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'70','4','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'77','5','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'37','9','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'67','1','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'93','2','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'53','3','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'63','4','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'70','5','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'48','6','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'95','7','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.09','RR.MM.DD'),'99','8','132');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'68','7','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'83','1','77');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.10','RR.MM.DD'),'24','2','77');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.29','RR.MM.DD'),'46','2','78');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'78','1','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'86','2','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'57','3','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'14','4','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'64','5','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'56','6','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.17','RR.MM.DD'),'63','7','79');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'96','1','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'42','2','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'9','3','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'99','4','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'46','5','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.20','RR.MM.DD'),'62','6','80');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.09','RR.MM.DD'),'52','1','81');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.09','RR.MM.DD'),'97','3','81');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'71','2','82');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'56','4','82');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.09.02','RR.MM.DD'),'98','2','83');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.24','RR.MM.DD'),'24','1','84');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.02.24','RR.MM.DD'),'18','2','84');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'98','2','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'24','4','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'29','6','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.12.10','RR.MM.DD'),'57','7','86');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'69','1','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'23','3','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'11','5','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'6','7','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('18.05.20','RR.MM.DD'),'43','9','87');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'1','1','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'91','3','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'76','4','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'30','6','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.11.11','RR.MM.DD'),'74','8','88');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.11','RR.MM.DD'),'76','1','89');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.11','RR.MM.DD'),'46','2','89');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.28','RR.MM.DD'),'11','1','90');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'53','2','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'42','4','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.10.03','RR.MM.DD'),'19','6','91');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'71','1','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.12.15','RR.MM.DD'),'18','4','92');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.17','RR.MM.DD'),'73','1','133');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.17','RR.MM.DD'),'73','3','133');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.17','RR.MM.DD'),'61','5','133');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'75','2','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'93','4','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'32','6','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'6','7','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.16','RR.MM.DD'),'22','9','134');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.07.21','RR.MM.DD'),'26','2','135');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),'25','1','136');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),'77','3','136');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),'3','5','136');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'20','2','137');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.08.22','RR.MM.DD'),'26','2','138');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.08.22','RR.MM.DD'),'6','3','138');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'25','1','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'51','3','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'51','5','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'48','6','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'68','1','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'32','3','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'86','5','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'7','7','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'87','1','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'49','3','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'31','5','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'75','6','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'42','8','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.02','RR.MM.DD'),'95','10','141');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'14','1','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'60','3','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'39','5','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'56','7','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'3','8','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'41','10','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.25','RR.MM.DD'),'93','2','143');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.25','RR.MM.DD'),'56','4','143');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.02.11','RR.MM.DD'),'9','2','144');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'39','2','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'84','4','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.04.07','RR.MM.DD'),'44','7','129');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'50','1','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'56','3','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.07.16','RR.MM.DD'),'37','7','131');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.03.18','RR.MM.DD'),'59','6','76');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.03.29','RR.MM.DD'),'8','1','78');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'20','1','82');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'85','3','82');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.08.12','RR.MM.DD'),'93','5','82');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.07.24','RR.MM.DD'),'59','1','85');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.17','RR.MM.DD'),'51','2','133');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.09.17','RR.MM.DD'),'75','4','133');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.07.21','RR.MM.DD'),'43','1','135');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),'50','2','136');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),'87','4','136');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('22.12.20','RR.MM.DD'),'70','1','137');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.08.22','RR.MM.DD'),'5','1','138');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.08.22','RR.MM.DD'),'22','4','138');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'79','2','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'58','4','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('21.06.16','RR.MM.DD'),'30','7','139');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'46','2','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'89','4','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.08','RR.MM.DD'),'66','6','140');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'79','2','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'62','4','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'12','6','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('20.10.29','RR.MM.DD'),'73','9','142');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.25','RR.MM.DD'),'13','1','143');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.25','RR.MM.DD'),'85','3','143');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('19.01.25','RR.MM.DD'),'39','5','143');
Insert into PRESCRIPTION (PRESCRIPTION_DATE,DOSAGE,IDMEDICINE,IDEPISODE) values (to_date('23.12.20','RR.MM.DD'),'47','2','46');

Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('189.58',to_date('22.05.24','RR.MM.DD'),'43','115');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('16.96',to_date('23.07.27','RR.MM.DD'),'46','30');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('13.16',to_date('23.09.09','RR.MM.DD'),'49','132');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('10.28',to_date('23.03.20','RR.MM.DD'),'70','80');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('96.67',to_date('23.06.01','RR.MM.DD'),'73','123');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('115.17',to_date('23.05.19','RR.MM.DD'),'76','176');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('145.46',to_date('23.09.23','RR.MM.DD'),'97','41');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('145.54',to_date('19.02.19','RR.MM.DD'),'100','168');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('93.19',to_date('20.11.03','RR.MM.DD'),'43','175');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('105.02',to_date('23.09.23','RR.MM.DD'),'46','41');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('82.11',to_date('23.09.02','RR.MM.DD'),'49','83');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('131.4',to_date('18.12.10','RR.MM.DD'),'70','86');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('134.49',to_date('20.03.13','RR.MM.DD'),'73','120');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('138.3',to_date('20.06.27','RR.MM.DD'),'76','127');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('39.89',to_date('21.04.07','RR.MM.DD'),'97','129');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('171.11',to_date('22.09.29','RR.MM.DD'),'100','95');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('137.38',to_date('23.04.25','RR.MM.DD'),'43','148');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('180.88',to_date('19.12.31','RR.MM.DD'),'46','105');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('182.17',to_date('20.12.15','RR.MM.DD'),'49','57');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('90.29',to_date('20.12.15','RR.MM.DD'),'70','92');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('69.32',to_date('23.12.27','RR.MM.DD'),'73','53');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('82.47',to_date('23.08.25','RR.MM.DD'),'76','162');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('98.45',to_date('22.10.21','RR.MM.DD'),'97','97');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('17.09',to_date('23.08.02','RR.MM.DD'),'100','141');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('43.03',to_date('23.10.09','RR.MM.DD'),'43','81');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('90.97',to_date('22.06.18','RR.MM.DD'),'46','122');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('27.76',to_date('22.01.31','RR.MM.DD'),'49','93');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('121.51',to_date('22.01.31','RR.MM.DD'),'70','93');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('110.89',to_date('23.11.13','RR.MM.DD'),'73','158');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('43.35',to_date('20.05.31','RR.MM.DD'),'76','102');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('92.26',to_date('23.02.04','RR.MM.DD'),'43','108');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('107.98',to_date('18.08.13','RR.MM.DD'),'46','65');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('110.42',to_date('22.11.18','RR.MM.DD'),'49','72');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('145.61',to_date('19.08.23','RR.MM.DD'),'70','100');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('109.61',to_date('23.03.20','RR.MM.DD'),'73','80');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('121.75',to_date('20.12.15','RR.MM.DD'),'76','92');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('32.55',to_date('18.12.15','RR.MM.DD'),'97','37');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('28.27',to_date('23.12.22','RR.MM.DD'),'100','159');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('67.61',to_date('20.09.17','RR.MM.DD'),'100','191');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('114.62',to_date('19.08.05','RR.MM.DD'),'43','152');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('101.3',to_date('19.09.19','RR.MM.DD'),'46','184');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('186.85',to_date('23.08.02','RR.MM.DD'),'49','141');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('143.88',to_date('23.09.09','RR.MM.DD'),'70','132');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('100.64',to_date('19.05.06','RR.MM.DD'),'73','165');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('64.6',to_date('21.05.04','RR.MM.DD'),'76','42');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('175.2',to_date('20.10.20','RR.MM.DD'),'97','52');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('27.29',to_date('19.08.23','RR.MM.DD'),'100','100');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('29.89',to_date('23.01.16','RR.MM.DD'),'43','134');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('143.79',to_date('23.08.02','RR.MM.DD'),'46','141');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('88.82',to_date('23.06.01','RR.MM.DD'),'49','123');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('195.1',to_date('22.10.21','RR.MM.DD'),'70','97');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('40.38',to_date('19.09.19','RR.MM.DD'),'73','184');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('128.04',to_date('23.12.01','RR.MM.DD'),'76','64');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('193.01',to_date('19.10.13','RR.MM.DD'),'97','75');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('121.05',to_date('21.08.11','RR.MM.DD'),'100','36');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('32.61',to_date('23.12.27','RR.MM.DD'),'43','53');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('97.93',to_date('20.03.03','RR.MM.DD'),'46','104');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('30.91',to_date('19.01.25','RR.MM.DD'),'49','143');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('121.78',to_date('23.09.09','RR.MM.DD'),'70','132');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('197.57',to_date('23.08.12','RR.MM.DD'),'73','82');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('148.52',to_date('23.10.03','RR.MM.DD'),'76','91');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('37.73',to_date('23.01.16','RR.MM.DD'),'97','134');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('53.52',to_date('19.08.23','RR.MM.DD'),'100','100');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('193.6',to_date('19.10.31','RR.MM.DD'),'100','178');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('50.63',to_date('22.12.12','RR.MM.DD'),'43','60');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('181.72',to_date('19.11.14','RR.MM.DD'),'46','69');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('53.16',to_date('21.07.14','RR.MM.DD'),'49','48');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('157.04',to_date('23.09.21','RR.MM.DD'),'70','13');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('156.56',to_date('23.07.27','RR.MM.DD'),'43','30');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('97.5',to_date('21.06.09','RR.MM.DD'),'46','33');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('85.73',to_date('23.08.16','RR.MM.DD'),'49','103');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('38.68',to_date('23.02.05','RR.MM.DD'),'70','124');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('167.73',to_date('19.04.10','RR.MM.DD'),'73','29');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('126.05',to_date('18.09.11','RR.MM.DD'),'43','32');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('180.93',to_date('23.12.22','RR.MM.DD'),'46','159');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('123.91',to_date('23.04.19','RR.MM.DD'),'49','188');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('57.68',to_date('23.04.19','RR.MM.DD'),'70','188');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('115.74',to_date('23.05.11','RR.MM.DD'),'73','174');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('36.98',to_date('19.09.19','RR.MM.DD'),'76','184');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('176.82',to_date('23.11.11','RR.MM.DD'),'97','88');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('169.79',to_date('22.10.21','RR.MM.DD'),'100','97');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('22.85',to_date('20.10.10','RR.MM.DD'),'49','58');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('151.88',to_date('15.12.05','RR.MM.DD'),'70','71');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('38.93',to_date('23.12.20','RR.MM.DD'),'73','46');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('36.36',to_date('23.06.15','RR.MM.DD'),'76','28');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('13.32',to_date('23.01.28','RR.MM.DD'),'43','146');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('130.59',to_date('21.03.09','RR.MM.DD'),'46','198');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('198.34',to_date('19.04.18','RR.MM.DD'),'49','2');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('166.52',to_date('20.09.16','RR.MM.DD'),'70','187');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('31.39',to_date('21.01.28','RR.MM.DD'),'73','192');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('119.32',to_date('20.03.08','RR.MM.DD'),'76','166');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('171.07',to_date('21.06.09','RR.MM.DD'),'97','33');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('55.99',to_date('23.09.02','RR.MM.DD'),'100','83');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('111.13',to_date('23.02.05','RR.MM.DD'),'70','124');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('108.23',to_date('23.09.23','RR.MM.DD'),'73','41');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('141.92',to_date('17.12.17','RR.MM.DD'),'43','50');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('168.57',to_date('21.10.23','RR.MM.DD'),'46','20');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('187.03',to_date('23.11.13','RR.MM.DD'),'49','158');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('57.68',to_date('13.12.21','RR.MM.DD'),'70','1');
Insert into LAB_SCREENING (TEST_COST,TEST_DATE,IDTECHNICIAN,EPISODE_IDEPISODE) values ('21.16',to_date('19.09.19','RR.MM.DD'),'73','184');


Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('13.11.20','RR.MM.DD'),to_date('13.12.21','RR.MM.DD'),'13:13','99','1');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('17.10.07','RR.MM.DD'),to_date('17.11.08','RR.MM.DD'),'16:47','96','59');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.10.26','RR.MM.DD'),to_date('18.11.27','RR.MM.DD'),'18:11','92','38');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.11.11','RR.MM.DD'),to_date('22.12.12','RR.MM.DD'),'16:50','89','60');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('17.11.16','RR.MM.DD'),to_date('17.12.17','RR.MM.DD'),'17:14','85','50');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.11.14','RR.MM.DD'),to_date('20.12.15','RR.MM.DD'),'19:60','83','92');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.05.19','RR.MM.DD'),to_date('22.12.20','RR.MM.DD'),'17:34','82','8');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('16.04.11','RR.MM.DD'),to_date('16.12.12','RR.MM.DD'),'14:15','71','62');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('15.04.04','RR.MM.DD'),to_date('15.12.05','RR.MM.DD'),'10:48','66','71');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('16.11.25','RR.MM.DD'),to_date('16.12.26','RR.MM.DD'),'15:34','63','68');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('15.05.01','RR.MM.DD'),to_date('15.10.02','RR.MM.DD'),'17:52','62','40');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.05.09','RR.MM.DD'),to_date('20.10.10','RR.MM.DD'),'18:46','57','58');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.05.21','RR.MM.DD'),to_date('21.10.22','RR.MM.DD'),'17:10','56','94');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.10.09','RR.MM.DD'),to_date('18.12.10','RR.MM.DD'),'19:29','34','86');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.10.26','RR.MM.DD'),to_date('23.11.27','RR.MM.DD'),'10:39','30','18');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.01.13','RR.MM.DD'),to_date('21.07.14','RR.MM.DD'),'16:32','24','48');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.10.28','RR.MM.DD'),to_date('18.11.29','RR.MM.DD'),'10:25','17','74');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.02.21','RR.MM.DD'),to_date('21.10.22','RR.MM.DD'),'8:17','15','22');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.05.16','RR.MM.DD'),to_date('23.11.17','RR.MM.DD'),'17:47','14','79');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),to_date('19.11.14','RR.MM.DD'),'14:36','13','69');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.01.09','RR.MM.DD'),to_date('20.02.10','RR.MM.DD'),'11:49','11','70');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.08.27','RR.MM.DD'),to_date('22.10.28','RR.MM.DD'),'16:15','9','21');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),to_date('23.12.01','RR.MM.DD'),'17:57','8','64');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.11.26','RR.MM.DD'),to_date('23.12.27','RR.MM.DD'),'11:15','6','53');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.19','RR.MM.DD'),to_date('18.05.20','RR.MM.DD'),'11:60','3','87');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),to_date('23.05.14','RR.MM.DD'),'10:15','2','16');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.10.28','RR.MM.DD'),to_date('23.11.29','RR.MM.DD'),'18:11','1','4');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.09.20','RR.MM.DD'),to_date('22.10.21','RR.MM.DD'),'14:47','99','97');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.09.03','RR.MM.DD'),to_date('19.10.04','RR.MM.DD'),'13:30','96','44');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.02','RR.MM.DD'),to_date('23.10.03','RR.MM.DD'),'11:28','92','91');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.08.14','RR.MM.DD'),to_date('18.12.15','RR.MM.DD'),'16:25','89','37');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.14','RR.MM.DD'),to_date('18.11.15','RR.MM.DD'),'18:25','85','39');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.05.26','RR.MM.DD'),to_date('23.06.27','RR.MM.DD'),'11:31','30','67');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.11.27','RR.MM.DD'),to_date('20.12.28','RR.MM.DD'),'14:17','24','10');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.10.10','RR.MM.DD'),to_date('23.11.11','RR.MM.DD'),'11:10','19','88');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.12','RR.MM.DD'),to_date('18.08.13','RR.MM.DD'),'11:47','17','65');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.02.22','RR.MM.DD'),to_date('19.08.23','RR.MM.DD'),'17:27','15','100');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.05.22','RR.MM.DD'),to_date('19.12.23','RR.MM.DD'),'9:46','14','7');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.09.22','RR.MM.DD'),to_date('21.10.23','RR.MM.DD'),'16:18','13','20');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.03.11','RR.MM.DD'),to_date('21.05.12','RR.MM.DD'),'16:44','11','47');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.15','RR.MM.DD'),to_date('23.10.16','RR.MM.DD'),'19:30','30','35');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.07.10','RR.MM.DD'),to_date('21.08.11','RR.MM.DD'),'18:40','24','36');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.27','RR.MM.DD'),to_date('23.10.28','RR.MM.DD'),'15:57','19','90');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.08.10','RR.MM.DD'),to_date('18.09.11','RR.MM.DD'),'10:45','17','32');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.08.22','RR.MM.DD'),to_date('23.09.23','RR.MM.DD'),'10:25','30','41');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.04.22','RR.MM.DD'),to_date('21.05.23','RR.MM.DD'),'11:45','15','45');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.09.21','RR.MM.DD'),to_date('21.10.22','RR.MM.DD'),'10:15','15','23');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.04.26','RR.MM.DD'),to_date('20.05.27','RR.MM.DD'),'11:34','15','12');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.09.19','RR.MM.DD'),to_date('20.10.20','RR.MM.DD'),'15:27','15','52');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.01.10','RR.MM.DD'),to_date('23.11.13','RR.MM.DD'),'14:00','99','118');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.19','RR.MM.DD'),to_date('23.07.23','RR.MM.DD'),'15:00','96','24');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.11.26','RR.MM.DD'),to_date('23.10.15','RR.MM.DD'),'16:00','92','49');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.06.01','RR.MM.DD'),to_date('23.04.25','RR.MM.DD'),'10:00','89','148');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.08.27','RR.MM.DD'),to_date('23.05.24','RR.MM.DD'),'11:00','85','15');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.01.09','RR.MM.DD'),to_date('23.03.20','RR.MM.DD'),'11:15','83','80');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.03.11','RR.MM.DD'),to_date('23.02.23','RR.MM.DD'),'11:30','82','19');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.09.22','RR.MM.DD'),to_date('23.11.13','RR.MM.DD'),'11:30','71','158');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.10.13','RR.MM.DD'),to_date('23.11.16','RR.MM.DD'),'11:30','66','196');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.05.16','RR.MM.DD'),to_date('23.09.24','RR.MM.DD'),'11:30','99','157');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.05.22','RR.MM.DD'),to_date('23.09.02','RR.MM.DD'),'11:30','96','83');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.04.26','RR.MM.DD'),to_date('23.08.25','RR.MM.DD'),'11:30','92','162');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.09.19','RR.MM.DD'),to_date('23.05.15','RR.MM.DD'),'11:30','89','114');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.09.21','RR.MM.DD'),to_date('23.09.23','RR.MM.DD'),'11:15','85','26');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.04.22','RR.MM.DD'),to_date('23.02.22','RR.MM.DD'),'11:15','83','130');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.02.22','RR.MM.DD'),to_date('23.02.07','RR.MM.DD'),'11:15','82','98');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.02.21','RR.MM.DD'),to_date('23.06.01','RR.MM.DD'),'11:15','71','123');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.12','RR.MM.DD'),to_date('23.07.06','RR.MM.DD'),'16:00','66','51');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.08.10','RR.MM.DD'),to_date('23.09.09','RR.MM.DD'),'16:00','99','132');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.10.28','RR.MM.DD'),to_date('23.12.22','RR.MM.DD'),'16:00','96','159');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.10.10','RR.MM.DD'),to_date('23.06.01','RR.MM.DD'),'16:00','92','151');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.07.26','RR.MM.DD'),to_date('23.01.16','RR.MM.DD'),'16:00','89','134');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.27','RR.MM.DD'),to_date('23.09.13','RR.MM.DD'),'16:00','85','61');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.01.13','RR.MM.DD'),to_date('23.09.21','RR.MM.DD'),'14:00','83','13');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.07.10','RR.MM.DD'),to_date('23.02.04','RR.MM.DD'),'14:00','82','108');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.11.27','RR.MM.DD'),to_date('23.07.14','RR.MM.DD'),'14:00','71','106');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.05.26','RR.MM.DD'),to_date('23.10.24','RR.MM.DD'),'14:00','66','154');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.10.26','RR.MM.DD'),to_date('23.07.27','RR.MM.DD'),'14:00','99','30');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.08.22','RR.MM.DD'),to_date('23.06.08','RR.MM.DD'),'14:00','96','180');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.15','RR.MM.DD'),to_date('23.04.09','RR.MM.DD'),'13:30','92','163');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.10.09','RR.MM.DD'),to_date('23.02.16','RR.MM.DD'),'13:30','89','34');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('21.05.21','RR.MM.DD'),to_date('23.08.02','RR.MM.DD'),'13:30','85','141');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.05.09','RR.MM.DD'),to_date('23.12.15','RR.MM.DD'),'13:30','83','110');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('15.05.01','RR.MM.DD'),to_date('23.07.23','RR.MM.DD'),'13:30','82','121');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('16.11.25','RR.MM.DD'),to_date('23.08.16','RR.MM.DD'),'17:34','71','103');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('15.04.04','RR.MM.DD'),to_date('23.03.10','RR.MM.DD'),'17:34','66','77');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('16.04.11','RR.MM.DD'),to_date('23.10.09','RR.MM.DD'),'17:34','63','81');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.05.19','RR.MM.DD'),to_date('23.08.16','RR.MM.DD'),'17:34','62','200');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('20.11.14','RR.MM.DD'),to_date('23.05.04','RR.MM.DD'),'16:50','57','190');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.02.14','RR.MM.DD'),to_date('23.02.04','RR.MM.DD'),'16:50','56','149');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('17.11.16','RR.MM.DD'),to_date('23.08.12','RR.MM.DD'),'16:50','34','155');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('18.08.14','RR.MM.DD'),to_date('23.05.19','RR.MM.DD'),'16:50','30','176');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.11.11','RR.MM.DD'),to_date('23.02.11','RR.MM.DD'),'17:10','24','144');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.05.26','RR.MM.DD'),to_date('23.06.04','RR.MM.DD'),'17:10','19','128');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('23.09.02','RR.MM.DD'),to_date('23.04.19','RR.MM.DD'),'17:10','17','188');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('17.10.07','RR.MM.DD'),to_date('23.10.24','RR.MM.DD'),'17:10','15','160');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('19.09.03','RR.MM.DD'),to_date('23.05.11','RR.MM.DD'),'17:10','14','174');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('22.09.20','RR.MM.DD'),to_date('23.02.08','RR.MM.DD'),'11:10','13','17');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('13.11.20','RR.MM.DD'),to_date('23.02.05','RR.MM.DD'),'11:10','11','124');
Insert into APPOINTMENT (SCHEDULED_ON,APPOINTMENT_DATE,APPOINTMENT_TIME,IDDOCTOR,IDEPISODE) values (to_date('13.11.20','RR.MM.DD'),to_date('23.10.01','RR.MM.DD'),'11:10','9','43');

Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.04.17','RR.MM.DD'),to_date('19.04.18','RR.MM.DD'),'1','2','4');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.08.26','RR.MM.DD'),to_date('20.09.15','RR.MM.DD'),'2','3','5');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.01.18','RR.MM.DD'),to_date('22.01.23','RR.MM.DD'),'3','5','7');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.10.16','RR.MM.DD'),to_date('21.10.29','RR.MM.DD'),'4','6','10');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.03.09','RR.MM.DD'),to_date('23.03.18','RR.MM.DD'),'5','9','12');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.04.11','RR.MM.DD'),to_date('20.04.23','RR.MM.DD'),'6','11','16');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.04.14','RR.MM.DD'),to_date('20.04.21','RR.MM.DD'),'7','14','18');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.04.10','RR.MM.DD'),to_date('21.04.18','RR.MM.DD'),'8','25','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.08.19','RR.MM.DD'),to_date('20.09.06','RR.MM.DD'),'9','27','21');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.06.04','RR.MM.DD'),to_date('23.06.18','RR.MM.DD'),'10','28','22');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.04.09','RR.MM.DD'),to_date('19.04.10','RR.MM.DD'),'11','29','23');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.06.01','RR.MM.DD'),to_date('19.06.08','RR.MM.DD'),'12','31','25');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.06.08','RR.MM.DD'),to_date('21.06.19','RR.MM.DD'),'13','33','26');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.05.02','RR.MM.DD'),to_date('21.05.11','RR.MM.DD'),'14','42','27');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.12.20','RR.MM.DD'),null,'15','46','28');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.01.05','RR.MM.DD'),to_date('20.01.30','RR.MM.DD'),'16','54','29');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.03.12','RR.MM.DD'),to_date('23.03.25','RR.MM.DD'),'17','55','31');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.04.20','RR.MM.DD'),to_date('23.04.22','RR.MM.DD'),'18','56','32');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.12.02','RR.MM.DD'),to_date('20.12.17','RR.MM.DD'),'19','57','33');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.09.14','RR.MM.DD'),to_date('21.09.29','RR.MM.DD'),'20','63','35');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.06.21','RR.MM.DD'),to_date('21.07.17','RR.MM.DD'),'21','66','36');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.11.07','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'22','72','37');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.01.22','RR.MM.DD'),to_date('21.02.02','RR.MM.DD'),'23','73','38');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.10.06','RR.MM.DD'),to_date('19.10.18','RR.MM.DD'),'24','75','39');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.03.09','RR.MM.DD'),to_date('20.04.03','RR.MM.DD'),'25','76','40');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.03.26','RR.MM.DD'),to_date('23.03.31','RR.MM.DD'),'26','78','41');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.08.12','RR.MM.DD'),to_date('23.08.20','RR.MM.DD'),'27','82','42');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.02.02','RR.MM.DD'),to_date('22.03.01','RR.MM.DD'),'28','84','44');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.07.12','RR.MM.DD'),to_date('21.07.31','RR.MM.DD'),'29','85','45');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.10.11','RR.MM.DD'),null,'30','89','47');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.01.28','RR.MM.DD'),to_date('22.02.20','RR.MM.DD'),'31','93','48');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.09.22','RR.MM.DD'),to_date('22.09.30','RR.MM.DD'),'32','95','50');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.05.27','RR.MM.DD'),to_date('23.06.11','RR.MM.DD'),'33','96','51');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.07.16','RR.MM.DD'),to_date('23.08.08','RR.MM.DD'),'34','99','52');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.09.09','RR.MM.DD'),to_date('22.09.11','RR.MM.DD'),'35','101','53');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.05.23','RR.MM.DD'),to_date('20.06.20','RR.MM.DD'),'36','102','54');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.02.28','RR.MM.DD'),to_date('20.03.06','RR.MM.DD'),'37','104','55');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.12.27','RR.MM.DD'),to_date('20.01.01','RR.MM.DD'),'38','105','58');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.04.21','RR.MM.DD'),to_date('19.05.05','RR.MM.DD'),'39','107','59');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.05.09','RR.MM.DD'),to_date('21.05.17','RR.MM.DD'),'40','109','60');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.06.21','RR.MM.DD'),to_date('21.07.19','RR.MM.DD'),'41','111','61');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.08.11','RR.MM.DD'),to_date('22.08.19','RR.MM.DD'),'42','112','64');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.03.06','RR.MM.DD'),to_date('21.03.18','RR.MM.DD'),'43','113','65');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.05.17','RR.MM.DD'),to_date('22.06.11','RR.MM.DD'),'44','115','67');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.02.26','RR.MM.DD'),to_date('22.03.02','RR.MM.DD'),'45','116','68');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.10.09','RR.MM.DD'),to_date('21.11.07','RR.MM.DD'),'46','117','69');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.06.09','RR.MM.DD'),to_date('21.06.19','RR.MM.DD'),'47','119','72');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.03.09','RR.MM.DD'),to_date('20.03.19','RR.MM.DD'),'48','120','74');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.06.15','RR.MM.DD'),to_date('22.06.20','RR.MM.DD'),'49','122','75');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.01.24','RR.MM.DD'),to_date('19.02.15','RR.MM.DD'),'50','125','77');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.07.16','RR.MM.DD'),to_date('21.08.07','RR.MM.DD'),'44','126','78');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.06.24','RR.MM.DD'),to_date('20.07.21','RR.MM.DD'),'45','127','79');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.04.04','RR.MM.DD'),to_date('21.04.11','RR.MM.DD'),'46','129','80');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.07.11','RR.MM.DD'),to_date('23.07.31','RR.MM.DD'),'47','131','81');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.09.13','RR.MM.DD'),to_date('21.10.01','RR.MM.DD'),'48','133','84');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.07.10','RR.MM.DD'),to_date('22.08.05','RR.MM.DD'),'49','135','86');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.12.22','RR.MM.DD'),to_date('23.01.15','RR.MM.DD'),'50','136','87');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.12.14','RR.MM.DD'),to_date('22.12.27','RR.MM.DD'),'35','137','88');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.08.17','RR.MM.DD'),to_date('20.08.27','RR.MM.DD'),'36','138','90');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.05.24','RR.MM.DD'),to_date('21.06.20','RR.MM.DD'),'37','139','91');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.10.04','RR.MM.DD'),to_date('20.10.22','RR.MM.DD'),'38','140','93');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.10.15','RR.MM.DD'),to_date('20.11.13','RR.MM.DD'),'39','142','94');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.01.17','RR.MM.DD'),to_date('19.02.02','RR.MM.DD'),'40','143','95');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.04.22','RR.MM.DD'),to_date('20.04.26','RR.MM.DD'),'37','145','98');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.01.23','RR.MM.DD'),to_date('23.01.31','RR.MM.DD'),'38','146','75');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.05.12','RR.MM.DD'),to_date('20.05.15','RR.MM.DD'),'39','147','77');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.01.08','RR.MM.DD'),to_date('21.01.13','RR.MM.DD'),'40','150','78');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.07.23','RR.MM.DD'),to_date('19.08.10','RR.MM.DD'),'41','152','79');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.07.22','RR.MM.DD'),to_date('21.08.04','RR.MM.DD'),'42','153','80');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.12.17','RR.MM.DD'),to_date('23.01.07','RR.MM.DD'),'37','156','93');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.11.20','RR.MM.DD'),to_date('22.11.23','RR.MM.DD'),'38','161','94');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.06.19','RR.MM.DD'),to_date('19.06.30','RR.MM.DD'),'39','164','95');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.05.04','RR.MM.DD'),to_date('19.05.13','RR.MM.DD'),'40','165','95');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.02.14','RR.MM.DD'),to_date('20.03.11','RR.MM.DD'),'41','166','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.04.16','RR.MM.DD'),to_date('20.04.26','RR.MM.DD'),'42','167','21');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.02.04','RR.MM.DD'),to_date('19.03.05','RR.MM.DD'),'8','168','22');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.02.04','RR.MM.DD'),to_date('19.02.21','RR.MM.DD'),'9','169','23');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.06.22','RR.MM.DD'),to_date('19.07.13','RR.MM.DD'),'10','170','25');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.11.18','RR.MM.DD'),to_date('21.12.10','RR.MM.DD'),'37','171','26');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.01.05','RR.MM.DD'),to_date('20.01.06','RR.MM.DD'),'38','172','18');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.09.25','RR.MM.DD'),to_date('21.10.22','RR.MM.DD'),'39','173','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.11.03','RR.MM.DD'),to_date('20.11.04','RR.MM.DD'),'40','175','21');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.04.01','RR.MM.DD'),to_date('19.04.25','RR.MM.DD'),'41','177','22');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.10.21','RR.MM.DD'),to_date('19.11.16','RR.MM.DD'),'42','178','23');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('22.02.01','RR.MM.DD'),to_date('22.02.27','RR.MM.DD'),'6','179','25');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.05.04','RR.MM.DD'),to_date('20.05.15','RR.MM.DD'),'6','181','26');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.01.06','RR.MM.DD'),to_date('19.01.11','RR.MM.DD'),'7','182','48');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.01.03','RR.MM.DD'),to_date('19.01.13','RR.MM.DD'),'8','183','50');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.09.18','RR.MM.DD'),to_date('19.09.25','RR.MM.DD'),'9','184','51');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.10.28','RR.MM.DD'),to_date('20.11.09','RR.MM.DD'),'10','185','52');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.05.27','RR.MM.DD'),to_date('21.06.22','RR.MM.DD'),'37','186','53');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.09.03','RR.MM.DD'),to_date('20.09.27','RR.MM.DD'),'38','187','5');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.05.01','RR.MM.DD'),to_date('20.05.05','RR.MM.DD'),'39','189','7');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.09.13','RR.MM.DD'),to_date('20.10.12','RR.MM.DD'),'40','191','10');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.01.26','RR.MM.DD'),to_date('21.02.06','RR.MM.DD'),'41','192','12');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('19.10.24','RR.MM.DD'),to_date('19.10.31','RR.MM.DD'),'42','193','16');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.10.11','RR.MM.DD'),to_date('21.10.22','RR.MM.DD'),'37','194','18');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('20.01.22','RR.MM.DD'),to_date('20.02.07','RR.MM.DD'),'38','195','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('23.11.28','RR.MM.DD'),to_date('23.12.11','RR.MM.DD'),'39','197','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.03.07','RR.MM.DD'),to_date('21.03.23','RR.MM.DD'),'40','198','20');
Insert into HOSPITALIZATION (ADMISSION_DATE,DISCHARGE_DATE,ROOM_IDROOM,IDEPISODE,RESPONSIBLE_NURSE) values (to_date('21.03.07','RR.MM.DD'),to_date('21.03.28','RR.MM.DD'),'41','199','20');


Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('150','0','3505','3655','3','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('250','0','7100','7350','5','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('80','0','4490','4570','6','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('200','0','7645','7845','9','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('300','0','6030','6330','11','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('70','0','1910','1980','14','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('180','0','370','550','25','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('500','0','7870','8370','27','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('400','36.36','13060','13496.36','28','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('120','167.73','9805','10092.73','29','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('180','0','160','340','31','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('280','268.57','10795','11343.57','33','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('90','64.6','7450','7604.6','42','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('320','0','2880','3200','54','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('80','0','7500','7580','55','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('200','0','1780','1980','56','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('550','182.17','7670','8402.17','57','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('420','0','1300','1720','63','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('100','0','160','260','66','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('150','110.42','1460','1720.42','72','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('250','0','840','1090','73','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('80','193.01','10585','10858.01','75','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('200','0','8465','8665','76','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('300','0','770','1070','78','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('70','197.57','7155','7422.57','82','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('180','0','510','690','84','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('500','0','590','1090','85','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('120','149.27','8860','9129.27','93','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('180','171.11','5535','5886.11','95','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('280','0','2970','3250','96','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('90','0','1545','1635','99','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('220','0','8600','8820','101','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('320','43.35','6870','7233.35','102','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('80','97.93','2550','2727.93','104','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('200','180.88','8275','8655.88','105','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('550','0','60','610','107','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('420','0','6005','6425','109','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('100','0','4600','4700','111','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('150','0','2200','2350','112','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('250','0','3110','3360','113','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('80','189.58','11090','11359.58','115','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('200','0','1225','1425','116','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('300','0','8975','9275','117','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('70','0','510','580','119','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('180','134.49','4210','4524.49','120','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('500','90.97','3530','4120.97','122','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('400','0','2730','3130','125','PENDING');
Insert into BILL (ROOM_COST,TEST_COST,OTHER_CHARGES,TOTAL,IDEPISODE,PAYMENT_STATUS) values ('100','198.34','9905','10203.34','2','PENDING');


