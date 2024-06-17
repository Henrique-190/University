import traceback
import oracledb 
import pymongo
import json
from collections import defaultdict
import datetime as dt


# NOTA: MUDAR OS DADOS DE CONEXÃO 
oracledb_user = "hospital"
oracledb_pw = "hospital"
oracledb_dsn = "localhost:1521/xe"

mongodb_url = "mongodb://localhost:27017/"
mongo_port = 27017

"""
FUNÇÕES DE CONEXAO
"""
def connSetup():
    try:
        print("Oracle Connection")
        oracleConn = oracledb.connect(user=oracledb_user, password=oracledb_pw,
                                  dsn=oracledb_dsn)
        oracleCursor = oracleConn.cursor()
        
        print("Mongo Connection") 
        mongo_client = pymongo.MongoClient(mongodb_url,mongo_port)
        mongo_db = mongo_client["hospital"]
        return mongo_db, oracleCursor
    except Exception as e:
        print("Erro na conexão: ", e)
        exit(1)

        
"""
FUNÇÕES AUXILIARES
"""
def remove_empty_arrays(doc: dict) -> dict:
    keys_to_remove = [key for key in doc.keys() if doc[key] == [] or doc[key] == [{}]]
    for key in keys_to_remove:
        del doc[key]
    return doc

def process_date(date):
    return date.strftime("%Y-%m-%d") if date else None


"""
FUNÇÕES DE INSERÇÃO DE DADOS
"""
# Primeira Coleção - Vista de Todos os Dados dos Pacientes
# Utilizado por pacientes(ex: prefil numa aplicação)
def get_patients(cursor,mongo_client):
    patients = []
    try:
        cursor.execute("SELECT * \
                        FROM patient LEFT JOIN medical_history \
                        ON patient.idpatient = medical_history.idpatient")
        
        rows = cursor.fetchall()
        patients_data = {} # defaultdict(dict)
        
        for row in rows:
            patient_key = row[:9]
            if patient_key not in patients_data:
                patients_data[patient_key] = {}
            medical_history = {"condition": row[10], "diagnosis_date": process_date(row[11])}
            # print(medical_history)
            if "history" not in patients_data[patient_key]:
                patients_data[patient_key]["history"] = {}
            patients_data[patient_key]["history"][str(row[9])] = medical_history     
        
        patients = []
        # PACIENTES - DADOS PESSOAIS + HISTORICO
        for patient_key, history_list in patients_data.items():
            id_patient, fname, lname, blood_type, phone, email, gender, policy, birthday = patient_key
            document = {
                "id": id_patient,
                "name": f"{fname} {lname}",
                "blood_type": blood_type,
                "phone": phone,
                "email": email,
                "gender": gender,
                "policy": policy,
                "birthday": process_date(birthday),
                "history": history_list["history"],
                "emergency_contact" : [],
                # "insurance" : ""
                
            }   
            if "None" in document["history"].keys():
                del document["history"]
            else:
                print(document["history"])
            patients.append(document)
            
            
        # ADICIONAR SEGURO
        cursor.execute("SELECT * FROM INSURANCE")
        insurances = cursor.fetchall()
        for insurance in insurances:
            ins_policy_num = insurance[0]
            provider = insurance[1]
            ins_plan = insurance[2]
            ins_coPay = insurance[3]
            ins_coverage = insurance[4]
            ins_maternity = insurance[5]
            ins_dental = insurance[6]
            ins_optical = insurance[7]
        
            for doc in patients:
                if doc["policy"] == ins_policy_num:
                    doc["insurance"] = {"provider": provider, "plan": ins_plan, "coPay": ins_coPay, "coverage": ins_coverage, "maternity": ins_maternity, "dental": ins_dental, "optical": ins_optical}
                    
        # ADICIONAR CONTACTOS DE EMERGENCIA
        cursor.execute("SELECT * FROM emergency_contact")
        emer_contacts = cursor.fetchall()
        for contact in emer_contacts:
            em_patient_id = contact[3]
            contact_name = contact[0]
            em_phone = contact[1]
            em_relation = contact[2]
            
            for doc in patients:
                if doc["id"] == em_patient_id:
                    doc["emergency_contact"].append({"name": contact_name, "phone": em_phone, "relation": em_relation})
        # INSERIR NA COLEÇÃO
        
        for doc in patients:
            if doc["emergency_contact"] == []: 
                del doc["emergency_contact"]
        
        patients_collection = mongo_client["patients"]
        for i in range(0, 10):
            print(patients[i])
        patients_collection.insert_many(patients)    
        
        #for doc in patients:
            #print(json.dumps(doc, indent=4))
        print(f"Inseridos {patients_collection.count_documents({})} pacientes.")
            
        
    except Exception as e:
        tb = traceback.format_exc()
        print("Erro na operação: ", e)
        print("Traceback:", tb)
        exit(1)

