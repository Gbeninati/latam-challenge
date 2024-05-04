import json
from databaseHandler import getClientById

# Funcion que se recibe la llamda get con el id de un cliente, los busca en redshift y lo retorna
def get_client(event, context):
    client_id = ""

    if event['queryStringParameters'] is not None:
        query_params = event['queryStringParameters']
        if 'client_id' in query_params:
            client_id = query_params['client_id']

    if client_id == "":
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Se debe indicar el parametro client_id'})
        }

    try:
        client = getClientById(client_id)
        body = {
            "body":client
        }

        response = {"statusCode": 200, "body": json.dumps(body)}

        return response
    except Exception as e:
        print("Existio un error. Error: %s" % str(e))
        return {"statusCode":400, "body": json.dumps({"error":str(e)})}
