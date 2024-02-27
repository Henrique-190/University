import uuid
import mysql.connector
import random

from datetime import datetime, timedelta


"""
10 users
1 admin
4 workers
4 clients

40 orders
"""

admins = []
workers = []
clients = []


def generate_address():
    streets = [
        "Piastowska, Wroclaw",
        "Długi Targ, Gdańsk",
        "Strøget, København",
        "Södergatan, Malmo",
        "Floriańska, Kraków",
        "Karlova, Praha",
        "Unter den Linden, Berlin",
        "Nowy Swiat, Warszawa",
        "Váci Utca, Budapest",
        "Praça Hlavné, Bratislava",
        "Ringstrasse, Wien",
        "Rua 25 de abril, Monção",
        "Rua Dr. Abílio Torres, Vizela",
        "Rua Dom António Barroso, Barcelos"
    ]
    return f"{random.randint(1, 100)}, {random.choice(streets)}"

def generate_date(year, month, day):
    actual_date = datetime.now()
    limit_date = datetime(year, month, day)

    difference = (actual_date - limit_date).days
    days = random.randint(0, difference)
    ans = actual_date - timedelta(days=days)
    ans.replace(hour=random.randint(8, 17), minute=random.randint(8, 52), second=random.randint(8,58))
    return ans

for i in range(0, 10):
    if i == 0:
        admins.append((
            f"user{i}",
            f"password{i}",
            f"Name{i}",
            f"email{i}@example.com",
            generate_address(),
            str(random.randint(100000000, 999999999))
        ))
    elif i < 6:
        workers.append((
            f"user{i}",
            f"password{i}",
            f"Name{i}",
            f"email{i}@example.com",
            generate_address(),
            str(random.randint(100000000, 999999999))
        ))
    else:
        clients.append((
            f"user{i}",
            f"password{i}",
            f"Name{i}",
            f"email{i}@example.com",
            generate_address(),
            str(random.randint(100000000, 999999999))
        ))

conn = mysql.connector.connect(
    host="localhost",
    user="leitrack",
    password="leitrack",
    database="leitrack"
)
cursor = conn.cursor()

cursor.executemany('INSERT INTO user VALUES (%s, %s, %s, %s, %s, %s)', admins + workers + clients)
conn.commit()

cursor.execute(f'INSERT INTO admin VALUE ("{admins[0][0]}")')

for worker in workers:
    cursor.execute(f'INSERT INTO worker VALUE ("{worker[0]}")')

for client in clients:
    cursor.execute(f'INSERT INTO client VALUES ("{client[0]}")')
conn.commit()

for i in range(40):
    registered = generate_date(2023, 1, 1)
    expected = generate_date(registered.year, registered.month, registered.day)
    handled = generate_date(registered.year, registered.month, registered.day)
    delivered = generate_date(handled.year, handled.month, handled.day)

    user = random.choice(admins + workers + clients)

    worker1 = random.choice(workers)
    worker2 = random.choice(workers)

    id_order = str(uuid.uuid4())

    sql = f'INSERT INTO ordertrack VALUE ("{id_order}", 2, "{user[0]}", "{user[5]}", "{worker1[0]}", "{worker2[0]}", "{user[4]}", "{registered.strftime("%Y-%m-%d %H:%M:%S")}", "{handled.strftime("%Y-%m-%d %H:%M:%S")}", "{expected.strftime("%Y-%m-%d %H:%M:%S")}", "{delivered.strftime("%Y-%m-%d %H:%M:%S")}", 1, 2)'
    cursor.execute(sql)
    conn.commit()

    notification = f'INSERT INTO notification (id_client, id_order, date_created, content) VALUES ("{user[0]}", "{id_order}", "{handled.strftime("%Y-%m-%d %H:%M:%S")}", "Shipping Order.")'
    cursor.execute(notification)
    conn.commit()


    notification = f'INSERT INTO notification (id_client, id_order, date_created, content) VALUES ("{user[0]}", "{id_order}", "{delivered.strftime("%Y-%m-%d %H:%M:%S")}", "Order delivered.")'
    cursor.execute(notification)
    conn.commit()


    try:
        workershift = f'INSERT workershifts VALUE ("{worker1[0]}", "{registered.year}-{registered.month}-{registered.day} 08:00:00", "{registered.year}-{registered.month}-{registered.day} 17:00:00")'
        cursor.execute(workershift)
        conn.commit()

        workershift = f'INSERT workershifts VALUE ("{worker2[0]}", "{handled.year}-{handled.month}-{handled.day} 08:00:00", "{handled.year}-{handled.month}-{handled.day} 17:00:00")'
        cursor.execute(workershift)
        conn.commit()
        
    except:
        continue

    conn.commit()

conn.close()