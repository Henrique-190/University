
import traceback
import oracledb 
import pymongo
import json
from collections import defaultdict
import datetime as dt


def setupConnection(mongo_url="mongodb://localhost:27017/", mongo_port=27017):
    mongo_client = pymongo.MongoClient(mongo_url,mongo_port)
    mongo_port = 27017
    mongo_db = mongo_client["hospital"]
    return mongo_db

# PROCEDURE 1
# UPDATE A BILL WITH A STATUS BASED ON AMMOUNT OF MONEY PAID
def procedure_1(bill_ID : int , amount : float):
    mongo_db = setupConnection()
    episode_collection = mongo_db["episodes"]
    result_success = episode_collection.update_many(
        {
            "bills": {
                "$elemMatch": {
                    "bil_id": bill_ID,
                    "total_cost": { "$gt": amount }
                }
            }
        },
        {
            "$set": { "bills.$[elem].status": "FAILED" }
        },
        array_filters=[{"elem.bil_id": bill_ID}]
    )

    result_failed = episode_collection.update_many(
        {
            "bills": {
                "$elemMatch": {
                    "bil_id": bill_ID,
                    "total_cost": { "$lte": amount }
                }
            }
        },
        {
            "$set": { "bills.$[elem].status": "PROCESSED" }
        },
        array_filters=[{"elem.bil_id": bill_ID}]
    ) 
    return

def retire_staff(staff_id: int):
    mongo_db = setupConnection()
    staff_collection = mongo_db["staff"]
    staff_collection.update_one({"id": staff_id}, {"$set": {"is_active": "N"}})
    return

def restock_medicine(medicine_name: str, amount: int):
    mongo_db = setupConnection()
    medicine_collection = mongo_db["medicines"]
    medicine_collection.update_one(
        {"name": medicine_name},
        {"$inc": {"quantity": amount}}
    )
    return

def take_medicine(medicine_name: str, amount: int, budget: float):
    mongo_db = setupConnection()
    medicine_collection = mongo_db["medicines"]
    medicine = medicine_collection.find_one({"name": medicine_name})
    if not medicine:
        raise ValueError(f"Medicine '{medicine_name}' not found")
    
    cost_per_unit = medicine.get("cost", 0) 
    if cost_per_unit <= 0:
        raise ValueError(f"Invalid cost for medicine '{medicine_name}'")
    max_affordable_quantity = int(budget / cost_per_unit)
    amount = min(amount, max_affordable_quantity)
    current_quantity = medicine.get("quantity", 0)
    new_quantity = max(current_quantity - amount, 0)
    taken_away = current_quantity - new_quantity
    medicine_collection.update_one(
        {"name": medicine_name},
        {"$set": {"quantity": new_quantity}}
    )
    
    return taken_away


     

if __name__ == "__main__":
    var = int(input("1-> Update Bill Status\n2-> Retire Staff\n3-> Restock medicine\n4-> Take medicine\n5->Exit\n>"))
    while var != 5:
        if var == 1:
            bill_ID = int(input("Enter the bill ID:\n>"))
            ammount = float(input("Enter the ammount:\n>"))    
            procedure_1(bill_ID, ammount)
            print("BILL " + str(bill_ID) + " UPDATED")
        elif var == 2:
            staff_ID = int(input("Enter the staff ID:\n>"))
            retire_staff(staff_ID)
            print("STAFF " + str(staff_ID) + " RETIRED")
        elif var == 3:
            medicine_name = input("Enter the medicine name:\n>")
            ammount = int(input("Enter the ammount:\n>"))
            restock_medicine(medicine_name, ammount)
            print("MEDICINE " + medicine_name + " RESTOCKED BY " + str(ammount) + " UNITS")
        elif var == 4:
            medicine_name = input("Enter the medicine name:\n>")
            ammount = int(input("Enter the ammount:\n>"))
            budget = float(input("Enter the budget:\n>"))
            taken = take_medicine(medicine_name, ammount, budget)
            print("MEDICINE " + medicine_name + " TAKEN BY " + str(taken) + " UNITS")
        else:
            print("Invalid input")
        var = int(input("1-> Update Bill Status\n2-> Retire Staff\n3-> Restock medicine\n4-> Take Medicine\n5-> Exit\n>"))
    