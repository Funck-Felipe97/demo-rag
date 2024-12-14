from titan_express_model_service import TitanExpressModelService
from user_file_service import UserFileService

class PromptService: 

    def __init__(self):
        self.model = TitanExpressModelService()
        self.user_file_service = UserFileService()
        pass

    def send_prompt(self, user_id: str, message: str) -> str:
        kb_content = self.user_file_service.get_files_as_text(user_id)

        prompt = '\n'.join(
            [
                'Dado o texto abaixo',
                kb_content,
                'responda a seguinte questão',
                message
            ]
        )

        return self.model.send_prompt(prompt)

