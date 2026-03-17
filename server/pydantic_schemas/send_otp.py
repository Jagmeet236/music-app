from pydantic import BaseModel, EmailStr

class SendOTP(BaseModel):
    email: EmailStr