from flask import Flask, render_template, request, redirect, jsonify
import sqlite3
from datetime import datetime, timedelta
from hashlib import sha256

app = Flask(__name__)

def init_db():
    with sqlite3.connect("database.db") as db:
        db.execute('''CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            duration INTEGER,
            created_at TEXT,
            activated_at TEXT,
            device_id TEXT,
            device_limit INTEGER
        )''')

@app.route("/")
def index():
    with sqlite3.connect("database.db") as db:
        cur = db.execute("SELECT * FROM users")
        users = cur.fetchall()
    return render_template("index.html", users=users, datetime=datetime, timedelta=timedelta)

@app.route("/add_user", methods=["POST"])
def add_user():
    data = request.form
    username = data["username"]
    password = sha256(data["password"].encode()).hexdigest()
    duration = int(data["duration"])
    limit = int(data["limit"])

    with sqlite3.connect("database.db") as db:
        db.execute("INSERT INTO users (username, password, duration, created_at, device_limit) VALUES (?, ?, ?, ?, ?)", 
                   (username, password, duration, datetime.utcnow().isoformat(), limit))
    return redirect("/")

@app.route("/api/login", methods=["POST"])
def api_login():
    data = request.json
    username = data.get("username")
    password = sha256(data.get("password").encode()).hexdigest()
    device_id = data.get("device_id")

    with sqlite3.connect("database.db") as db:
        user = db.execute("SELECT * FROM users WHERE username = ? AND password = ?", (username, password)).fetchone()
        if not user:
            return jsonify({"success": False, "error": "Invalid credentials"})

        if user[5] is None:
            db.execute("UPDATE users SET activated_at = ?, device_id = ? WHERE id = ?", (datetime.utcnow().isoformat(), device_id, user[0]))
        elif user[6] != device_id:
            return jsonify({"success": False, "error": "Device limit reached or unauthorized device"})

        activated_at = datetime.fromisoformat(user[5] or datetime.utcnow().isoformat())
        expires_at = activated_at + timedelta(days=user[3])
        if datetime.utcnow() > expires_at:
            return jsonify({"success": False, "error": "Account expired"})

        return jsonify({"success": True})

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=3000)