# Segunda Coleção - Vista de Todos os Dados dos Funcionários
# Utilizado por Funcionários Presentes no Hospital
def get_staff(cursor,mongo_client):
    staff = []
    try:
        cursor.execute("SELECT * FROM DOCTOR")
        doctors = cursor.fetchall()
        
        cursor.execute("SELECT * FROM NURSE")
        nurses = cursor.fetchall() # OTHERS -> NURSES + TECHNICIANS
        
        cursor.execute("SELECT * FROM TECHNICIAN")
        techs = cursor.fetchall()
        
        cursor.execute("SELECT * FROM DEPARTMENT")
        departments = cursor.fetchall()
        
        cursor.execute("SELECT * FROM STAFF")
        staff = cursor.fetchall()
        
        staff_data = []
        
        for member in staff:
            doc = {
                "id": member[0],
                "first_name": member[1],
                "last_name": member[2],
                "join_date": member[3],
                "is_active": member[9],
                "email": member[5],
                # "ssn" : member[7], SSN não é necessário
            }
            dep = member[8]
            
            for doctor in doctors:
                if doctor[0] == member[0]:
                    doc["role"] = "doctor"
                    doc["qualifications"] = doctor[1] 
                    
            for nurse in nurses:
                if nurse[0] == member[0]:
                    doc["role"] = "nurse"
            for tech in techs:
                if tech[0] == member[0]:
                    doc["role"] = "technician"
            
            for department in departments:
                if dep == department[0]:
                    doc["department"] = department[2]
            
            staff_data.append(doc)
            print(doc)
        
        staff_collection = mongo_client["staff"]
        staff_collection.insert_many(staff_data)
        print("Inseridos", len(staff_data), "funcionários.")        
            
    except Exception as e:
        tb = traceback.format_exc()
        print("Erro na operação: ", e)
        print("Traceback:", tb)
        exit(1)

