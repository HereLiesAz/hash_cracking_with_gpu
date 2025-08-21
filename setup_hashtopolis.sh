#!/bin/bash
#
# Setup script for Hashtopolis on a Debian-based system (like Ubuntu).
# This script automates the installation of Hashtopolis using the recommended Docker method.
#
# USAGE:
#   1. Save this script as, for example, 'setup_hashtopolis.sh'
#   2. Make it executable: chmod +x setup_hashtopolis.sh
#   3. Run it: ./setup_hashtopolis.sh
#
set -euo pipefail

echo "===== Starting Hashtopolis Setup Script ====="

# --- 1. System Update and Dependency Installation ---
echo "➡️ [1/5] Updating package lists and installing dependencies (curl, git)..."
sudo apt-get update
sudo apt-get install -y curl git

# --- 2. Docker Installation ---
echo "➡️ [2/5] Checking and installing Docker Engine..."
if ! command -v docker &> /dev/null; then
    echo "   Docker not found. Installing via official script..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo "   ✅ Docker installed successfully."
else
    echo "   ✅ Docker is already installed."
fi

# --- 3. Grant Docker permissions to the current user ---
echo "➡️ [3/5] Configuring Docker permissions..."
if ! groups ${USER} | grep -q '\bdocker\b'; then
    echo "   Adding current user ('${USER}') to the 'docker' group..."
    sudo usermod -aG docker ${USER}
    echo "   ✅ User added to 'docker' group."
    echo "   ⚠️  IMPORTANT: You must start a new shell session (or log out/in) for this change to take effect."
    echo "      You can try running 'newgrp docker' in your terminal to apply the new group immediately."
else
    echo "   ✅ User '${USER}' is already in the 'docker' group."
fi

# --- 4. Download and Configure Hashtopolis ---
echo "➡️ [4/5] Downloading Hashtopolis Docker configuration..."
HASHTOPOLIS_DIR="$HOME/hashtopolis-docker"
echo "   Creating directory: $HASHTOPOLIS_DIR"
mkdir -p "$HASHTOPOLIS_DIR"

echo "   Downloading docker-compose.yml and .env files..."
wget -q --show-progress -O "$HASHTOPOLIS_DIR/docker-compose.yml" https://raw.githubusercontent.com/hashtopolis/server/master/docker-compose.yml
wget -q --show-progress -O "$HASHTOPOLIS_DIR/.env" https://raw.githubusercontent.com/hashtopolis/server/master/env.example

echo "   ✅ Hashtopolis configuration files are ready in $HASHTOPOLIS_DIR"

# --- 5. Final Instructions ---
echo "➡️ [5/5] Final Instructions"
echo ""
echo "   ===== ✅ SETUP IS COMPLETE! =====   "
echo ""
echo "   NEXT STEPS:"
echo "   -----------"
echo "   1. ⚠️  Start a new terminal session for Docker group permissions to apply."
echo "   2. Navigate to the Hashtopolis directory:"
echo "      cd $HASHTOPOLIS_DIR"
echo ""
echo "   3. Start the server (it will download the necessary images):"
echo "      docker compose up -d"
echo ""
echo "   4. Access the Hashtopolis web UI:"
echo "      - URL: http://localhost:8080"
echo "      - Default Username: admin"
echo "      - Default Password: hashtopolis (you should change this in the .env file!)"
echo ""
echo "   To stop the server, run 'docker compose down' in the same directory."
ech
