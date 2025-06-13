from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ConversationHandler, ContextTypes
import sqlite3
import datetime
import os

# DB setup
conn = sqlite3.connect("users.db", check_same_thread=False)
cursor = conn.cursor()
cursor.execute("""CREATE TABLE IF NOT EXISTS users (
    username TEXT,
    password TEXT,
    duration INTEGER,
    device_limit INTEGER,
    start_date TEXT,
    is_running INTEGER DEFAULT 0
)""")
conn.commit()

# Admin ID
ADMIN_ID = 7848399218  # Replace with your Telegram user ID

# States
USERNAME, PASSWORD, DURATION, DEVICE_LIMIT = range(4)

# /start command
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != ADMIN_ID:
        await update.message.reply_text("Unauthorized.")
        return
    cursor.execute("SELECT * FROM users")
    accounts = cursor.fetchall()
    if not accounts:
        await update.message.reply_text("No users found.")
        return
    msg = "👤 User Accounts:\n\n"
    for u in accounts:
        status = "🟢 Running" if u[5] else "🔴 Not Running"
        msg += f"• `{u[0]}` / `{u[1]}` | ⏳ {u[2]}d | 📱 {u[3]} | {status}\n"
    await update.message.reply_text(msg, parse_mode="Markdown")

# /create_new
async def create_new(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != ADMIN_ID:
        await update.message.reply_text("Unauthorized.")
        return ConversationHandler.END
    await update.message.reply_text("Enter new username:")
    return USERNAME

async def get_username(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["username"] = update.message.text
    await update.message.reply_text("Enter password:")
    return PASSWORD

async def get_password(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["password"] = update.message.text
    await update.message.reply_text("Enter duration (days):")
    return DURATION

async def get_duration(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["duration"] = int(update.message.text)
    await update.message.reply_text("Enter device limit:")
    return DEVICE_LIMIT

async def get_device_limit(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["device_limit"] = int(update.message.text)
    cursor.execute("INSERT INTO users VALUES (?, ?, ?, ?, ?, 0)", (
        context.user_data["username"],
        context.user_data["password"],
        context.user_data["duration"],
        context.user_data["device_limit"],
        datetime.datetime.now().strftime("%Y-%m-%d")
    ))
    conn.commit()
    await update.message.reply_text("✅ Account created!")
    return ConversationHandler.END

async def cancel(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Cancelled.")
    return ConversationHandler.END

# Flask API
from flask import Flask, request
import threading

api = Flask(__name__)

@api.route("/auth", methods=["POST"])
def auth():
    data = request.json
    username = data.get("username")
    password = data.get("password")
    cursor.execute("SELECT * FROM users WHERE username=? AND password=?", (username, password))
    user = cursor.fetchone()
    if user:
        cursor.execute("UPDATE users SET is_running=1 WHERE username=?", (username,))
        conn.commit()
        return {"status": "success"}, 200
    return {"status": "fail"}, 401

def run_api():
    api.run(host="0.0.0.0", port=5000)

# Start bot + API
if __name__ == "__main__":
    threading.Thread(target=run_api).start()
    app = Application.builder().token(os.getenv("7483922524:AAHEgbnUh-A9ZoAORbCLANNlvBKbh7nlmSw")).build()
    conv_handler = ConversationHandler(
        entry_points=[CommandHandler("create_new", create_new)],
        states={
            USERNAME: [MessageHandler(filters.TEXT & ~filters.COMMAND, get_username)],
            PASSWORD: [MessageHandler(filters.TEXT & ~filters.COMMAND, get_password)],
            DURATION: [MessageHandler(filters.TEXT & ~filters.COMMAND, get_duration)],
            DEVICE_LIMIT: [MessageHandler(filters.TEXT & ~filters.COMMAND, get_device_limit)],
        },
        fallbacks=[CommandHandler("cancel", cancel)],
    )
    app.add_handler(CommandHandler("start", start))
    app.add_handler(conv_handler)
    app.run_polling()
