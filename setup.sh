#!/bin/bash

clear

echo "======================================"
echo "      Mini Projects Collection"
echo "======================================"
echo
echo "1. JSON REST"
echo "2. FS REST"
echo "3. Mongoose REST"
echo "4. wanderLust"
echo

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        PROJECT="json-rest"
        PORT=8080
        ;;
    2)
        PROJECT="fs-rest"
        PORT=8080
        ;;
    3)
        PROJECT="mongoose-rest"
        PORT=8080
        ;;
    4)
        PROJECT="wanderLust"
        PORT=8080
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

# Check MongoDB only for MongoDB-based projects
if [[ "$PROJECT" == "mongoose-rest" || "$PROJECT" == "wanderLust" ]]; then
    echo
    echo "Checking MongoDB..."

    if ! command -v mongod >/dev/null 2>&1; then
        echo "MongoDB is not installed."
        echo "Download it from:"
        echo "https://www.mongodb.com/try/download/community"
        exit 1
    fi

    if ! nc -z localhost 27017 >/dev/null 2>&1; then
        echo "MongoDB is installed but not running."

        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Run: brew services start mongodb-community"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "Run: sudo systemctl start mongod"
        elif command -v powershell.exe >/dev/null 2>&1; then
            echo "Run (PowerShell as Administrator): net start MongoDB"
        fi

        exit 1
    fi

    echo "MongoDB is running."
fi

cd "$PROJECT" || exit 1

echo
echo "Installing dependencies..."
npm install

echo
echo "Starting server..."

if [[ "$PROJECT" == "wanderLust" ]]; then
    node index.js &
else
    node index.js &
fi

SERVER_PID=$!

until curl -s "http://localhost:$PORT" >/dev/null; do
    sleep 1
done

URL="http://localhost:$PORT"

if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$URL"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$URL"
elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe Start-Process "$URL"
elif command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /c start "$URL"
fi

wait $SERVER_PID
