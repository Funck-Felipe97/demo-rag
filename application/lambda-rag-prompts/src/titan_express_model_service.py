import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

class TitanExpressModelService:
    def __init__(self):
        self.bedrock_client = boto3.client(service_name='bedrock-runtime', region_name="us-east-1")

    def send_prompt(self, prompt: str) -> str:
        try:
            config = self.get_configuration(prompt)

            response = self.bedrock_client.invoke_model(
                body=config, 
                modelId="amazon.titan-text-express-v1", 
                accept="application/json", 
                contentType="application/json")
            response_body = json.loads(response.get('body').read())
            
            return response_body.get('results')[0].get('outputText')

        except Exception as e:
            logger.error(f"Error on calling model: {e}")
            return None
    
    def get_configuration(self, prompt:str):
        return json.dumps({
                "inputText": prompt,
                "textGenerationConfig": {
                    "maxTokenCount": 4096,
                    "stopSequences": [],
                    "temperature": 0,
                    "topP": 1
                }
        })
