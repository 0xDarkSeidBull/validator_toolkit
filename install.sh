#!/usr/bin/env bash
set -e

clear

# ========= BANNER =========
echo -e "\n"
echo -e "██████╗ ██╗  ██╗██████╗  █████╗ ██████╗ ██╗  ██╗"
echo -e "██╔═██╗╚██╗██╔╝██╔══██╗██╔══██╗██╔══██╗██║  ██║"
echo -e "██████╔╝ ╚███╔╝ ██║  ██║███████║██████╔╝███████║"
echo -e "██╔═══╝  ██╔██╗ ██║  ██║██╔══██║██╔══██╗██╔══██║"
echo -e "██║     ██╔╝ ██╗██████╔╝██║  ██║██║  ██║██║  ██║"
echo -e "╚═╝     ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "\n"
echo -e "        🔥 0xDarkSeidBull Validator Toolkit 🔥"
echo -e "------------------------------------------------\n"

# ========= OPTIONS =========
echo "Choose installation mode:"
echo ""
echo "1) 🚀 Run Automatically (Recommended)"
echo "2) 🛠️  Run Manually (Drop to root shell)"
echo ""

read -rp "Enter your choice [1/2]: " choice

case "$choice" in
  1)
    echo -e "\n🚀 Starting Automatic Installation...\n"
    sleep 1
    ;;
  2)
    echo -e "\n🛠️ Manual mode selected."
    echo "You are now in root shell. Run commands manually."
    echo ""
    exec bash
    ;;
  *)
    echo "❌ Invalid choice. Exiting."
    exit 1
    ;;
esac

# ========= AUTO INSTALL START =========
echo "🔧 Updating system..."
apt update -y && apt upgrade -y

echo "📦 Installing dependencies..."
apt install -y curl wget git build-essential pkg-config libssl-dev jq unzip

echo "🐳 Installing Docker..."
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | bash
  systemctl enable docker
  systemctl start docker
fi

echo "🦀 Installing Rust..."
if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source $HOME/.cargo/env
fi

echo "📥 Cloning repository..."
cd $HOME
git clone https://github.com/0xDarkSeidBull/validator_toolkit.git
cd validator_toolkit

echo "⚙️ Building project..."
cargo build --release

echo -e "\n✅ Installation Completed Successfully!"
echo "👑 Built by 0xDarkSeidBull"
