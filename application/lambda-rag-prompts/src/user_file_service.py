import boto3
import os

class UserFileService:

    def __init__(self):
        self.dynamodb_client = boto3.resource('dynamodb')
        self.table = self.dynamodb_client.Table(os.environ['TABLE_NAME'])
        self.s3_client = boto3.client('s3')

    def get_files_as_text(self, user_id: str) -> str:
        files = self.get_files(user_id)
        
        return "\n".join(files)

    def get_files(self, user_id: str) -> list:
        files_names = self.get_file_names(user_id)
        files = []
        bucket_name = os.environ['BUCKET_NAME']

        for item in files_names:
            file_path = f'private/{user_id}/{item["file_name"]}'
            response = self.s3_client.get_object(Bucket=bucket_name, Key=file_path)
            file_content = response['Body'].read().decode('utf-8')
            files.append(file_content)

        return files

    def get_file_names(self, user_id: str) -> list:
        response = self.table.query(
            KeyConditionExpression=boto3.dynamodb.conditions.Key('user_id').eq(user_id),
            ProjectionExpression='file_name'
        )

        return response['Items']