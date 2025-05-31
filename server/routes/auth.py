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
    # Check if user exists in the database
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(status_code=400, detail='User with the given email does not exist!')
    # Check if the password is provided
    # Compare password (user input) with hashed password from DB
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)
    if not is_match:
        raise HTTPException(status_code=400, detail='Incorrect password!')
    # Generate JWT token
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
    

