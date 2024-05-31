import os
import requests
import pyqrcode

def upload_to_catbox(file_path):
    url = "https://litterbox.catbox.moe/resources/internals/api.php"
    with open(file_path, 'rb') as f:
        files = {
            'fileToUpload': f,
            'time': (None, '12h'),
            'reqtype': (None, 'fileupload')
        }
        response = requests.post(url, files=files)
    return response.text.strip()

def upload_to_fileio(file_path):
    url = "https://file.io"
    with open(file_path, 'rb') as f:
        response = requests.post(url, files={'file': f}).json()
    if response["success"]:
        return response["link"]
    return None

def send_telegram_message(token, chat_id, message, image_path):
    send_message_url = f"https://api.telegram.org/bot{token}/sendPhoto"
    with open(image_path, 'rb') as photo:
        files = {'photo': photo}
        data = {
            'chat_id': chat_id,
            'caption': message,
            'parse_mode': 'MarkdownV2'
        }
        response = requests.post(send_message_url, files=files, data=data)
    return response.json()

def main():
    file_path = "Infinity.apk"
    telegram_token = os.getenv("TELEGRAM_TOKEN")
    telegram_chat_id = os.getenv("TELEGRAM_CHAT_ID")

    # Upload APK
    catbox_url = upload_to_catbox(file_path)
    fileio_url = upload_to_fileio(file_path)

    # Generate QR codes
    catbox_qr = pyqrcode.create(catbox_url)
    catbox_qr_image_path = "catbox_qr.png"
    catbox_qr.png(catbox_qr_image_path, scale=10)

    fileio_qr = pyqrcode.create(fileio_url)
    fileio_qr_image_path = "fileio_qr.png"
    fileio_qr.png(fileio_qr_image_path, scale=10)

    # Send URLs and QR codes via Telegram
    catbox_message = f"Download URL (Catbox): [{catbox_url}]({catbox_url})"
    send_telegram_message(telegram_token, telegram_chat_id, catbox_message, catbox_qr_image_path)

    fileio_message = f"Download URL (File.io): [{fileio_url}]({fileio_url})"
    send_telegram_message(telegram_token, telegram_chat_id, fileio_message, fileio_qr_image_path)

    print("Upload and notification completed.")

if __name__ == "__main__":
    main()
