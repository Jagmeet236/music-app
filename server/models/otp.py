from sqlalchemy import Column, String, Integer
from models.base import Base

class OTP(Base):
    __tablename__ = "otp_codes"

    email = Column(String, primary_key=True)
    otp = Column(String)
    expires_at = Column(Integer)