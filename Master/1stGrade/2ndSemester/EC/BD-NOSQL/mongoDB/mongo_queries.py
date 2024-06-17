import traceback
import oracledb 
import pymongo
import json
from collections import defaultdict
import datetime as dt
from pprint import pprint

def setupConnection(mongo_url="mongodb://localhost:27017/", mongo_port=27017):
    mongo_client = pymongo.MongoClient(mongo_url,mongo_port)
    mongo_port = 27017
    mongo_db = mongo_client["hospital"]
    return mongo_db


    
def medicamento_mais_comum():
    db = setupConnection()
    result = db.episodes.aggregate([
        {"$unwind": "$prescriptions"},
        {
            "$group": {
                "_id": "$prescriptions.medicine_id",
                "count": { "$sum": 1 }
            }
        },
        { "$sort": { "count": -1 } },
        { "$limit": 3 },
        {
            "$lookup": {
                "from": "medicines",
                "localField": "_id",
                "foreignField": "id",
                "as": "medicine_details"
            }
        },
        {
            "$project": {
                "_id": 0,
                "medicine_id": "$_id",
                "count": 1,
                "medicine_details": { "$arrayElemAt": ["$medicine_details", 0] }
            }
        }
    ])
    return list(result)

def room_mais_comum():
    db = setupConnection()
    result = db.episodes.aggregate([
        {"$unwind": "$hospitalizations"},
        {
            "$group": {
                "_id": "$hospitalizations.room_id",
                "count": { "$sum": 1 }
            }
        },
        {
            "$lookup": {
                "from": "rooms",
                "localField": "_id",
                "foreignField": "room_id",
                "as": "room_info"
            }
        },
        {"$unwind": "$room_info"},
        {
            "$group": {
                "_id": "$room_info.type",
                "totalCount": { "$sum": "$count" }
            }
        },
        { "$sort": { "totalCount": -1 } },
        { "$limit": 1 }
    ])
    
    result_list = list(result)
    if result_list:
        most_common_room = result_list[0]
        return most_common_room["_id"], most_common_room["totalCount"]
    else:
        return None

def pacientes_com_tipo_sangue(blood_type):
    db = setupConnection()
    result = db.patients.find({"blood_type": blood_type})
    return list(result)

def condição_mais_comum():
    db = setupConnection()
    pipeline = [
        {
            "$match": {
                "history": { "$type": "object" }
            }
        },
        {
            "$project": {
                "history": { "$objectToArray": "$history" }
            }
        },
        {
            "$unwind": "$history"
        },
        {
            "$match": {
                "history.v.condition": { "$exists": True, "$ne": "" }
            }
        },
        {
            "$group": {
                "_id": "$_id",
                "unique_conditions": { "$addToSet": "$history.v.condition" }
            }
        },
        {
            "$unwind": "$unique_conditions"
        },
        {
            "$group": {
                "_id": "$unique_conditions",
                "count": { "$sum": 1 }
            }
        },
        {
            "$sort": { "count": -1 }
        },
        {
            "$limit": 5
        }
    ]

    result = db.patients.aggregate(pipeline)
    return list(result)



def episodes_per_month():
    db = setupConnection()
    result = db.episodes.aggregate([
        {"$unwind": "$hospitalizations"},
        {"$match": {"hospitalizations.hospitalization_date": {"$ne": None}}},
        {"$project": {"month": {"$month": "$hospitalizations.hospitalization_date"}}},
        {"$unionWith": {
            "coll": "episodes",
            "pipeline": [
                {"$unwind": "$appointments"},
                {"$match": {"appointments.appointment_date": {"$ne": None}}},
                {"$project": {"month": {"$month": "$appointments.appointment_date"}}}
            ]
        }},
        {"$unionWith": {
            "coll": "episodes",
            "pipeline": [
                {"$unwind": "$lab_screenings"},
                {"$match": {"lab_screenings.test_date": {"$ne": None}}},
                {"$project": {"month": {"$month": "$lab_screenings.test_date"}}}
            ]
        }},
        {"$unionWith": {
            "coll": "episodes",
            "pipeline": [
                {"$unwind": "$prescriptions"},
                {"$match": {"prescriptions.prescription_date": {"$ne": None}}},
                {"$project": {"month": {"$month": "$prescriptions.prescription_date"}}}
            ]
        }},
        {
            "$group": {
                "_id": "$month",
                "count": {"$sum": 1}
            }
        },
        {"$sort": {"count": -1}}
    ])

    result_list = list(result)
    result_list = [doc for doc in result_list if doc['_id'] is not None]
    month_names = {
        1: "January", 2: "February", 3: "March", 4: "April", 5: "May",
        6: "June", 7: "July", 8: "August", 9: "September", 10: "October",
        11: "November", 12: "December"
    }
    formatted_result = {month_names[doc['_id']]: doc['count'] for doc in result_list}
    formatted_result = sorted(formatted_result.items(),  key=lambda x:x[1], reverse=True)
    return formatted_result

