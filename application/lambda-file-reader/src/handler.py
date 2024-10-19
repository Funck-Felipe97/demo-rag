import json
import os
import boto3
from botocore.config import Config
from botocore.exceptions import ClientError

# Configurando a assinatura v4
s3_config = Config(signature_version='s3v4')

# Criando o cliente S3 com a assinatura configurada
s3_client = boto3.client('s3', config=s3_config)

def lambda_handler(event, context):
    try:
        user_id = event['requestContext']['authorizer']['claims']['sub']
        file_name = event['queryStringParameters']['file_name']

        bucket_name = os.environ['BUCKET_NAME']
        key_name = f'private/{user_id}/{file_name}'

        # Gerar URL pré-assinada para o download
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket_name, 'Key': key_name},
                                                    ExpiresIn=3600)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "download_url": response
            }),
            "headers": {
                "Content-Type": "application/json"
            }
        }

    except ClientError as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
