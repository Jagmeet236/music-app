import os
import uuid
import bcrypt
from fastapi import HTTPException, Depends
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from dotenv import load_dotenv
import jwt
import time
from models.otp import OTP
from utils.otp_helper import generate_otp
from utils.email_service import send_otp_email
from pydantic_schemas.reset_password import ResetPassword
from pydantic_schemas.send_otp import SendOTP
from pydantic_schemas.verify_otp import VerifyOTP
from pydantic_schemas.user_login import UserLogin

router = APIRouter()

# Load variables from .env file
load_dotenv()

# Read secret key used to sign JWT tokens
secret_key = os.getenv("SECRET_KEY")

# Stop server if secret key is missing
if not secret_key:
    raise ValueError("SECRET_KEY environment variable is not set.")


# =========================
# USER SIGNUP
# =========================
@router.post('/signup', status_code=201)
def signup(user: UserCreate, db: Session = Depends(get_db)):

    # Check if email already exists
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(
            status_code=400,
            detail="User with the same email already exists!"
        )

    # Convert password into a secure hash
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())

    # Create new user object
    user_db = User(
        id=str(uuid.uuid4()),
        name=user.name,
        email=user.email,
        password=hashed_pw
    )

    # Save user in database
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


# =========================
# USER LOGIN
# =========================
@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):

    # Find user by email
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(
            status_code=404,
            detail='User with the given email does not exist!'
        )

    # Compare entered password with stored password hash
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    if not is_match:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials. Please try again."
        )

    # Create login JWT token
    token = jwt.encode(
        {"id": user_db.id},
        secret_key,
        algorithm="HS256"
    )

    return {"token": token, "user": user_db}


# =========================
# GET CURRENT USER
# =========================
@router.get('/')
def current_user_data(
        db: Session = Depends(get_db),
        user_dict=Depends(auth_middleware)
):

    # Get user id from decoded JWT token
    db_user = db.query(User).filter(User.id == user_dict['uid']).first()

    if not db_user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return db_user


# =========================
# SEND OTP
# =========================
@router.post("/send-otp")
async def send_otp(data: SendOTP, db: Session = Depends(get_db)):

    email = data.email

    # Generate random 6 digit OTP
    otp = generate_otp()

    # OTP expires in 5 minutes
    expiry_time = int(time.time()) + 300

    # Save OTP in database
    otp_entry = OTP(
        email=email,
        otp=otp,
        expires_at=expiry_time
    )

    db.merge(otp_entry)
    db.commit()

    # Send OTP to email
    await send_otp_email(email, otp)

    return {
        "success": True,
        "message": "OTP sent successfully",
        "data": None
    }


# =========================
# VERIFY OTP
# =========================
@router.post("/verify-otp")
def verify_otp(data: VerifyOTP, db: Session = Depends(get_db)):

    email = data.email
    otp = data.otp
    purpose = data.purpose

    # Find OTP entry
    otp_entry = db.query(OTP).filter(OTP.email == email).first()

    if not otp_entry:
        raise HTTPException(status_code=400, detail="OTP not requested")

    # Check if OTP expired
    if otp_entry.expires_at < int(time.time()):
        raise HTTPException(status_code=400, detail="OTP expired")

    # Check if OTP matches
    if otp_entry.otp != otp:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    # Delete OTP so it cannot be reused
    db.delete(otp_entry)
    db.commit()

    # If this OTP is for password reset
    if purpose == "reset_password":

        # Get user so we can include password hash in token
        user = db.query(User).filter(User.email == email).first()

        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        # Create reset token
        reset_token = jwt.encode(
            {
                "email": email,
                "pwd": user.password.decode() if isinstance(user.password, bytes) else user.password,
                "type": "reset",
                "exp": int(time.time()) + 600
            },
            secret_key,
            algorithm="HS256"
        )

        return {
            "success": True,
            "message": "OTP verified successfully",
            "data": {
                "reset_token": reset_token
            }
        }

    # Otherwise normal login flow
    user_db = db.query(User).filter(User.email == email).first()

    token = jwt.encode(
        {"id": user_db.id},
        secret_key,
        algorithm="HS256"
    )

    return {
        "success": True,
        "message": "OTP verified successfully",
        "data": {
            "token": token,
            "user": user_db
        }
    }


# =========================
# RESET PASSWORD
# =========================
@router.post("/reset-password")
def reset_password(data: ResetPassword, db: Session = Depends(get_db)):

    try:
        # Decode reset token
        payload = jwt.decode(
            data.reset_token,
            secret_key,
            algorithms=["HS256"]
        )

    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=401,
            detail="Reset token expired"
        )

    except jwt.PyJWTError:
        raise HTTPException(
            status_code=401,
            detail="Invalid reset token"
        )

    # Ensure token is meant for password reset
    if payload.get("type") != "reset":
        raise HTTPException(
            status_code=401,
            detail="Invalid reset token type"
        )

    email = payload.get("email")
    token_pwd_hash = payload.get("pwd")

    # Find user in database
    user = db.query(User).filter(User.email == email).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    current_pwd_hash = user.password.decode() if isinstance(user.password, bytes) else user.password

    # Compare password hash in token with DB password hash
    if token_pwd_hash != current_pwd_hash:
        raise HTTPException(
            status_code=401,
            detail="Reset token already used or password changed"
        )

    # Hash new password
    new_hashed_pw = bcrypt.hashpw(
        data.new_password.encode(),
        bcrypt.gensalt()
    )

    # Update password in database
    user.password = new_hashed_pw
    db.commit()

    return {
        "success": True,
        "message": "Password reset successful",
        "data": None
    }