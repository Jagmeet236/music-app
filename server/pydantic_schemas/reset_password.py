from pydantic import BaseModel


class ResetPassword(BaseModel):
    reset_token: str
    new_password: str