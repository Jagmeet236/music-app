import os
from fastapi import HTTPException, Header
from dotenv import load_dotenv
import jwt
load_dotenv()

secret_key = os.getenv("SECRET_KEY")
if not secret_key:
    raise ValueError("SECRET_KEY environment variable is not set.")

def auth_middleware(x_auth_token = Header()):
    try:
        # get the user token from the request header
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="Authorization token is missing!")
        
        # decoding the token 
        verified_token = jwt.decode(x_auth_token, secret_key, algorithms=["HS256"])

        if not verified_token:
            raise HTTPException(status_code=401, detail="Invalid token. Authorization failed!")

        # get the user id form the token
        uid = verified_token.get("id")
        return {'uid': uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token. Authorization failed!")
   