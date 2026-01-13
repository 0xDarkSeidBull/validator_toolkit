#!/usr/bin/env bash
set -e

clear

# ========= BANNER =========
cat << "EOF"
  .oooo.               oooooooooo.                      oooo         .oooooo..o            o8o        .o8  oooooooooo.              oooo  oooo  
 d8P'`Y8b              `888'   `Y8b                     `888        d8P'    `Y8            `"'       "888  `888'   `Y8b             `888  `888  
888    888 oooo    ooo  888      888  .oooo.   oooo d8b  888  oooo  Y88bo.       .ooooo.  oooo   .oooo888   888     888 oooo  oooo   888   888  
888    888  `88b..8P'   888      888 `P  )88b  `888""8P  888 .8P'    `"Y8888o.  d88' `88b `888  d88' `888   888oooo888' `888  `888   888   888  
888    888    Y888'     888      888  .oP"888   888      888888.         `"Y88b 888ooo888  888  888   888   888    `88b  888   888   888   888  
`88b  d88'  .o8"'88b    888     d88' d8(  888   888      888 `88b.  oo     .d8P 888    .o  888  888   888   888    .88P  888   888   888   888  
 `Y8bd8P'  o88'   888o o888bood8P'   `Y888""8o d888b    o888o o888o 8""88888P'  `Y8bod8P' o888o `Y8bod88P" o888bood8P'   `V88V"V8P' o888o o888o 

🔥 0xDarkSeidBull Validator Toolkit 🔥
Tempo Validator – One Line Installer
------------------------------------------------
EOF

echo ""
echo "Choose installation mode:"
echo ""
echo "1) 🚀 Run Automatically (Recommended)"
echo "2) 🛠️  Run Manually (Drop to root shell)"
echo ""

# ========= FORCE REAL USER INPUT =========
while true; do
  read -rp "Enter your choice [1/2]: " choice < /dev/tty
  case "$choice" in
    1) MODE="auto"; break ;;
    2) MODE="manual"; break ;;
    *) echo "❌ Invalid choice. Please enter 1 or 2." ;;
  esac
done

# ========= MODE HANDLING =========
if [ "$MODE" = "manual" ]; then
  echo -e "\n🛠️ Manual mode selected."
  exec bash
fi

echo -e "\n🚀 Automatic installation starting...\n"
sleep 1

# ===============================
# SYSTEM UPDATE + DEPENDENCIES
# ===============================
apt update -y && apt upgrade -y

apt install -y \
  curl git build-essential pkg-config libssl-dev \
  clang lz4 jq htop ca-certificates gnupg

# ===============================
# RUST INSTALL (FIXED)
# ===============================
if ! command -v cargo >/dev/null 2>&1; then
  echo "🦀 Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# force load cargo in non-interactive shell
. "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

# persist for future shells
if ! grep -q '.cargo/bin' /root/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> /root/.bashrc
fi

rustc --version
cargo --version

# ===============================
# DOCKER INSTALL (OFFICIAL)
# ===============================
if ! command -v docker >/dev/null 2>&1; then
  echo "🐳 Installing Docker..."

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

  apt update -y
  apt install -y docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
fi

usermod -aG docker ${SUDO_USER:-root}
systemctl enable docker
systemctl start docker

docker --version
docker run hello-world || true

# ===============================
# TEMPO BUILD
# ===============================
if [ ! -d "$HOME/tempo" ]; then
  git clone https://github.com/tempoxyz/tempo.git "$HOME/tempo"
fi

cd "$HOME/tempo"

cargo build --release --bin tempo

# ===============================
# VALIDATOR KEY GENERATION
# ===============================
mkdir -p "$HOME/tempo-node"

./target/release/tempo consensus generate-private-key \
  --output "$HOME/tempo-node/validator-key"

./target/release/tempo consensus calculate-public-key \
  --private-key "$HOME/tempo-node/validator-key"

echo ""
echo "🔐 Validator Private Key:"
cat "$HOME/tempo-node/validator-key"

echo -e "\n✅ All steps completed successfully!"
echo "👑 Built by 0xDarkSeidBull"
