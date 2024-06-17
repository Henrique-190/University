import json

from flask import Flask, request, jsonify, redirect
from RAG import RAG
from flask_cors import CORS
from uuid import uuid4
app = Flask(__name__)
CORS(app)

RAG = RAG()

chats = {}
users = {}

with open('./data_users/chats.json', 'r', encoding='utf-8') as f:
    chats = json.load(f)

with open('./data_users/users.json', 'r', encoding='utf-8') as f:
    users = json.load(f)

def dump():
    with open('./data_users/users.json', 'w', encoding='utf-8') as f:
        json.dump(users, f, ensure_ascii=False, indent=4)
    with open('./data_users/chats.json', 'w', encoding='utf-8') as f:
        json.dump(chats, f, ensure_ascii=False, indent=4)

@app.route('/chat/<string:id>/<string:chat_id>', methods=['GET'])
def chat(id, chat_id):
    """Get messages from chat"""
    if id not in users:
        return jsonify({"error": "User not found"}), 404
    if chat_id not in chats[id]:
        return jsonify({"error": "Chat not found"}), 404
    
    return jsonify({"success": True, "data": chats[id][chat_id]}, 200)


@app.route('/register', methods=['POST'])
def register():
    """Add a new user to the system"""
    user = request.json
    if not isinstance(user, dict):
        return jsonify({"error": "Input must be a JSON object"}), 400

    if user['id'] in users:
        return jsonify({"error": "User already exists"}), 400

    users[user['id']] = user['password']
    chats[user['id']] = {str(uuid4()): []}
    dump()
    return jsonify({"success": True, "redirect": f"/chat/{list(chats[user['id']])[-1]}"})


@app.route('/login', methods=['POST'])
def login():
    """Login a user to the system"""
    user = request.json
    print(user)
    if user['id'] not in users or users[user['id']] != user['password']:
        return jsonify({"error": "Invalid credentials"}), 404
    
    return jsonify({"success": True, "redirect": f"/chat/{list(chats[user['id']])[-1]}"})


@app.route('/latestChat/<user>', methods=['GET'])
def latest_chat(user):
    """Get the latest chat from a user"""
    if user not in users:
        return jsonify({"error": "User not found"}), 404
    
    return jsonify({"success": True, "redirect": list(chats[user])[-1]})


@app.route('/chats/<user>', methods=['GET'])
def chats_user(user):
    """Get all chats from a user"""
    if user not in users:
        return jsonify({"error": "User not found"}), 404
    
    return jsonify({"success": True, "data": list(chats[user].keys())})


@app.route('/newChat', methods=['GET'])
def new_chat():
    """Create a new chat for a user"""
    user = request.args.get('user')
    if user not in users:
        return jsonify({"error": "User not found"}), 404

    uid = str(uuid4())
    if uid not in chats[user]:
        chats[user][uid] = []
    dump()
    return jsonify({"success": True, "chat_id": uid})


@app.route('/query', methods=['POST'])   
def get_query():
    """Get the answer to a query"""
    data = request.get_json()
    
    query = data.get('query')

    response = RAG.query(query)
    answer = response["response"]
    sources = response["source"]

    return {
        'answer': answer, 
        'sources': sources,
        'type':'received'
        }
# TODO: adicionar uma rota que permita ir buscar texto a um link providenciado pelo user
# TODO: adicionar a verificação da presença de hiperligações na query, se existirem primeiro vamos buscar o texto que lá está para adicionarmos ao contexto
# TODO: testar esta rota
@app.route('/evaluate', methods=['POST'])
def evaluate():
    data = request.get_json()
    query = data.get('query')
    answer = RAG.evaluate(query)
    return {'answer': answer}



@app.route('/compare', methods=['POST'])
def compare():
    data = request.get_json()
    query = data.get('query')
    ourAnswer, llmAnswer  = RAG.compareSolution(query)

    return {'Resposta do nosso modelo': ourAnswer, 'Resposta do LLM': llmAnswer}



@app.route('/insert', methods=['POST'])
def insert():
    data = request.get_json()
    data = data.get('data')
    RAG.insertData(data)
    return {'status': 'ok'}


if __name__ == "__main__":
    app.run(port=8000, debug=False)