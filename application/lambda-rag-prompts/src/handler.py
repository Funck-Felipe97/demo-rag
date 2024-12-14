import json
import logging
from prompt_service import PromptService

# Configuração básica de logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Nível de log pode ser alterado para DEBUG, WARNING, etc.
prompt_service = PromptService()

def lambda_handler(event, context):
    try:
        logger.info(f"Event received: {event}")

        user_id = event['requestContext']['authorizer']['claims']['sub']  
        prompt = json.loads(event["body"])["prompt"]

        response = prompt_service.send_prompt(user_id, prompt)
        logger.info(f"response: {response}")

        return {
            "statusCode": 200,
            "body": json.dumps({"chat_response": response}),
            "headers": {"Content-Type": "application/json"}
        }
    except Exception as e:
        logger.error(f"Error on lambda handdler {e}")

        return {
            "statusCode": 500,
            "body": "Error on processing prompt",
            "headers": {"Content-Type": "application/json"}
        }