# Terceira Coleção - Vista de Todos os Dados das Consultas + Receitas
def get_full_episodes(cursor, mongo_client):
    try:
        episode_data = []
        
        cursor.execute("SELECT * FROM EPISODE")
        episodes = cursor.fetchall()
        
        cursor.execute("SELECT * FROM PRESCRIPTION")
        prescriptions = cursor.fetchall()
        
        cursor.execute("SELECT * FROM BILL")
        bills = cursor.fetchall()
        
        # Medicamentos ficam noutra colecao
        cursor.execute("SELECT * FROM MEDICINE")
        medicines = cursor.fetchall()
        
        cursor.execute("SELECT * FROM HOSPITALIZATION")
        hospitalizations = cursor.fetchall()
        
        # Quartos ficam noutra colecao
        cursor.execute("SELECT * FROM ROOM")
        rooms = cursor.fetchall()

        cursor.execute("SELECT * FROM APPOINTMENT")
        appointments = cursor.fetchall()
        
        cursor.execute("SELECT * FROM LAB_SCREENING")
        lab_screenings = cursor.fetchall()
        
        for episode in episodes:
            doc = {
                "id": episode[0],
                "patient_id": episode[1],
                "prescriptions": [],
                "appointments": [],
                "lab_screenings": [],
                "hospitalizations": [],
                "bills": []
            }
            
            for appointment in appointments:
                if appointment[4] == episode[0]:
                    doc["appointments"].append({"doctor": appointment[3], "appointment_date": appointment[1], "appointment_time": appointment[2]})
            
            for screening in lab_screenings:    
                if screening[4] == episode[0]:
                    doc["lab_screenings"].append({"technician": screening[3], "test_date": screening[2], "test_cost": screening[1]})
            
            for prescription in prescriptions:
                if prescription[4] == episode[0]:
                    doc["prescriptions"].append({"prescription_id": prescription[0], "medicine_id": prescription[3], "prescription_date": prescription[1], "dosage": prescription[2]})
            
            for hospitalization in hospitalizations:
                if hospitalization[3] == episode[0]:
                    if hospitalization[1]:
                        doc["hospitalizations"].append({"admission_date": hospitalization[0], "discharge_date": hospitalization[1], "room_id" : hospitalization[2], "nurse_id": hospitalization[4] })
                    else:
                        doc["hospitalizations"].append({"admission_date": hospitalization[0], "room_id": hospitalization[2], "nurse_id": hospitalization[4]})
            
            for bill in bills:
                if bill[5] == episode[0]:
                    billing_doc = {"bil_id": bill[0], "register_date": bill[6]}
                    if bill[1]:
                        billing_doc["room_cost"] = bill[1]
                    if bill[2]:
                        billing_doc["test_cost"] = bill[2]
                    if bill[3]:
                        billing_doc["others_cost"] = bill[3]
                    if bill[4]:
                        billing_doc["total_cost"] = bill[4]
                    if bill[7]:
                        billing_doc["status"] = bill[7]
                    doc["bills"].append(billing_doc)
            
            doc = remove_empty_arrays(doc)
            episode_data.append(doc)
            
        # TESTAR
        for episode in episode_data:
            print(episode)
            print("\n")
        
        episode_collection = mongo_client["episodes"]
        episode_collection.insert_many(episode_data)
        print("Inseridos", len(episode_data), "episódios.")        
        
    except Exception as e:
        tb = traceback.format_exc()
        print("Erro na operação: ", e)
        print("Traceback:", tb)
        exit(1)


# Quarta Coleção - Vista dos Exames

# X Coleção - Medicamentos
def get_medicines(cursor, mongo_client):
    try:
        cursor.execute("SELECT IDMEDICINE, M_NAME, M_QUANTITY, M_COST FROM MEDICINE")
        medicines = cursor.fetchall()
        
        medicine_documents = []
        for medicine in medicines:
            id_medicine, name, quantity, cost = medicine
            document = {
                "id": id_medicine,
                "name": name,
                "quantity": quantity,
                "cost": cost
            }
            medicine_documents.append(document)
        
        # Insert medicine documents into MongoDB collection
        medicine_collection = mongo_client["medicines"]
        medicine_collection.insert_many(medicine_documents)
        
        print(f"Inseridos {medicine_collection.count_documents({})} medicamentos.")
        
    except Exception as e:
        tb = traceback.format_exc()
        print("Erro na operação: ", e)
        print("Traceback:", tb)
        exit(1)

# X Coleção - Quartos
def get_rooms(cursor, mongo_client):
    try:
        cursor.execute("SELECT IDROOM, ROOM_TYPE, ROOM_COST FROM ROOM")
        rooms = cursor.fetchall()
        
        print("Fetched room data from Oracle:")
        print(rooms)
        
        room_documents = []
        for room in rooms:
            idroom, room_type, room_cost = room
            document = {
                "room_id": idroom, 
                "type": room_type,
                "cost": room_cost
            }
            room_documents.append(document)
        
        print("Generated room documents:")
        print(room_documents)
        
        # Insert room documents into MongoDB collection
        room_collection = mongo_client["rooms"]
        
        if room_documents:
            room_collection.insert_many(room_documents)
            print(f"Inseridos {len(room_documents)} quartos.")
        else:
            print("Nenhum quarto encontrado para inserção.")
        
    except Exception as e:
        tb = traceback.format_exc()
        print("Erro na operação: ", e)
        print("Traceback:", tb)
        exit(1)

if __name__ == "__main__":
    mongo_session, oracle_cursor = connSetup()
    print("Connection Successful!")
    get_patients(oracle_cursor, mongo_session)      
    get_staff(oracle_cursor, mongo_session)        # DONE
    get_full_episodes(oracle_cursor, mongo_session) 
    get_medicines(oracle_cursor, mongo_session) 
    get_rooms(oracle_cursor, mongo_session)
