from neo4j import GraphDatabase

# Neo4j connection details
URI = "bolt://localhost:7687"
AUTH = ("neo4j", "1234567890")

def get_neo4j_session():
    driver = GraphDatabase.driver(URI, auth=AUTH)
    return driver.session()
 
def execute_queries():
    neo4j_session = get_neo4j_session()

    try:
        neo4j_session.run("""
            MATCH (e:EPISODE)-[:APPOINTED_DOCTOR]->(d:PERSON)
            WITH d, count(e) AS appointmentCount
            ORDER BY appointmentCount DESC
            LIMIT 5
            MATCH (d)-[:WORKS_IN]->(dept:DEPARTMENT)
            RETURN d.empFname AS doctorFirstName, d.empLname AS doctorLastName, appointmentCount, dept.deptName AS department    
        """)

        neo4j_session.run("""
            MATCH (p:PATIENT)
            WHERE NOT EXISTS { 
                MATCH (p)-[:HAS_INSURANCE]->(:INSURANCE) 
            }
            RETURN p.idPatient AS PatientID, p.patient_fname AS FirstName, p.patient_lname AS LastName;
        """)

        neo4j_session.run("""
            MATCH (d:DEPARTMENT)<-[:WORKS_IN]-(doc:DOCTOR)
            WHERE doc.is_active_status = 'Y'
            WITH COUNT(doc) AS doctors, d 
            RETURN d.dept_name AS DepartmentName, d.idDepartment AS DepartmentID, doctors AS ActiveDoctors
            ORDER BY doctors desc;
        """)

        neo4j_session.run("""
            MATCH (i:INSURANCE)<-[:HAS_INSURANCE]-(p:PATIENT)-[:HAS_MEDICAL_HISTORY]->(mh:MEDICALHISTORY)
            WHERE mh.condition = 'Diabetes' 
            RETURN i.policy_number AS PolicyNumber, i.provider AS Provider, count(p) AS PatientsCount
            ORDER BY PatientsCount DESC;
        """)

        neo4j_session.run("""
            MATCH (t:TECHNICIAN)-[:RESPONSIBLE_FOR]->(l:LABSCREENING)
            WITH t, l
            ORDER BY l.test_cost DESC
            LIMIT 1
            RETURN t.staff_emp_id AS TechnicianID, t.emp_fname AS FirstName, t.emp_lname AS LastName, l.lab_id AS LabID, l.test_cost AS TestCost;
        """)

        neo4j_session.run("""
            MATCH (t:TECHNICIAN)-[:RESPONSIBLE_FOR]->(l:LABSCREENING)
            WITH t, count(l) AS labScreeningCount
            ORDER BY labScreeningCount DESC
            LIMIT 5
            RETURN t.staff_emp_id AS TechnicianID, t.emp_fname AS FirstName, t.emp_lname AS LastName, labScreeningCount;
        """)

        neo4j_session.run("""
            MATCH (pr:PRESCRIPTION)-[:HAS_MEDICINE]->(m:MEDICINE)
            WITH m, count(pr) AS prescriptionCount
            RETURN DISTINCT m.idMedicine AS MedicineID, m.m_name AS MedicineName, prescriptionCount
            ORDER BY prescriptionCount DESC
            LIMIT 5;
        """)

        neo4j_session.run("""
            MATCH (p:PATIENT)-[:HAS_EPISODE]->(e:EPISODE)-[:HAS_BILL]->(b:BILL)
            WHERE b.payment_status = 'PENDING'
            RETURN p.patient_fname AS PatientName, sum(b.total) AS Sum
            ORDER BY sum(b.total) DESC;
        """)

        neo4j_session.run("""
            MATCH (p:PATIENT)-[:HAS_EPISODE]->(e:EPISODE)-[:IS_APPOINTMENT]->()
            WITH p, COUNT(e) AS APPOINTMENT_COUNTER
            MATCH (p:PATIENT)-[:HAS_EPISODE]->(e:EPISODE)-[:IS_HOSPITALIZATION]->()
            WITH p, APPOINTMENT_COUNTER, COUNT(e) AS HOSPITALIZATION_COUNTER
            MATCH (p:PATIENT)-[:HAS_EPISODE]->(e:EPISODE)-[:HAS_LAB_SCREENING]->()
            WITH p, APPOINTMENT_COUNTER, HOSPITALIZATION_COUNTER, COUNT(e) AS LABSCREENING_COUNTER
            RETURN p.patient_fname AS FIRST_NAME, p.patient_lname AS LAST_NAME, (APPOINTMENT_COUNTER + HOSPITALIZATION_COUNTER + LABSCREENING_COUNTER) as TOTAL_VISITS, APPOINTMENT_COUNTER, HOSPITALIZATION_COUNTER, LABSCREENING_COUNTER
            ORDER BY TOTAL_VISITS DESC
        """)

        neo4j_session.run("""
            MATCH (r:ROOM)<-[:HAS_ROOM]-(h:HOSPITALIZATION)
            RETURN r.idRoom AS RoomID, r.room_type AS RoomType, count(h) AS hospitalizationCount
            ORDER BY count(h) DESC;
        """)


    except Exception as e:
        print(f"An error occurred while executing the query: {e}")
    finally:
        neo4j_session.close()


if __name__ == "__main__":
    try:
        with GraphDatabase.driver(URI, auth=AUTH) as driver:
            driver.verify_connectivity()
            print("Successfully connected to Neo4j.")
        execute_queries()

        driver.close()

    except Exception as e:
        print(f"An error occurred while connecting to Neo4j: {e}")