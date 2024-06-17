import oracledb
from neo4j import GraphDatabase

# Oracle connection details
def get_oracle_connection():
    return oracledb.connect(
user='system', password='oracle19', dsn='localhost/ORCLCDB'
    )

# Neo4J connection details
URI = "bolt://localhost:7687"
AUTH = ("neo4j", "123456789")

def get_neo4j_session():    
    driver = GraphDatabase.driver(URI, auth=AUTH)
    return driver.session()

def get_patient(oracle_cursor, neo4j_session):
    print("Creating patient...")
    
    oracle_cursor.execute('SELECT * FROM PATIENT')
    neo4j_session.run("""CREATE TEXT INDEX pat_index IF NOT EXISTS FOR (patient:PATIENT) ON (patient.idPatient);""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MERGE (patient:PATIENT {
                idPatient: $idPatient, patient_fname: $patient_fname, patient_lname: $patient_lname, blood_type: $blood_type, phone: $phone, email: $email, gender: $gender, policy_number: $policy_number, birthday: $birthday
            })
        """, idPatient=row[0], patient_fname=row[1], patient_lname=row[2], blood_type=row[3], phone=row[4], email=row[5], gender=row[6], policy_number=row[7], birthday=row[8])

    oracle_cursor.execute("""
        SELECT * FROM MEDICAL_HISTORY
        JOIN PATIENT ON PATIENT.IDPATIENT = MEDICAL_HISTORY.IDPATIENT
    """)
    neo4j_session.run("""CREATE TEXT INDEX mh_index IF NOT EXISTS FOR (medicalHistory:MEDICALHISTORY) ON (medicalHistory.record_id)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (patient:PATIENT {idPatient: $idPatient})
                          
            MERGE (medicalHistory:MEDICALHISTORY {  
                record_id: $record_id, condition: $condition, record_date: $record_date, idPatient: $idPatient
            })<-[:HAS_MEDICAL_HISTORY]-(patient)
        """, record_id=row[0], condition=row[1], record_date=row[2], idPatient=row[3])

    oracle_cursor.execute("""
        SELECT * FROM INSURANCE
        JOIN PATIENT ON PATIENT.POLICY_NUMBER = INSURANCE.POLICY_NUMBER
    """)
    neo4j_session.run("""CREATE TEXT INDEX ins_index IF NOT EXISTS FOR (insurance:INSURANCE) ON (insurance.policy_number)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (patient:PATIENT {policy_number: $policy_number})
                          
            MERGE (insurance:INSURANCE {
                 policy_number: $policy_number, provider: $provider, insurance_plan: $insurance_plan, co_pay: $co_pay, coverage: $coverage, maternity: $maternity, dental: $dental, optical: $optical
            })<-[:HAS_INSURANCE]-(patient)
        """, policy_number=row[0], provider=row[1], insurance_plan=row[2], co_pay=row[3], coverage=row[4], maternity=row[5], dental=row[6], optical=row[7])
    
    oracle_cursor.execute("""
        SELECT * FROM EMERGENCY_CONTACT
        JOIN PATIENT ON PATIENT.IDPATIENT = EMERGENCY_CONTACT.IDPATIENT
    """)
    neo4j_session.run("""CREATE FULLTEXT INDEX ec_index IF NOT EXISTS FOR (emergencyContact:EMERGENCYCONTACT) ON EACH [emergencyContact.idPatient, emergencyContact.phone]""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (patient:PATIENT {idPatient: $idPatient})
                          
            MERGE (emergencyContact:EMERGENCYCONTACT {
                contact_name: $contact_name, phone: $phone, relation: $relation, idPatient: $idPatient
            })<-[:HAS_EMERGENCY_CONTACT]-(patient)
        """, contact_name=row[0], phone=row[1], relation=row[2], idPatient=row[3])

