from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime as dt
from time import sleep


# Incremento manual do ID da conta quando uma conta nova é criada
def get_new_id(collection):
    highest_bill_id = 0
    cursor = collection.find()
    for document in cursor:
        if 'bills' in document:
            for bill in document['bills']:
                if 'bill_id' in bill and bill['bill_id'] > highest_bill_id:
                    highest_bill_id = bill['bill_id']
    
    return highest_bill_id+1

# Obter custo total de quarto de hospitalização
def get_room_cost(room_id, rooms_collection):
    room = rooms_collection.find_one({'room_id': room_id})
    if room and 'cost' in room:
        return room['cost']
    return 0
# Obter custo total das hospitalizações
def calculate_hospitalization_costs(document, rooms_collection):
    total_hospitalization_cost = 0
    
    if 'hospitalizations' in document:
        for hospitalization in document['hospitalizations']:
            room_id = hospitalization.get('room_id')
            admission_date = hospitalization.get('admission_date')
            discharge_date = hospitalization.get('discharge_date')
            if discharge_date:
                room_cost_per_day = get_room_cost(room_id, rooms_collection)
            
                duration = (discharge_date - admission_date).days
                if duration < 1:
                    duration = 1  
            
                hospitalization_cost = room_cost_per_day * duration
                total_hospitalization_cost += hospitalization_cost
            else:
                pass

    return total_hospitalization_cost

# Obter custo do medicamento
def get_medicine_cost(med_id, medicines_collection):
    med = medicines_collection.find_one({'id': med_id})
    if med and 'cost' in med:
        return med['cost']
    return 0
# Obter custo total das prescrições
def calculate_prescription_costs(document, medicines_collection):
    total_prescription_cost = 0
    if 'prescriptions' in document:
        for prescription in document['prescriptions']:
            med_id = prescription.get('medicine_id')
            med_cost = get_medicine_cost(med_id, medicines_collection)
            total_prescription_cost += med_cost

    return total_prescription_cost



# Gerar uma conta com base nas informações do paciente
def generate_bill_data(document, new_bill_id , medicines_collection, rooms_collection):
    room_cost = calculate_hospitalization_costs(document, rooms_collection)  
    test_cost = 0.0
    if 'lab_screenings' in document:
        for screening in document['lab_screenings']:
            if 'test_cost' in screening:
                test_cost += screening['test_cost']
    others_cost = calculate_prescription_costs(document, medicines_collection)

    total_cost = room_cost + test_cost + others_cost

    return {
        'bill_id': new_bill_id,  # Assign the new bill_id
        'register_date': dt.now().isoformat(),
        'room_cost': room_cost,
        'test_cost': test_cost,
        'others_cost': others_cost,
        'total_cost': round(float(total_cost),2),
        'status': 'PENDING'
    }

# Atualizar a conta de um paciente
def update_bill_data(document, medicines_collection, rooms_collection):
    # Logic to generate bill data based on patient information
    room_cost = calculate_hospitalization_costs(document, rooms_collection) 
    test_cost = 198.34  # Example fixed test cost
    others_cost = calculate_prescription_costs(document, medicines_collection)

    total_cost = room_cost + test_cost + others_cost
    existing_bill = document['bills'][0]
    if existing_bill.get('total_cost') == total_cost:
        return None
    else:
        bill_data = {
            'room_cost': room_cost,
            'test_cost': test_cost,
            'others_cost': others_cost,
            'total_cost': round(float(total_cost),2),
            'status': 'PENDING',
        }
        return bill_data


def handle_bill_generation(collection, document, medicines_collection, rooms_collection):
    patient_id = document.get('patient_id')
    # Check if the document already has a 'bills' attribute
    if 'bills' in document:
        # Se existir conta e se o valor novo for diferente do antigo, atualiza a conta
        if document['bills']:
            bill_data = update_bill_data(document, medicines_collection, rooms_collection)
            if bill_data:
                collection.update_one(
                    {'_id': document['_id']},
                    {'$set': {'bills.0': bill_data}}
                )
        else:
            # Se o array está vazio, cria uma nova conta
            new_bill_id = get_new_id(collection)
            new_bill = generate_bill_data(document, new_bill_id, medicines_collection, rooms_collection)
            collection.update_one(
                {'_id': document['_id']},
                {'$set': {'bills': [bill_data]}}
            )
    else:
        # Se não existe atributo 'bills', cria uma nova conta
        new_bill_id = get_new_id(collection)
        new_bill = generate_bill_data(document, new_bill_id, medicines_collection, rooms_collection)
        collection.update_one(
            {'_id': document['_id']},
            {'$set': {'bills': [new_bill]}}
        )

    print(f'Bill updated for patient: {patient_id}')


def update_bills():
    uri = 'mongodb://localhost:27017/'
    client = MongoClient(uri)
    database = client['hospital']
    collection = database['episodes']
    rooms = database['rooms']
    medicines = database['medicines']

    try:
        cursor = collection.find()
        for document in cursor:
            handle_bill_generation(collection, document, medicines, rooms)

        print('All documents processed.')
    except Exception as e:
        print(f'Error updating bills: {e}')
    finally:
        client.close()

if __name__ == '__main__':
    
    input = int(input("1-> Executar Trigger 1 vez\n2-> Inicializar Trigger\n>"))
    
    if input ==  1:
        update_bills()
        exit(0)
    elif input == 2:
        uri = 'mongodb://localhost:27017/'
        client = MongoClient(uri)
        database = client['hospital']
        collection = database['episodes']

        print("Watching for new insertions...")
        try:
            with collection.watch([{'$match': {'operationType': 'insert'}}]) as stream:
                for change in stream:
                    print("Insertion detected, updating bills...")
                    update_bills()
        except Exception as e:
            print(f"Operation failed: {e}")
    else:
        exit(0)