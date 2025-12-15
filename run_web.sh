#!/bin/bash

# Default port
PORT=8080

# Allow passing a custom port
if [ -n "$1" ]; then
  PORT=$1
fi

echo "Building and running for Web in Release Mode on port $PORT..."
echo "Note: Hot Reload is DISABLED in release mode."
echo "Use Ctrl+C to stop the server."

flutter run -d chrome --web-port=$PORT --release