def get_staff(oracle_cursor, neo4j_session):
    print("Creating staff...")

    oracle_cursor.execute('SELECT * FROM DEPARTMENT')
    neo4j_session.run("""CREATE TEXT INDEX dep_index IF NOT EXISTS FOR (department:DEPARTMENT) ON (department.idDepartment)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MERGE (department:DEPARTMENT {
                idDepartment: $idDepartment, dept_head: $dept_head, dept_name: $dept_name, emp_count: $emp_count
            })
        """, idDepartment=row[0], dept_head=row[1], dept_name=row[2], emp_count=row[3])

    oracle_cursor.execute("""
        SELECT 
            d.EMP_ID,
            d.QUALIFICATIONS,
            s.EMP_FNAME,
            s.EMP_LNAME,
            s.IS_ACTIVE_STATUS,
            de.IDDEPARTMENT
        FROM DOCTOR d 
        JOIN STAFF s ON s.EMP_ID = d.EMP_ID
        JOIN DEPARTMENT de ON de.IDDEPARTMENT = s.IDDEPARTMENT   
    """)
    neo4j_session.run("""CREATE TEXT INDEX doc_index IF NOT EXISTS FOR (doctor:DOCTOR) ON (doctor.emp_id)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (department:DEPARTMENT {idDepartment: $idDepartment})
            
            MERGE (doctor:DOCTOR {
                emp_id: $emp_id, qualifications: $qualifications, emp_fname: $emp_fname, emp_lname: $emp_lname, idDepartment: $idDepartment, is_active_status: $is_active_status
            })-[:WORKS_IN]->(department)
        """, emp_id=row[0], qualifications=row[1], emp_fname=row[2], emp_lname=row[3], is_active_status=row[4], idDepartment=row[5])
    
    oracle_cursor.execute("""
        SELECT
            n.STAFF_EMP_ID,
            s.EMP_FNAME,
            s.EMP_LNAME,
            s.EMAIL,
            s.IS_ACTIVE_STATUS,
            de.IDDEPARTMENT
        FROM NURSE n
        JOIN STAFF s ON s.EMP_ID = n.STAFF_EMP_ID
        JOIN DEPARTMENT de ON de.IDDEPARTMENT = s.IDDEPARTMENT
    """)
    neo4j_session.run("""CREATE TEXT INDEX nur_index IF NOT EXISTS FOR (nurse:NURSE) ON (nurse.staff_emp_id)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (department:DEPARTMENT {idDepartment: $idDepartment})
            
            MERGE (nurse:NURSE {
                staff_emp_id: $staff_emp_id, emp_fname: $emp_fname, emp_lname: $emp_lname, email: $email, idDepartment: $idDepartment, is_active_status: $is_active_status
            })-[:WORKS_IN]->(department)
        """, staff_emp_id=row[0], emp_fname=row[1], emp_lname=row[2], email=row[3], is_active_status=row[4], idDepartment=row[5])
    
    oracle_cursor.execute("""
        SELECT 
            t.STAFF_EMP_ID,
            s.EMP_FNAME,
            s.EMP_LNAME,
            s.EMAIL,
            s.IS_ACTIVE_STATUS,
            de.IDDEPARTMENT
        FROM TECHNICIAN t
        JOIN STAFF s ON s.EMP_ID = t.STAFF_EMP_ID
        JOIN DEPARTMENT de ON de.IDDEPARTMENT = s.IDDEPARTMENT
    """)
    neo4j_session.run("""CREATE TEXT INDEX tec_index IF NOT EXISTS FOR (technician:TECHNICIAN) ON (technician.staff_emp_id)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (department:DEPARTMENT {idDepartment: $idDepartment})
            
            MERGE (technician:TECHNICIAN {
                staff_emp_id: $staff_emp_id, emp_fname: $emp_fname, emp_lname: $emp_lname, email: $email, idDepartment: $idDepartment, is_active_status: $is_active_status
            })-[:WORKS_IN]->(department)
        """, staff_emp_id=row[0], emp_fname=row[1], emp_lname=row[2], email=row[3], is_active_status=row[4], idDepartment=row[5])


