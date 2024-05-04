import json
from databaseHandler import insertClient

def lambda_handler(event, context):
    # Se obtiene el mensaje de SNS y se transforma a json
    sns_message = json.loads(event['Records'][0]['Sns']['Message'])

    insertClient(sns_message)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Mensaje insertado')
    }