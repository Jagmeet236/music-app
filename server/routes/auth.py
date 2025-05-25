import uuid
import bcrypt
from fastapi import HTTPException, Depends
from database import get_db
from models.user import User 
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin
router = APIRouter()


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
    
    return user_db
