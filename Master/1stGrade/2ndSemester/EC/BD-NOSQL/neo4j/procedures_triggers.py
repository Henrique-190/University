from neo4j import GraphDatabase

URI = "bolt://localhost:7687"
AUTH = ("neo4j", "123456789")



def add_procedure():
    driver = GraphDatabase.driver(URI, auth=AUTH)

    with driver.session(database='neo4j') as neo4j_session:
        procedure = """
CALL apoc.cypher.doIt("
    MATCH (b:BILL {idBill: $billId})
    SET b.payment_status = CASE
        WHEN $paidValue < b.total THEN 'FAILURE'
        ELSE 'PROCESSED'
    END
    RETURN CASE
        WHEN $paidValue < b.total THEN 'Paid value is inferior to the total value of the bill.'
        ELSE 'Payment processed successfully.'
    END AS result
", {billId: $billId, paidValue: $paidValue}) YIELD value
RETURN value.result;
    """
        
        BILLID = 10
        PAIDVALUE = 1
        result = neo4j_session.run(procedure, billId=BILLID, paidValue=PAIDVALUE)
        print(f'Resultado da tentativa de pagamento de {PAIDVALUE} na Bill {BILLID}: {result.single()[0]}')

        PAIDVALUE = 100000000000
        result = neo4j_session.run(procedure, billId=BILLID, paidValue=PAIDVALUE)
        print(f'Resultado da tentativa de pagamento de {PAIDVALUE} na Bill {BILLID}: {result.single()[0]}')

        neo4j_session.close()

def add_emergency_contact():
    driver = GraphDatabase.driver(URI, auth=AUTH)

    with driver.session(database='neo4j') as neo4j_session:
        procedure = """
CALL apoc.cypher.doIt("
    MATCH (p:PATIENT {idPatient: $idPatient})
    CREATE (ec:EMERGENCYCONTACT {contact_name: $contact_name, phone: $phone, relation: $relation})
    MERGE (p)-[:HAS_EMERGENCY_CONTACT]->(ec)
    RETURN 'Emergency contact updated successfully.' AS result
", {idPatient: $idPatient, contact_name: $contact_name, phone: $phone, relation: $relation}) YIELD value
RETURN value.result;
        """
        
        IDPATIENT = 1
        CONTACT_NAME = 'John Doe'
        PHONE = '1234567890'
        RELATION = 'Father'
        
        result = neo4j_session.run(procedure, idPatient=IDPATIENT, contact_name=CONTACT_NAME, phone=PHONE, relation=RELATION)

        neo4j_session.close()


def add_trigger():
    # Quando diz "Failed to invoke procedure `apoc.trigger.install`: 
    # Caused by: java.lang.RuntimeException: No write operations are allowed directly on this database. 
    # Writes must pass through the leader. The role of this server is: FOLLOWER"
    # -> Em python, fazer driver.session(database="system")
    # -> No Neo4j Browser, usar :use system
    driver = GraphDatabase.driver(URI, auth=AUTH)

    with driver.session(database='system') as neo4j_session:
        trigger = """
CALL apoc.trigger.install('neo4j','trg_generate_bill', '
    MATCH (episode: EPISODE)
    MATCH (episode)-[r:HAS_BILL]->(b:BILL)
    WHERE r IS NULL
    WITH episode

    OPTIONAL MATCH (b:BILL)
    WITH episode, max(b.idBill) as maxIdBill

    OPTIONAL MATCH (episode)-[:IS_HOSPITALIZATION]->(hospitalization:HOSPITALIZATION)-[:HAS_ROOM]->(room:ROOM)
    OPTIONAL MATCH (episode)-[:HAS_LAB_SCREENING]->(lab_screening:LABSCREENING)
    OPTIONAL MATCH (episode)-[:HAS_PRESCRIPTION]->(prescription:PRESCRIPTION)

    WITH episode, COALESCE(room.room_cost, 0) AS room_cost, COALESCE(lab_screening.test_cost, 0) AS test_cost, COALESCE(maxIdBill, 0) + 1 AS maxIdBill, (COALESCE(room.room_cost, 0) + COALESCE(lab_screening.test_cost, 0)) AS total
    
    MERGE (bill:BILL {idBill: maxIdBill, idEpisode: episode.idEpisode, other_charges: 0, room_cost: room_cost, test_cost: test_cost, total: total, payment_status: "PENDING", registered_at: datetime()})
    CREATE (episode)-[:HAS_BILL]->(bill)

RETURN bill',
{phase:'after'});"""

    
        neo4j_session.run(trigger)
        print(f"Trigger 'trg_generate_bill' criado com sucesso")

        neo4j_session.close()
        

def migrate_procedure_trigger():    
    add_procedure()
    add_trigger()
    add_emergency_contact()

if __name__ == "__main__":
    with GraphDatabase.driver(URI, auth=AUTH) as driver:
        driver.verify_connectivity()
    migrate_procedure_trigger()