def enfermeiras_sem_hospitalizacao():
    db = setupConnection()
    
    # Step 1: Extract all nurse_id values from the hospitalizations array
    pipeline = [
        {
            "$unwind": "$hospitalizations"
        },
        {
            "$group": {
                "_id": None,
                "assigned_nurses": { "$addToSet": "$hospitalizations.nurse_id" }
            }
        }
        ]
    
    result = list(db.episodes.aggregate(pipeline))
    
    # Get the list of assigned nurse IDs
    assigned_nurse_ids = result[0]['assigned_nurses'] if result else []
        # Step 2: Find all nurses not in the list of assigned nurse IDs
    unassigned_nurses = db.staff.find(
        { "id": { "$nin": assigned_nurse_ids } },
        { "id": 1, "first_name": 1, "last_name": 1, "_id": 0 }
        )
    
    return list(unassigned_nurses)

# patients with no bills
def find_patients_without_bills():
    db = setupConnection()
    pipeline = [
        {
            "$match": {
                "bills": { "$exists": False }
            }
        },
        {
            "$lookup": {
                "from": "patients",
                "localField": "patient_id",
                "foreignField": "id",
                "as": "patient_info"
            }
        },
        {
            "$unwind": "$patient_info"
        },
        {
            "$group": {
                "_id": "$patient_id",
                "name": { "$first": "$patient_info.name" }
            }
        },
        {
            "$project": {
                "patient_id": "$_id",
                "name": 1,
                "_id": 0
            }
        }
    ]
    
    result = db.episodes.aggregate(pipeline)
    patients = list(result)
    return patients, len(patients)

def find_most_common_appointment_hours():
    db = setupConnection()

    pipeline = [
    {
        "$unwind": "$appointments"  
    },
    {
        "$project": {
            "_id": 0,
            "hour": { "$substr": ["$appointments.appointment_time", 0, 2] }  
        }
    },
    {
        "$group": {
            "_id": "$hour",  
            "count": { "$sum": 1 },
            "hour": { "$first": "$hour" }  # Include the hour field
        }
    },
    {
            "$project": {
                "hour": 1,
                "name": 1,
                "count": 1,
                "_id": 0
            }
    },
    {
        "$sort": { "count": -1 }  
    },
    {
        "$limit": 5  
    }
    ]

    result = db.episodes.aggregate(pipeline)
    return list(result)


def avg_hospitalization_cost_by_room_type():
    db = setupConnection()
    result = db.episodes.aggregate([
        {"$unwind": "$hospitalizations"},
        {
            "$lookup": {
                "from": "rooms",
                "localField": "hospitalizations.room_id",
                "foreignField": "room_id",
                "as": "room_info"
            }
        },
        {"$unwind": "$room_info"},
        {
            "$group": {
                "_id": "$room_info.type",
                "average_cost": {"$avg": "$room_info.cost"}
            }
        },
                {
            "$project": {
                "_id": 1,
                "average_cost": {"$round": ["$average_cost", 2]}
            }
        },
        {"$sort": {"average_cost": -1}}
    ])
    return list(result)

def total_patients_per_gender():
    db = setupConnection()
    result = db.patients.aggregate([
        {
            "$group": {
                "_id": "$gender",
                "count": {"$sum": 1}
            }
        },
        {"$sort": {"count": -1}},
        {
            "$project": {
                "_id": 0,
                "gender": "$_id",
                "count": 1
            }
        }
    ])
    return list(result)

def patients_with_multiple_emergency_contacts():
    db = setupConnection()
    result = db.patients.aggregate([
        {
            "$project": {
                "name": 1,
                "emergency_contact_count": {
                    "$size": {"$ifNull": ["$emergency_contact", []]}
                }
            }
        },
        {
            "$match": {
                "emergency_contact_count": {"$gt": 1}
            }
        },
        {
            "$project": {
                "_id": 0,
                "name": 1,
                "emergency_contact_count": 1
            }
        }
    ])
    return list(result)



if __name__ == "__main__":
    str = ("Digite o número da query:\n \
        A-> Medicamento mais comum\n \
        B-> Quarto mais comum\n \
        C-> Pacientes com tipo sanguíneo\n \
        D-> Condição mais comum\n \
        E-> Episódios por mês\n \
        F-> Enfermeiras sem hospitalização\n \
        G-> Pacientes sem contas\n \
        H-> Horários de consulta mais comuns\n \
        I-> Custo médio de hospitalização por tipo de quarto\n \
        J -> Total de pacientes por gênero\n \
        K -> Pacientes com múltiplos contatos de emergência\n \
        exit -> Sair\n>")
    
    var = input(str)

    while var != "exit":
        if var == "A":
            result = medicamento_mais_comum()
            pprint(result)
        elif var == "B":
            result = room_mais_comum()
            pprint(result)
        elif var == "C":
            blood_type = input("Digite o tipo sanguíneo:\n>")
            result = pacientes_com_tipo_sangue(blood_type)
            pprint(result)
        elif var == "D":
            result = condição_mais_comum()
            pprint(result)
        elif var == "E":
            result = episodes_per_month()
            pprint(result)
        elif var == "F":
            result = enfermeiras_sem_hospitalizacao()
            pprint(result)
        elif var == "G":
            result, count = find_patients_without_bills()
            pprint(result)
            print(f"Total de pacientes sem contas: {count}")
        elif var == "H":
            result = find_most_common_appointment_hours()
            pprint(result)
        elif var == "I":
            result = avg_hospitalization_cost_by_room_type()
            pprint(result)
        elif var == "J":
            result = total_patients_per_gender()
            pprint(result)
        elif var == "K":
            result = patients_with_multiple_emergency_contacts()
            pprint(result)
        input("Enter para continuar...")
        var = input(str)
          
    