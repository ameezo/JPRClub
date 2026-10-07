from pydantic import BaseModel, EmailStr
from uuid import UUID

class UserBase(BaseModel):
    email: EmailStr
    name: str

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: UUID
    role: str

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

class Login(BaseModel):
    email: EmailStr
    password: str
