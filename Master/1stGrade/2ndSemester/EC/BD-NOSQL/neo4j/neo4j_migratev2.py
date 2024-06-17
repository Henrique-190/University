import oracledb
from neo4j import GraphDatabase

URI = "bolt://localhost:7687"
AUTH = ("neo4j", "1234567890")

USER = 'hospital_user'
PASSWORD = 'hospital_pwd'
DSN = 'localhost:1521/xe'

with GraphDatabase.driver(URI, auth=AUTH) as driver:
        driver.verify_connectivity()

def room():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT idroom, room_type, room_cost FROM ROOM')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    room_id, room_type, room_cost = row
                    query = '''
                    MERGE (r:ROOM {idRoom: $roomId, roomType: $roomType, roomCost: $roomCost})
                    '''

                    neo4j_session.run(query, roomId=room_id, roomType=room_type, roomCost=room_cost)


def medicine():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT idmedicine, m_name, m_quantity, m_cost FROM MEDICINE')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    medicine_id, m_name, m_quantity, m_cost = row
                    query = '''
                    MERGE (m:MEDICINE {idMedicine: $medicineId, name: $name, quantity: $quantity, cost: $cost})
                    '''

                    neo4j_session.run(query, medicineId=medicine_id, name=m_name, quantity=m_quantity, cost=m_cost)


def insurance():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT policy_number, provider, insurance_plan, co_pay, coverage, maternity, dental, optical FROM INSURANCE')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    policy_number, provider, insurance_plan, co_pay, coverage, maternity, dental, optical = row
                    query = '''
                    MERGE (i:INSURANCE {policyNumber: $policyNumber, provider: $provider, insurancePlan: $insurancePlan, coPay: $coPay, coverage: $coverage, maternity: $maternity, dental: $dental, optical: $optical})
                    '''

                    neo4j_session.run(query, policyNumber=policy_number, provider=provider, insurancePlan=insurance_plan, coPay=co_pay, coverage=coverage, maternity=maternity, dental=dental, optical=optical)


def department():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT iddepartment, dept_head, dept_name, emp_count FROM DEPARTMENT')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    iddepartment, dept_head, dept_name, emp_count = row
                    query = '''
                    MERGE (d:DEPARTMENT {idDepartment: $idDepartment, deptHead: $deptHead, deptName: $deptName, empCount: $empCount})
                    '''

                    neo4j_session.run(query, idDepartment=iddepartment, deptHead=dept_head, deptName=dept_name, empCount=emp_count)


def patient():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT idpatient, patient_fname, patient_lname, blood_type, phone, email, gender, policy_number, birthday FROM PATIENT')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    idpatient, patient_fname, patient_lname, blood_type, phone, email, gender, policy_number, birthday = row
                    query = '''
                    MERGE (p:PERSON {idPatient: $idPatient, patientFname: $patientFname, patientLname: $patientLname, bloodType: $bloodType, phone: $phone, email: $email, gender: $gender, birthday: $birthday})
                    WITH p
                    MATCH (i:INSURANCE {policyNumber: $policyNumber})
                    MERGE (p)-[:HAS_INSURANCE]->(i)
                    '''

                    neo4j_session.run(query, idPatient=idpatient, patientFname=patient_fname, patientLname=patient_lname, bloodType=blood_type, phone=phone, email=email, gender=gender, policyNumber=policy_number, birthday=birthday)


def emergency_contact():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT contact_name, phone, relation, idpatient FROM EMERGENCY_CONTACT')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    contact_name, phone, relation, idpatient = row
                    query = '''
                    MERGE (ec:PERSON {contactName: $contactName, phone: $phone, relation: $relation})
                    WITH ec
                    MATCH (p:PERSON {idPatient: $idPatient})
                    MERGE (p)-[:HAS_EMERGENCY_CONTACT]->(ec)
                    '''

                    neo4j_session.run(query, contactName=contact_name, phone=phone, relation=relation, idPatient=idpatient)


def doctor():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT DOCTOR.emp_id, DOCTOR.qualifications, STAFF.emp_fname, STAFF.emp_lname, STAFF.date_joining, STAFF.date_seperation, STAFF.email, STAFF.address, STAFF.ssn, STAFF.iddepartment, STAFF.is_active_status FROM DOCTOR JOIN STAFF ON DOCTOR.emp_id = STAFF.emp_id') 

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    emp_id, qualifications, emp_fname, emp_lname, date_joining, date_seperation, email, address, ssn, iddepartment, is_active_status = row
                    query = '''
                    MERGE (p:PERSON {empId: $empId, empFname: $empFname, empLname: $empLname, dateJoining: $dateJoining, dateSeperation: $dateSeperation, email: $email, address: $address, ssn: $ssn, isActiveStatus: $isActiveStatus})
                    WITH p
                    MATCH (d:DEPARTMENT {idDepartment: $idDepartment})
                    MERGE (p)-[:WORKS_IN]->(d)
                    '''

                    neo4j_session.run(query, empId=emp_id, empFname=emp_fname, empLname=emp_lname, dateJoining=date_joining, dateSeperation=str(date_seperation), email=email, address=address, ssn=ssn, idDepartment=iddepartment, isActiveStatus=is_active_status)


