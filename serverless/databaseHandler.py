import redshift_connector
import json
import os
from secretHandler import get_secret

# Se obtienen los secretos desde el secrets manager
configs = json.loads(get_secret(os.environ['CONFIG']))

def get_connection():
    conn = redshift_connector.connect(
                host=configs['DB_HOST'],
                database=configs['DATABASE'],
                port=5439,
                user=configs['DB_USERNAME'],
                password=configs['DB_PASSWORD']
        )
    return conn

def getClientById(id):
    
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM clientes WHERE id = {}".format(id))

    db_response = cursor.fetchone()

    cursor.close()
    conn.close()

    return db_response

def insertClient(client):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    #Se asume que el id es autoincrement por lo que no es necesario indicarlo
    insert = """INSERT INTO clientes(nombre, apellido, rut, correo) VALUES ('%s','%s','%s','%s');""" % (client['nombre'], client['apellido'], client['rut'], client['correo'])

    cursor.execute(insert)

    cursor.commit()

    cursor.close()
    conn.close()

    