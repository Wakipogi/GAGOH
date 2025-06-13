import json
import os
from flask import Flask, request, jsonify
from threading import Thread
from telegram import Update
from telegram.ext import (
    ApplicationBuilder, CommandHandler, ConversationHandler,
    MessageHandler, filters, ContextTypes
)

# Replace these before deploying
BOT_TOKEN = "7483922524:AAHEgbnUh-A9ZoAORbCLANNlvBKbh7nlmSw"
ADMIN_ID = 7848399218

DATA_FILE = "users.json"
app = Flask(__name__)

# Make sure users.json exists
if not os.path.exists(DATA_FILE):
    with open(DATA_FILE, "w") as f:
        json.dump([], f)

def load_users():
    with open(DATA_FILE, "r") as f:
        return json.load(f)

def save_users(users):
    with open(DATA_FILE, "w") as f:
        json.dump(users, f, indent=2)

# === Telegram Bot Handlers === #
USERNAME, PASSWORD, DURATION, DEVICE_LIMIT = range(4)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != ADMIN_ID:
        await update.message.reply_text("Access denied.")
        return

    users = load_users()
    if not users:
        await update.message.reply_text("No users found.")
        return

    message = "📋 *User Panel List:*\n\n"
for user in users:
    message += (
        f"👤 `{user['username']}`\n"
        f"🔑 Pass: `{user['password']}`\n"
        f"🕒 Duration: {user['duration']} days\n"
        f"📱 Device Limit: {user['device_limit']}\n"
        f"🔄 Status: *{user['status']}*\n\n"
    )
    await update.message.reply_markdown(message)

async def create_new(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != ADMIN_ID:
        await update.message.reply_text("Access denied.")
        return ConversationHandler.END

    await update.message.reply_text("Enter new username:")
    return USERNAME

async def get_username(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["username"] = update.message.text
    await update.message.reply_text("Enter password:")
    return PASSWORD

async def get_password(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["password"] = update.message.text
    await update.message.reply_text("Enter duration (in days):")
    return DURATION

async def get_duration(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["duration"] = int(update.message.text)
    await update.message.reply_text("Enter device limit:")
    return DEVICE_LIMIT

async def get_device_limit(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data["device_limit"] = int(update.message.text)
    user = {
        "username": context.user_data["username"],
        "password": context.user_data["password"],
        "duration": context.user_data["duration"],
        "device_limit": context.user_data["device_limit"],
        "status": "not running"
    }
    users = load_users()
    users.append(user)
    save_users(users)
    await update.message.reply_text("✅ User created and saved.")
    return ConversationHandler.END

async def cancel(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("❌ Cancelled.")
    return ConversationHandler.END

# === Flask Webhook for Login === #
@app.route("/login_event", methods=["POST"])
def login_event():
    data = request.json
    username = data.get("username")
    if not username:
        return jsonify({"error": "username missing"}), 400

    users = load_users()
    found = False
    for user in users:
        if user["username"] == username:
            user["status"] = "running"
            found = True
            break

    if found:
        save_users(users)
        return jsonify({"status": "updated"}), 200
    else:
        return jsonify({"error": "user not found"}), 404

# === Combine Flask + Telegram === #
def run_flask():
    app.run(host="0.0.0.0", port=8080)

def main():
    # Start Flask in a separate thread
    thread = Thread(target=run_flask)
    thread.start()

    # Start Telegram Bot
    app_bot = ApplicationBuilder().token(BOT_TOKEN).build()

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

    app_bot.add_handler(CommandHandler("start", start))
    app_bot.add_handler(conv_handler)
    app_bot.run_polling()

if __name__ == "__main__":
    main()