def nurse():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT NURSE.staff_emp_id, STAFF.emp_fname, STAFF.emp_lname, STAFF.date_joining, STAFF.date_seperation, STAFF.email, STAFF.address, STAFF.ssn, STAFF.iddepartment, STAFF.is_active_status FROM NURSE JOIN STAFF ON NURSE.staff_emp_id = STAFF.emp_id')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    staff_emp_id, emp_fname, emp_lname, date_joining, date_seperation, email, address, ssn, iddepartment, is_active_status = row
                    query = '''
                    MERGE (p:PERSON {empId: $empId, empFname: $empFname, empLname: $empLname, dateJoining: $dateJoining, dateSeperation: $dateSeperation, email: $email, address: $address, ssn: $ssn, isActiveStatus: $isActiveStatus})
                    WITH p
                    MATCH (d:DEPARTMENT {idDepartment: $idDepartment})
                    MERGE (p)-[:WORKS_IN]->(d)
                    '''

                    neo4j_session.run(query, empId=staff_emp_id, empFname=emp_fname, empLname=emp_lname, dateJoining=date_joining, dateSeperation=str(date_seperation), email=email, address=address, ssn=ssn, idDepartment=iddepartment, isActiveStatus=is_active_status)


def technician():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT TECHNICIAN.staff_emp_id, STAFF.emp_fname, STAFF.emp_lname, STAFF.date_joining, STAFF.date_seperation, STAFF.email, STAFF.address, STAFF.ssn, STAFF.iddepartment, STAFF.is_active_status FROM TECHNICIAN JOIN STAFF ON TECHNICIAN.staff_emp_id = STAFF.emp_id')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    staff_emp_id, emp_fname, emp_lname, date_joining, date_seperation, email, address, ssn, iddepartment, is_active_status = row
                    query = '''
                    MERGE (p:PERSON {empId: $empId, empFname: $empFname, empLname: $empLname, dateJoining: $dateJoining, dateSeperation: $dateSeperation, email: $email, address: $address, ssn: $ssn, isActiveStatus: $isActiveStatus})
                    WITH p
                    MATCH (d:DEPARTMENT {idDepartment: $idDepartment})
                    MERGE (p)-[:WORKS_IN]->(d)
                    '''

                    neo4j_session.run(query, empId=staff_emp_id, empFname=emp_fname, empLname=emp_lname, dateJoining=date_joining, dateSeperation=str(date_seperation), email=email, address=address, ssn=ssn, idDepartment=iddepartment, isActiveStatus=is_active_status)


def hospitalization():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT HOSPITALIZATION.admission_date, HOSPITALIZATION.discharge_date, HOSPITALIZATION.room_idroom, HOSPITALIZATION.idepisode, HOSPITALIZATION.responsible_nurse, EPISODE.patient_idpatient FROM HOSPITALIZATION JOIN EPISODE ON HOSPITALIZATION.idepisode = EPISODE.idepisode')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    admission_date, discharge_date, room_idroom, idepisode, responsible_nurse, patient_idpatient = row
                    query = '''
                    MERGE (e:EPISODE {admissionDate: $admissionDate, dischargeDate: $dischargeDate, idEpisode: $idEpisode, responsibleNurse: $responsibleNurse})
                    WITH e
                    MATCH (r:ROOM {idRoom: $idRoom})
                    MATCH (n:PERSON {empId: $responsibleNurse})
                    MATCH (p:PERSON {idPatient: $idPatient})
                    MERGE (e)-[:HAS_ROOM]->(r)
                    MERGE (e)-[:RESPONSIBLE_NURSE]->(n)
                    MERGE (p)-[:HAS_EPISODE]->(e)
                    '''

                    neo4j_session.run(query, admissionDate=admission_date, dischargeDate=str(discharge_date), idRoom=room_idroom, idEpisode=idepisode, responsibleNurse=responsible_nurse, idPatient=patient_idpatient)


def appointment():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT APPOINTMENT.scheduled_on, APPOINTMENT.appointment_date, APPOINTMENT.appointment_time, APPOINTMENT.iddoctor, APPOINTMENT.idepisode, EPISODE.patient_idpatient FROM APPOINTMENT JOIN EPISODE ON APPOINTMENT.idepisode = EPISODE.idepisode')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    scheduled_on, appointment_date, appointment_time, iddoctor, idepisode, patient_idpatient = row
                    query = '''
                    MERGE (e:EPISODE {scheduledOn: $scheduledOn, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, idEpisode: $idEpisode})
                    WITH e
                    MATCH (d:PERSON {empId: $idDoctor})
                    MATCH (p:PERSON {idPatient: $idPatient})
                    MERGE (p)-[:HAS_EPISODE]->(e)
                    MERGE (e)-[:APPOINTED_DOCTOR]->(d)
                    '''

                    neo4j_session.run(query, scheduledOn=scheduled_on, appointmentDate=appointment_date, appointmentTime=appointment_time, idDoctor=iddoctor, idEpisode=idepisode, idPatient=patient_idpatient)