def get_episode(oracle_cursor, neo4j_session):
    print("Creating episode...")

    oracle_cursor.execute("SELECT * FROM EPISODE")
    neo4j_session.run("""CREATE TEXT INDEX epi_index IF NOT EXISTS FOR (episode:EPISODE) ON (episode.idEpisode)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (patient:PATIENT {idPatient: $idPatient})
            
            MERGE (episode:EPISODE {
                idEpisode: $idEpisode, idPatient: $idPatient
            })<-[:HAS_EPISODE]-(patient)
        """, idEpisode=row[0], idPatient=row[1])

    oracle_cursor.execute("""
        SELECT 
            p.IDPRESCRIPTION, 
            p.PRESCRIPTION_DATE, 
            p.DOSAGE, 
            p.IDMEDICINE,
            p.IDEPISODE
        FROM PRESCRIPTION p 
        JOIN EPISODE e ON p.IDEPISODE = e.IDEPISODE
    """)
    neo4j_session.run("""CREATE TEXT INDEX pre_index IF NOT EXISTS FOR (prescription:PRESCRIPTION) ON (prescription.idPrescription)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (episode:EPISODE {idEpisode: $idEpisode})
            
            MERGE (prescription:PRESCRIPTION {
                idPrescription: $idPrescription, prescription_date: $prescription_date, dosage: $dosage, idMedicine: $idMedicine, idEpisode: $idEpisode
            })<-[:HAS_PRESCRIPTION]-(episode)
        """, idPrescription=row[0], prescription_date=row[1], dosage=row[2], idMedicine=row[3], idEpisode=row[4])
    
    oracle_cursor.execute("""
        SELECT
            h.ADMISSION_DATE,
            h.DISCHARGE_DATE,
            h.ROOM_IDROOM,
            h.IDEPISODE,
            h.RESPONSIBLE_NURSE
        FROM HOSPITALIZATION h
        JOIN EPISODE e ON h.IDEPISODE = e.IDEPISODE
    """)
    neo4j_session.run("""CREATE TEXT INDEX hos_index IF NOT EXISTS FOR (hospitalization:HOSPITALIZATION) ON (hospitalization.idEpisode)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (episode:EPISODE {idEpisode: $idEpisode})
                          
            CREATE (hospitalization:HOSPITALIZATION {
               admission_date: $admission_date, discharge_date: $discharge_date, idRoom: $idRoom, idEpisode: $idEpisode, responsible_nurse: $responsible_nurse
            })<-[:IS_HOSPITALIZATION]-(episode)
        """, admission_date=row[0], discharge_date=row[1], idRoom=row[2], idEpisode=row[3], responsible_nurse=row[4])

    oracle_cursor.execute("""
        SELECT
            a.SCHEDULED_ON,
            a.APPOINTMENT_DATE,
            a.APPOINTMENT_TIME,
            a.IDDOCTOR,
            a.IDEPISODE
        FROM APPOINTMENT a
        JOIN EPISODE e ON a.IDEPISODE = e.IDEPISODE
    """)
    neo4j_session.run("""CREATE TEXT INDEX app_index IF NOT EXISTS FOR (appointment:APPOINTMENT) ON (appointment.idEpisode)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (episode:EPISODE {idEpisode: $idEpisode})
                          
            MERGE (appointment:APPOINTMENT {
                scheduled_on: $scheduled_on, appointment_date: $appointment_date, appointment_time: $appointment_time, idDoctor: $idDoctor, idEpisode: $idEpisode
            })<-[:IS_APPOINTMENT]-(episode)
        """, scheduled_on=row[0], appointment_date=row[1], appointment_time=row[2], idDoctor=row[3], idEpisode=row[4])

    oracle_cursor.execute("""
        SELECT
            l.LAB_ID,
            l.TEST_COST,
            l.TEST_DATE,
            l.IDTECHNICIAN,
            l.EPISODE_IDEPISODE
        FROM LAB_SCREENING l
        JOIN EPISODE e ON l.EPISODE_IDEPISODE = e.IDEPISODE
    """)
    neo4j_session.run("""CREATE TEXT INDEX lab_index IF NOT EXISTS FOR (labscreening:LABSCREENING) ON (labscreening.lab_id)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (episode:EPISODE {idEpisode: $idEpisode})
                          
            MERGE (labscreening:LABSCREENING {
                lab_id: $lab_id, test_cost: $test_cost, test_date: $test_date, idTechnician: $idTechnician, idEpisode: $idEpisode
            })<-[:HAS_LAB_SCREENING]-(episode)
        """, lab_id=row[0], test_cost=row[1], test_date=row[2], idTechnician=row[3], idEpisode=row[4])
    
    oracle_cursor.execute(""" 
        SELECT
            b.IDBILL,
            b.ROOM_COST,
            b.TEST_COST,
            b.OTHER_CHARGES,
            b.TOTAL,
            b.IDEPISODE,
            b.REGISTERED_AT,
            b.PAYMENT_STATUS
        FROM BILL b
        JOIN EPISODE e ON b.IDEPISODE = e.IDEPISODE
    """)
    neo4j_session.run("""CREATE TEXT INDEX bil_index IF NOT EXISTS FOR (bill:BILL) ON (bill.idBill)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (episode:EPISODE {idEpisode: $idEpisode})
            
            MERGE (bill:BILL {
                idBill: $idBill, room_cost: $room_cost, test_cost: $test_cost, other_charges: $other_charges, total: $total, idEpisode: $idEpisode, registered_at: $registered_at, payment_status: $payment_status
            })<-[:HAS_BILL]-(episode)
        """, idBill=row[0], room_cost=row[1], test_cost=row[2], other_charges=row[3], total=row[4], idEpisode=row[5], registered_at=row[6], payment_status=row[7])


    oracle_cursor.execute("""
        SELECT * FROM MEDICINE
        JOIN PRESCRIPTION ON PRESCRIPTION.IDMEDICINE = MEDICINE.IDMEDICINE
    """)
    neo4j_session.run("""CREATE TEXT INDEX med_index IF NOT EXISTS FOR (medicine:MEDICINE) ON (medicine.idMedicine)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (prescription:PRESCRIPTION {idMedicine: $idMedicine})              
            MERGE (medicine:MEDICINE {
                idMedicine: $idMedicine, m_name: $m_name, m_quantity: $m_quantity, m_cost: $m_cost
            })
            MERGE (medicine)<-[:HAS_MEDICINE]-(prescription)
        """, idMedicine=row[0], m_name=row[1], m_quantity=row[2], m_cost=row[3])

    
    oracle_cursor.execute("""
        SELECT * FROM ROOM
        JOIN HOSPITALIZATION ON HOSPITALIZATION.ROOM_IDROOM = ROOM.IDROOM
    """)
    neo4j_session.run("""CREATE TEXT INDEX roo_index IF NOT EXISTS FOR (room:ROOM) ON (room.idRoom)""")
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (hospitalization:HOSPITALIZATION {idRoom: $idRoom})
                          
            MERGE (room:ROOM {
                idRoom: $idRoom, room_type: $room_type, room_cost: $room_cost
            })<-[:HAS_ROOM]-(hospitalization)
           """, idRoom=row[0], room_type=row[1], room_cost=row[2])

    oracle_cursor.execute('SELECT * FROM NURSE')
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (hospitalization:HOSPITALIZATION {responsible_nurse: $responsible_nurse})
            MATCH (nurse:NURSE {staff_emp_id: $staff_emp_id})
                            
            MERGE (nurse)-[:RESPONSIBLE_FOR]->(hospitalization)
        """, staff_emp_id=row[0], responsible_nurse=row[0])
    
    oracle_cursor.execute('SELECT * FROM DOCTOR')
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (appointment:APPOINTMENT {idDoctor: $idDoctor})
            MATCH (doctor:DOCTOR {emp_id: $emp_id})

            MERGE (doctor)-[:RESPONSIBLE_FOR]->(appointment)
        """, idDoctor=row[0], emp_id=row[0])

    oracle_cursor.execute('SELECT * FROM TECHNICIAN')
    for row in oracle_cursor:
        neo4j_session.run("""
            MATCH (labscreening:LABSCREENING {idTechnician: $idTechnician})
            MATCH (technician:TECHNICIAN {staff_emp_id: $staff_emp_id})

            MERGE (technician)-[:RESPONSIBLE_FOR]->(labscreening)
        """, idTechnician=row[0], staff_emp_id=row[0])
    

def migrate_data():
    oracle_conn = get_oracle_connection()
    neo4j_session = get_neo4j_session()
    
    try:
        oracle_cursor = oracle_conn.cursor()

        get_patient(oracle_cursor, neo4j_session)
        get_staff(oracle_cursor, neo4j_session)
        get_episode(oracle_cursor, neo4j_session)
                          
    finally:
        oracle_cursor.close()
        oracle_conn.close()
        neo4j_session.close()

if __name__ == "__main__":
    # Test Neo4j connection
    with GraphDatabase.driver(URI, auth=AUTH) as driver:
        driver.verify_connectivity()
    migrate_data()