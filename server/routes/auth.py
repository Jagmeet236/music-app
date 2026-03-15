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
import jwt;
import time
from models.otp import OTP
from utils.otp_helper import generate_otp
from utils.email_service import send_otp_email

from pydantic_schemas.send_otp import SendOTP
from pydantic_schemas.verify_otp import VerifyOTP
from pydantic_schemas.user_login import UserLogin
router = APIRouter()
load_dotenv()

secret_key = os.getenv("SECRET_KEY")
if not secret_key:
    raise ValueError("SECRET_KEY environment variable is not set.")


@router.post('/signup', status_code = 201)
def signup(user: UserCreate, db: Session = Depends(get_db)):
    # check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail="User with the same email already exists!")
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    # initialise the user
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email,  password=hashed_pw)
    # add the user to the db
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db



@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    # Check if an account with this email exists
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(
            status_code=404,
            detail=f'User with the given email does not exist!',
        )

    # Verify the provided password against the stored hash
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)
    if not is_match:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials. Please try again.",
        )

    # Generate JWT token for the authenticated user
    token = jwt.encode({"id": user_db.id}, secret_key)
    return {"token": token, "user": user_db}


@router.get('/')
def current_user_data(db: Session = Depends(get_db), 
                      user_dict=Depends(auth_middleware) ):
    # postgres database get the user info by id
    db_user = db.query(User).filter(User.id == user_dict['uid']).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
    

@router.post("/send-otp")
async def send_otp(data: SendOTP, db: Session = Depends(get_db)):

    email = data.email

    # generate otp
    otp = generate_otp()

    # otp expires in 5 minutes
    expiry_time = int(time.time()) + 300

    # save or update otp in database
    otp_entry = OTP(
        email=email,
        otp=otp,
        expires_at=expiry_time
    )

    db.merge(otp_entry)
    db.commit()

    # send otp email
    await send_otp_email(email, otp)

    return {"message": "OTP sent successfully"}




@router.post("/verify-otp")
def verify_otp(data: VerifyOTP, db: Session = Depends(get_db)):
    
    # Extract email and otp sent by client 
    email = data.email
    otp = data.otp

    # Fetch OTP record for the email from database
    otp_entry = db.query(OTP).filter(OTP.email == email).first()

    # If user never requested an OTP
    if not otp_entry:
        raise HTTPException(status_code=400, detail="OTP not requested")

    # Check if OTP has expired
    # expires_at stores the unix timestamp when the OTP becomes invalid
    if otp_entry.expires_at < int(time.time()):
        raise HTTPException(status_code=400, detail="OTP expired")

    # Compare user entered OTP with stored OTP
    if otp_entry.otp != otp:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    # Fetch user from database using email
    user_db = db.query(User).filter(User.email == email).first()

    # If user does not exist in database
    if not user_db:
        raise HTTPException(status_code=404, detail="User not found")

    # Generate JWT token for authenticated user
    # Token contains user id and will be used for authenticated requests
    token = jwt.encode({"id": user_db.id}, secret_key)

    # Return token and user data to the client
    # Client will store the token and send it in future API requests
    return {"token": token, "user": user_db}