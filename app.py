from flask import session, flash
from flask import Flask, request, jsonify, render_template, redirect, url_for, Response
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import io
import csv
import json
from datetime import datetime, timedelta

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
db = SQLAlchemy(app)
app.secret_key = '123'  # Replace this in production

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    max_devices = db.Column(db.Integer, default=1)
    expiration = db.Column(db.DateTime, nullable=True)

class Device(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), nullable=False)
    device_id = db.Column(db.String(128), nullable=False)

@app.route('/')
def dashboard():
    if not session.get('admin'):
        return redirect(url_for('login'))
    users = User.query.all()
    devices = Device.query.all()

    device_counts = {}
    for device in devices:
        if device.username in device_counts:
            device_counts[device.username].add(device.device_id)
        else:
            device_counts[device.username] = {device.device_id}

    user_device_stats = {u.username: len(device_counts.get(u.username, set())) for u in users}

    return render_template('dashboard.html', users=users, devices=user_device_stats)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if request.form['username'] == 'admin' and request.form['password'] == 'admin123':
            session['admin'] = True
            return redirect(url_for('dashboard'))
        else:
            flash("Invalid login")
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('admin', None)
    return redirect(url_for('login'))
    
@app.route('/add', methods=['POST'])
def add_user():
    if not session.get('admin'):
        return redirect(url_for('login'))
    u = request.form['username'].strip()
    p = request.form['password'].strip()
    dlimit = int(request.form['device_limit'])
    duration = int(request.form['duration'])
    duration_type = request.form['duration_type']

    if not u or not p:
        return redirect(url_for('dashboard'))

    pw_hash = generate_password_hash(p)

    # Calculate expiration datetime
    now = datetime.now()
    if duration_type == 'minutes':
        exp = now + timedelta(minutes=duration)
    elif duration_type == 'hours':
        exp = now + timedelta(hours=duration)
    else:
        exp = now + timedelta(days=duration)

    db.session.add(User(username=u, password_hash=pw_hash, max_devices=dlimit, expiration=exp))
    db.session.commit()
    return redirect(url_for('dashboard'))

@app.route('/api/verify', methods=['POST'])
def api_verify():
    data = request.json
    u = data.get('username', '')
    p = data.get('password', '')
    device_id = data.get('device_id', '')

    user = User.query.filter_by(username=u).first()

    if not user or not check_password_hash(user.password_hash, p):
        return jsonify(result="FAIL"), 401

    if user.expiration and datetime.now() > user.expiration:
        return jsonify(result="EXPIRED"), 403

    # Check existing unique devices
    existing_devices = Device.query.filter_by(username=u).all()
    unique_ids = set([d.device_id for d in existing_devices])

    if device_id not in unique_ids:
        if len(unique_ids) >= user.max_devices:
            return jsonify(result="DEVICE_LIMIT_REACHED"), 403
        db.session.add(Device(username=u, device_id=device_id))
        db.session.commit()

    return jsonify(result="OK", expiration=str(user.expiration))

@app.route('/export/csv')
def export_csv():
    if not session.get('admin'):
        return redirect(url_for('login'))
    users = User.query.all()
    device_counts = {}
    for d in Device.query.all():
        if d.username not in device_counts:
            device_counts[d.username] = set()
        device_counts[d.username].add(d.device_id)

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(['username', 'expiration', 'max_devices', 'current_devices'])

    for u in users:
        writer.writerow([u.username, u.expiration, u.max_devices, len(device_counts.get(u.username, set()))])

    output.seek(0)
    return Response(output, mimetype='text/csv',
                    headers={"Content-Disposition": "attachment;filename=users.csv"})

@app.route('/delete/<username>', methods=['POST'])
def delete_user(username):
    if not session.get('admin'):
        return redirect(url_for('login'))
    user = User.query.filter_by(username=username).first()
    if user:
        Device.query.filter_by(username=username).delete()  # Remove all devices
        db.session.delete(user)
        db.session.commit()
    return redirect(url_for('dashboard'))

@app.route('/edit/<username>', methods=['POST'])
def edit_user(username):
    if not session.get('admin'):
        return redirect(url_for('login'))
    user = User.query.filter_by(username=username).first()
    if user:
        new_limit = int(request.form['max_devices'])
        user.max_devices = new_limit

        exp = request.form.get('expiration')
        if exp:
            from datetime import datetime
            try:
                user.expiration = datetime.strptime(exp, '%Y-%m-%dT%H:%M')
            except ValueError:
                pass  # Ignore bad input

        db.session.commit()
    return redirect(url_for('dashboard'))
        
@app.route('/export/json')
def export_json():
    if not session.get('admin'):
        return redirect(url_for('login'))
    users = User.query.all()
    device_counts = {}
    for d in Device.query.all():
        if d.username not in device_counts:
            device_counts[d.username] = set()
        device_counts[d.username].add(d.device_id)

    data = []
    for u in users:
        data.append({
            'username': u.username,
            'expiration': str(u.expiration),
            'max_devices': u.max_devices,
            'current_devices': len(device_counts.get(u.username, set()))
        })

    return jsonify(data)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000)