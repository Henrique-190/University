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
        # Query 1: Listar os 5 médicos com mais consultas agendadas
        neo4j_session.run("""
            MATCH (d:PERSON)<-[:APPOINTED_DOCTOR]-(a:EPISODE)
            WITH d, count(a) AS appointmentCount
            ORDER BY appointmentCount DESC
            LIMIT 5
            MATCH (d)-[:WORKS_IN]->(dept:DEPARTMENT)
            RETURN d.empFname AS doctorFirstName, d.empLname AS doctorLastName, appointmentCount, dept.deptName AS department    
        """)

        # Query 2: Listar os pacientes que não possuem seguro de saúde
        neo4j_session.run("""
            MATCH (p:PERSON)
            WHERE NOT EXISTS { 
                MATCH (p)-[:HAS_INSURANCE]->(:INSURANCE)
            } AND p.idPatient IS NOT NULL
            RETURN p.idPatient AS PatientID, p.patient_fname AS FirstName, p.patient_lname AS LastName;
        """)

        # Query 3: Listar os 5 departamentos com mais médicos que estejam no ativo
        neo4j_session.run("""
            MATCH (d:DEPARTMENT)<-[:WORKS_IN]-(p:PERSON)
            WHERE p.isActiveStatus = 'Y'
            RETURN d.deptName AS department, count(p) AS activeDoctors
            ORDER BY activeDoctors DESC
            LIMIT 5
        """)

        # Query 4: Listar o seguro de saúde com mais pacientes diabéticos
        neo4j_session.run("""
            MATCH (i:INSURANCE)<-[:HAS_INSURANCE]-(p:PERSON)-[:HAS_MEDICAL_HISTORY]->(mh:MEDICAL_HISTORY)
            WHERE mh.condition = 'Diabetes' 
            RETURN i.policy_number AS PolicyNumber, i.provider AS Provider, count(p) AS PatientsCount
            ORDER BY PatientsCount DESC;
        """)

        # Query 5: Listar o teste de laboratório mais caro e o técnico que o realizou
        neo4j_session.run("""
            MATCH (ls:LABSCREENING)-[:TESTED_BY]->(t:PERSON)
            WITH t, ls, ls.testCost AS cost
            ORDER BY cost DESC
            LIMIT 1
            RETURN t.empFname AS technicianFirstName, t.empLname AS technicianLastName, cost
        """)

        # Query 6: Listar o técnico de laboratório com mais testes realizados
        neo4j_session.run("""
            MATCH (ls:LABSCREENING)-[:TESTED_BY]->(t:PERSON)
            WITH t, count(ls) AS testCount
            ORDER BY testCount DESC
            LIMIT 5
            RETURN t.empFname AS technicianFirstName, t.empLname AS technicianLastName, testCount
        """)

        # Query 7: Listar os 5 medicamentos mais prescritos
        neo4j_session.run("""
            MATCH (p:PRESCRIPTION)-[:PRESCRIBED_MEDICINE]->(m:MEDICINE)
            WITH m, count(p) AS prescriptionCount
            ORDER BY prescriptionCount DESC
            LIMIT 5
            RETURN m.name AS medicineName, prescriptionCount
        """)

        # Query 8: Listar os 5 pacientes com mais dívidas pendentes
        neo4j_session.run("""
            MATCH (p:PERSON)-[:HAS_EPISODE]->(e:EPISODE)-[:HAS_BILL]->(b:BILL)
            WHERE b.paymentStatus = 'PENDING'
            RETURN p.idPatient AS patientId, p.patientFname AS firstName, p.patientLname AS lastName, sum(b.total) AS totalDebt
            ORDER BY totalDebt DESC
            LIMIT 5
        """)

        # Query 9: Listar os 5 pacientes com mais visitas ao hospital
        neo4j_session.run("""
            MATCH (p:PERSON)-[:HAS_EPISODE]->(e:EPISODE)
            WITH p, count(e) AS visitCount
            ORDER BY visitCount DESC
            LIMIT 5
            RETURN p.idPatient AS patientId, p.patientFname AS firstName, p.patientLname AS lastName, visitCount
        """)

        # Query 10: Listar os 5 quartos com mais internamentos
        neo4j_session.run("""
            MATCH (e:EPISODE)-[:HAS_ROOM]->(r:ROOM)
            WITH r, count(e) AS hospitalizationCount
            ORDER BY hospitalizationCount DESC
            LIMIT 5
            RETURN r.idRoom AS roomId, r.roomType AS roomType, hospitalizationCount
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