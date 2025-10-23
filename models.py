from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin

db = SQLAlchemy()

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.BigInteger, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    email = db.Column(db.String(254))
    is_admin = db.Column(db.Boolean, default=False)

class Category(db.Model):
    __tablename__ = 'categories'
    id = db.Column(db.BigInteger, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)
    subcategories = db.relationship('Subcategory', backref='category', lazy=True)

class Subcategory(db.Model):
    __tablename__ = 'subcategories'
    id = db.Column(db.BigInteger, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)
    category_id = db.Column(db.BigInteger, db.ForeignKey('categories.id'), nullable=False)
    products = db.relationship('Product', backref='subcategory', lazy=True)

class Product(db.Model):
    __tablename__ = 'products'
    id = db.Column(db.BigInteger, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=False)
    subcategory_id = db.Column(db.BigInteger, db.ForeignKey('subcategories.id'), nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    tags = db.Column(db.String(200))
    image_filename = db.Column(db.String(255), nullable=True)

class UserProfile(db.Model):
    __tablename__ = 'user_profiles'
    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False)
    viewed_products = db.relationship('Product', secondary='user_profile_viewed_products')

class Cart(db.Model):
    __tablename__ = 'cart'
    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False)
    product_id = db.Column(db.BigInteger, db.ForeignKey('products.id'), nullable=False)
    quantity = db.Column(db.Integer, default=1)
    product = db.relationship('Product')

user_profile_viewed_products = db.Table(
    'user_profile_viewed_products',
    db.Column('id', db.BigInteger, primary_key=True),
    db.Column('user_profile_id', db.BigInteger, db.ForeignKey('user_profiles.id'), nullable=False),
    db.Column('product_id', db.BigInteger, db.ForeignKey('products.id'), nullable=False)
)