def lab_screenings():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT LAB_SCREENING.lab_id, LAB_SCREENING.test_cost, LAB_SCREENING.test_date, LAB_SCREENING.idtechnician, LAB_SCREENING.episode_idepisode, EPISODE.patient_idpatient FROM LAB_SCREENING JOIN EPISODE ON LAB_SCREENING.episode_idepisode = EPISODE.idepisode')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    lab_id, test_cost, test_date, idtechnician, episode_idepisode, patient_idpatient = row
                    query = '''
                    MERGE (ls: LABSCREENING{labId: $labId, testCost: $testCost, testDate: $testDate, idTechnician: $idTechnician, idEpisode: $idEpisode})
                    WITH ls
                    MERGE (e:EPISODE {idEpisode: $idEpisode})
                    WITH ls, e
                    MATCH (t:PERSON {empId: $idTechnician})
                    MATCH (p:PERSON {idPatient: $idPatient})
                    MERGE (p)-[:HAS_EPISODE]->(e)
                    MERGE (ls)-[:TESTED_BY]->(t)
                    MERGE (e)-[:HAS_LAB_SCREENING]->(ls)
                    '''

                    neo4j_session.run(query, labId=lab_id, testCost=test_cost, testDate=test_date, idTechnician=idtechnician, idEpisode=episode_idepisode, idPatient=patient_idpatient)


def bill():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT idbill, room_cost, test_cost, other_charges, total, idepisode, registered_at, payment_status FROM BILL')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    bill_id, room_cost, test_cost, other_charges, total, id_episode, registered_at, payment_status = row
                    query = '''
                    MERGE (b:BILL {idBill: $billId, roomCost: $roomCost, testCost: $testCost, otherCharges: $otherCharges, total: $total, registeredAt: $registeredAt, paymentStatus: $paymentStatus})
                    WITH b
                    MATCH (e:EPISODE {idEpisode: $idEpisode})
                    MERGE (e)-[:HAS_BILL]->(b)
                    '''

                    neo4j_session.run(query, billId=bill_id, roomCost=room_cost, testCost=test_cost, otherCharges=other_charges, total=total, idEpisode=id_episode, registeredAt=registered_at, paymentStatus=payment_status)



def prescription():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT idprescription, prescription_date, dosage, idmedicine, idepisode FROM PRESCRIPTION')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    idprescription, prescription_date, dosage, idmedicine, idepisode = row
                    query = '''
                    MERGE (p:PRESCRIPTION {idPrescription: $idPrescription, prescriptionDate: $prescriptionDate, dosage: $dosage})
                    WITH p
                    MATCH (e:EPISODE {idEpisode: $idEpisode})
                    MATCH (m:MEDICINE {idMedicine: $idMedicine})
                    MERGE (e)-[:HAS_PRESCRIPTION]->(p)
                    MERGE (p)-[:PRESCRIBED_MEDICINE]->(m)
                    '''

                    neo4j_session.run(query, idPrescription=idprescription, prescriptionDate=prescription_date, dosage=dosage, idMedicine=idmedicine, idEpisode=idepisode)



def medical_history():
    with oracledb.connect(user=USER, password=PASSWORD, dsn=DSN) as oracle_connection:
        cursor = oracle_connection.cursor()
        cursor.execute('SELECT record_id, condition, record_date, idpatient FROM MEDICAL_HISTORY')

        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            with driver.session(database='neo4j') as neo4j_session:
                for row in cursor:
                    record_id, condition, record_date, idpatient = row
                    query = '''
                    MERGE (mh:MEDICALHISTORY {recordId: $recordId, condition: $condition, recordDate: $recordDate})
                    WITH mh
                    MATCH (p:PERSON {idPatient: $idPatient})
                    MERGE (p)-[:HAS_MEDICAL_HISTORY]->(mh)
                    '''

                    neo4j_session.run(query, recordId=record_id, condition=condition, recordDate=record_date, idPatient=idpatient)

print('Migrating Rooms...')
room()
print('Migrating Medicines...')
medicine()
print('Migrating Insurances...')
insurance()
print('Migrating Departments...')
department()
print('Migrating Patients...')
patient()
print('Migrating Emergency Contacts...')
emergency_contact()
print('Migrating Doctors...')
doctor()
print('Migrating Nurses...')
nurse()
print('Migrating Technicians...')
technician()
print('Migrating Hospitalizations...')
hospitalization()
print('Migrating Appointments...')
appointment()
print('Migrating Lab Screenings...')
lab_screenings()
print('Migrating Bills...')
bill()
print('Migrating Prescriptions...')
prescription()
print('Migrating Medical Histories...')
medical_history()