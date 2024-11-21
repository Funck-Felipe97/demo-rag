import logging
from user_file_service import UserFileService

# Configuração básica de logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Nível de log pode ser alterado para DEBUG, WARNING, etc.

user_file_service = UserFileService()

def lambda_handler(event, context):
    logger.info(f"Receiving lambda event: {event}")

    try:
        # Informações do bucket e do objeto
        bucket_name: str = event['Records'][0]['s3']['bucket']['name']
        object_key: str = event['Records'][0]['s3']['object']['key']
        
        logger.info(f"new file added: {bucket_name}/{object_key}")

        user_id = object_key.split("/")[1]
        file_name = object_key.split("/")[2]

        user_file_service.save(
            user_id=user_id,
            file_name=file_name
        )

        return {
            "statusCode": 201,
            "body": "User File Saved..."
        }
    except Exception as e:
        logger.error(f"Ocorreu um erro: {e}")
        return {
            "statusCode": 500,
            "body": "Erro ao processar o arquivo."
        }