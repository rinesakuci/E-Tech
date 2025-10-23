from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from models import User, Product, Category, Subcategory, UserProfile, Cart, db
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+mysqlconnector://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}/{os.getenv('DB_NAME')}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = 'static/uploads'

os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

db.init_app(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return db.session.get(User, int(user_id))

def get_recommendations(user=None):
    if not user:
        return Product.query.order_by(db.func.rand()).limit(5).all()

    profile = UserProfile.query.filter_by(user_id=user.id).first()
    if not profile or not profile.viewed_products:
        return Product.query.order_by(db.func.rand()).limit(5).all()

    all_products = Product.query.all()
    if not all_products:
        return []

    vectorizer = TfidfVectorizer()
    product_vectors = vectorizer.fit_transform([p.description + ' ' + (p.tags or '') for p in all_products])
    viewed_indices = [all_products.index(p) for p in profile.viewed_products if p in all_products]
    if not viewed_indices:
        return Product.query.order_by(db.func.rand()).limit(5).all()
    viewed_vectors = [product_vectors[i].toarray()[0] for i in viewed_indices]
    user_vector = np.mean(viewed_vectors, axis=0)
    content_sim = cosine_similarity([user_vector], product_vectors.toarray())[0]

    all_profiles = UserProfile.query.all()
    user_viewed_set = set(p.id for p in profile.viewed_products)
    collab_scores = np.zeros(len(all_products))
    for other_profile in all_profiles:
        if other_profile.user_id == user.id:
            continue
        other_viewed_set = set(p.id for p in other_profile.viewed_products)
        common = len(user_viewed_set & other_viewed_set)
        if common > 0:
            for p in other_profile.viewed_products:
                if p.id not in user_viewed_set:
                    collab_scores[all_products.index(p)] += common

    hybrid_scores = (content_sim + collab_scores) / 2
    recommended_indices = hybrid_scores.argsort()[-6:-1][::-1]
    return [all_products[i] for i in recommended_indices if all_products[i] not in profile.viewed_products]

@app.context_processor
def inject_categories():
    return dict(categories=Category.query.all())

@app.route('/')
def home():
    products = Product.query.all()
    recommendations = get_recommendations(current_user if current_user.is_authenticated else None)
    return render_template('home.html', recommendations=recommendations, products=products)

@app.route('/category/<cat>')
def category(cat):
    category_obj = Category.query.filter_by(name=cat.replace('-', ' ').title()).first()
    if not category_obj:
        flash('Kategoria nuk ekziston!', 'danger')
        return redirect(url_for('home'))
    subcategories = category_obj.subcategories
    products = [p for sub in subcategories for p in sub.products]
    recommendations = get_recommendations(current_user if current_user.is_authenticated else None)
    return render_template('home.html', products=products, recommendations=recommendations)

@app.route('/subcategory/<subcat>')
def subcategory(subcat):
    subcategory_obj = Subcategory.query.filter_by(name=subcat.replace('-', ' ').title()).first()
    if not subcategory_obj:
        flash('Nën-kategoria nuk ekziston!', 'danger')
        return redirect(url_for('home'))
    products = subcategory_obj.products
    recommendations = get_recommendations(current_user if current_user.is_authenticated else None)
    return render_template('home.html', products=products, recommendations=recommendations)

@app.route('/search', methods=['GET'])
def search():
    query = request.args.get('q', '')
    products = Product.query.filter(
        (Product.name.ilike(f'%{query}%')) |
        (Product.description.ilike(f'%{query}%')) |
        (Product.tags.ilike(f'%{query}%'))
    ).all()
    recommendations = get_recommendations(current_user if current_user.is_authenticated else None)
    return render_template('home.html', products=products, recommendations=recommendations)

@app.route('/product/<int:product_id>')
def product_detail(product_id):
    product = Product.query.get_or_404(product_id)
    if current_user.is_authenticated:
        profile = UserProfile.query.filter_by(user_id=current_user.id).first()
        if profile and product not in profile.viewed_products:
            profile.viewed_products.append(product)
            db.session.commit()
    return render_template('product_detail.html', product=product)

@app.route('/cart/add/<int:product_id>', methods=['POST'])
@login_required
def add_to_cart(product_id):
    product = Product.query.get_or_404(product_id)
    cart_item = Cart.query.filter_by(user_id=current_user.id, product_id=product_id).first()
    if cart_item:
        cart_item.quantity += 1
    else:
        cart_item = Cart(user_id=current_user.id, product_id=product_id)
        db.session.add(cart_item)
    db.session.commit()
    flash('Produkti u shtua në karrocë!', 'success')
    return redirect(url_for('product_detail', product_id=product_id))

@app.route('/cart')
@login_required
def cart():
    cart_items = Cart.query.filter_by(user_id=current_user.id).all()
    total = sum(item.product.price * item.quantity for item in cart_items)
    return render_template('cart.html', cart_items=cart_items, total=total)

@app.route('/cart/remove/<int:cart_id>')
@login_required
def remove_from_cart(cart_id):
    cart_item = Cart.query.get_or_404(cart_id)
    if cart_item.user_id == current_user.id:
        db.session.delete(cart_item)
        db.session.commit()
        flash('Produkti u hoq nga karroca!', 'success')
    return redirect(url_for('cart'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = User.query.filter_by(email=email).first()
        if user is None:
            flash('Email-i nuk ekziston!', 'danger')
        elif not check_password_hash(user.password, password):
            flash('Fjalëkalimi është i gabuar!', 'danger')
        else:
            login_user(user)
            return redirect(url_for('home'))
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        if User.query.filter_by(username=username).first():
            flash('Përdoruesi ekziston!', 'danger')
            return render_template('register.html')
        if User.query.filter_by(email=email).first():
            flash('Email-i ekziston!', 'danger')
            return render_template('register.html')
        user = User(username=username, password=generate_password_hash(password, method='pbkdf2:sha256'), email=email, is_admin=False)
        db.session.add(user)
        db.session.commit()
        profile = UserProfile(user_id=user.id)
        db.session.add(profile)
        db.session.commit()
        login_user(user)
        flash('Regjistrimi u krye me sukses!', 'success')
        return redirect(url_for('home'))
    return render_template('register.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('U shkëputët me sukses!', 'success')
    return redirect(url_for('home'))

@app.route('/admin/')
@login_required
def admin_panel():
    if not current_user.is_admin:
        flash('Ju nuk keni akses si admin!', 'danger')
        return redirect(url_for('home'))
    products = Product.query.all()
    users = User.query.all()
    categories = Category.query.all()
    subcategories = Subcategory.query.all()
    return render_template('admin.html', products=products, users=users, categories=categories, subcategories=subcategories)

@app.route('/admin/make_admin/<int:user_id>', methods=['POST'])
@login_required
def make_admin(user_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses për të bërë ndryshime!', 'danger')
        return redirect(url_for('admin_panel'))
    user = User.query.get_or_404(user_id)
    user.is_admin = True
    db.session.commit()
    flash(f'{user.username} u bë admin me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/add_user', methods=['POST'])
@login_required
def add_user():
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    username = request.form['username']
    email = request.form['email']
    password = request.form['password']
    is_admin = 'is_admin' in request.form
    if User.query.filter_by(username=username).first():
        flash('Përdoruesi ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    if User.query.filter_by(email=email).first():
        flash('Email-i ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    user = User(username=username, password=generate_password_hash(password, method='pbkdf2:sha256'), email=email, is_admin=is_admin)
    db.session.add(user)
    db.session.commit()
    profile = UserProfile(user_id=user.id)
    db.session.add(profile)
    db.session.commit()
    flash('Përdoruesi u shtua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/edit_user/<int:user_id>', methods=['POST'])
@login_required
def edit_user(user_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    user = User.query.get_or_404(user_id)
    user.username = request.form['username']
    user.email = request.form['email']
    if request.form['password']:
        user.password = generate_password_hash(request.form['password'], method='pbkdf2:sha256')
    user.is_admin = 'is_admin' in request.form
    db.session.commit()
    flash('Përdoruesi u ndryshua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_user/<int:user_id>', methods=['POST'])
@login_required
def delete_user(user_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('admin_panel'))
    user = User.query.get_or_404(user_id)
    if user.id == current_user.id:
        flash('Nuk mund të fshish veten!', 'danger')
        return redirect(url_for('admin_panel'))
    db.session.delete(user)
    db.session.commit()
    flash('Përdoruesi u fshi me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/add_product', methods=['POST'])
@login_required
def add_product():
    if not current_user.is_admin:
        flash('Ju nuk keni akses si admin!', 'danger')
        return redirect(url_for('home'))
    name = request.form['name']
    description = request.form['description']
    subcategory_name = request.form['subcategory']
    price = request.form['price']
    tags = request.form['tags']

    subcategory = Subcategory.query.filter_by(name=subcategory_name).first()
    if not subcategory:
        flash('Nën-kategoria nuk ekziston!', 'danger')
        return redirect(url_for('admin_panel'))

    image_filename = None
    if 'image' in request.files:
        file = request.files['image']
        if file and file.filename:
            image_filename = secure_filename(file.filename)
            file.save(os.path.join(app.root_path, app.config['UPLOAD_FOLDER'], image_filename))

    product = Product(name=name, description=description, subcategory_id=subcategory.id, price=price, tags=tags, image_filename=image_filename)
    db.session.add(product)
    db.session.commit()
    flash('Produkti u shtua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/edit_product/<int:product_id>', methods=['POST'])
@login_required
def edit_product(product_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    product = Product.query.get_or_404(product_id)
    product.name = request.form['name']
    product.description = request.form['description']
    subcategory_name = request.form['subcategory']
    subcategory = Subcategory.query.filter_by(name=subcategory_name).first()
    if not subcategory:
        flash('Nën-kategoria nuk ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    product.subcategory_id = subcategory.id
    product.price = request.form['price']
    product.tags = request.form['tags']

    if 'image' in request.files:
        file = request.files['image']
        if file and file.filename:
            product.image_filename = secure_filename(file.filename)
            file.save(os.path.join(app.root_path, app.config['UPLOAD_FOLDER'], product.image_filename))

    db.session.commit()
    flash('Produkti u ndryshua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_product/<int:product_id>', methods=['POST'])
@login_required
def delete_product(product_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    product = Product.query.get_or_404(product_id)
    db.session.delete(product)
    db.session.commit()
    flash('Produkti u fshi me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/add_category', methods=['POST'])
@login_required
def add_category():
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    name = request.form['name']
    if Category.query.filter_by(name=name).first():
        flash('Kategoria ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    category = Category(name=name)
    db.session.add(category)
    db.session.commit()
    flash('Kategoria u shtua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/edit_category/<int:category_id>', methods=['POST'])
@login_required
def edit_category(category_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    category = Category.query.get_or_404(category_id)
    category.name = request.form['name']
    db.session.commit()
    flash('Kategoria u ndryshua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_category/<int:category_id>', methods=['POST'])
@login_required
def delete_category(category_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    category = Category.query.get_or_404(category_id)
    if Subcategory.query.filter_by(category_id=category_id).first():
        flash('Kategoria ka nën-kategori të lidhura! Fshi ato së pari.', 'danger')
        return redirect(url_for('admin_panel'))
    db.session.delete(category)
    db.session.commit()
    flash('Kategoria u fshi me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/add_subcategory', methods=['POST'])
@login_required
def add_subcategory():
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    name = request.form['name']
    category_name = request.form['category']
    if Subcategory.query.filter_by(name=name).first():
        flash('Nën-kategoria ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    category = Category.query.filter_by(name=category_name).first()
    if not category:
        flash('Kategoria kryesore nuk ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    subcategory = Subcategory(name=name, category_id=category.id)
    db.session.add(subcategory)
    db.session.commit()
    flash('Nën-kategoria u shtua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/edit_subcategory/<int:subcategory_id>', methods=['POST'])
@login_required
def edit_subcategory(subcategory_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    subcategory = Subcategory.query.get_or_404(subcategory_id)
    subcategory.name = request.form['name']
    category_name = request.form['category']
    category = Category.query.filter_by(name=category_name).first()
    if not category:
        flash('Kategoria kryesore nuk ekziston!', 'danger')
        return redirect(url_for('admin_panel'))
    subcategory.category_id = category.id
    db.session.commit()
    flash('Nën-kategoria u ndryshua me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_subcategory/<int:subcategory_id>', methods=['POST'])
@login_required
def delete_subcategory(subcategory_id):
    if not current_user.is_admin:
        flash('Ju nuk keni akses!', 'danger')
        return redirect(url_for('home'))
    subcategory = Subcategory.query.get_or_404(subcategory_id)
    if Product.query.filter_by(subcategory_id=subcategory_id).first():
        flash('Nën-kategoria ka produkte të lidhura! Fshi ato së pari.', 'danger')
        return redirect(url_for('admin_panel'))
    db.session.delete(subcategory)
    db.session.commit()
    flash('Nën-kategoria u fshi me sukses!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/recommendations')
@login_required
def recommendations():
    recs = get_recommendations(current_user)
    return render_template('recommendations_partial.html', recommendations=recs)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)