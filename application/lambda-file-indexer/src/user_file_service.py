import boto3
import logging
from botocore.exceptions import ClientError

# Configuração básica de logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Nível de log pode ser alterado para DEBUG, WARNING, etc.

class UserFileService:

    def __init__(self):
        self.dynamodb_client = boto3.resource('dynamodb')
        self.table = self.dynamodb_client.Table('UserFiles')

    def save(self, user_id, file_name):
        logger.info(f"Trying to save user file, user_id: {user_id}, file_name: {file_name}")

        try:
            self.table.put_item({
                'user_id': user_id,
                'file_name': file_name
            })

            logger.addFilter("User file saved...")
        except ClientError as e:
            logger.error(f"Error on saving user file: {e}")
            raise e