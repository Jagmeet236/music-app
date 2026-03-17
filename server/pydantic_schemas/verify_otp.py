from pydantic import BaseModel, EmailStr

class VerifyOTP(BaseModel):
    email: str
    otp: str
    purpose: str