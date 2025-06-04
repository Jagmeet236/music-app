import os
import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from middleware.auth_middleware import auth_middleware
from dotenv import load_dotenv

from models.song import Song

router = APIRouter()
load_dotenv()

cloud_key = os.getenv("CLOUDINARY_API_KEY")
cloud_secret = os.getenv("CLOUD_API_SECRET")
cloud_name = os.getenv("CLOUD_NAME")
if not cloud_key and cloud_secret:
    raise ValueError("ENV NOT SET.")


cloudinary.config( 
    cloud_name = cloud_name, 
    api_key = cloud_key,
    api_secret = cloud_secret,
    secure=True
)




@router.post('/upload', status_code= 201)
def upload_song(song: UploadFile= File(...) ,
                 thumbnail: UploadFile= File(...), 
                 artist:str= Form(...), 
                 song_name:str= Form(...),
                 hex_code:str= Form(...), 
                 db : Session= Depends(get_db),
                 user_dict=Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    print(song_res['url'])
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    print(thumbnail_res['url'])
    new_song = Song(
        id=song_id,
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_res['url'],
        thumbnail_url = thumbnail_res['url'],
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song