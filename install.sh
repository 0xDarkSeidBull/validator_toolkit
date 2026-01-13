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
    1)
      MODE="auto"
      break
      ;;
    2)
      MODE="manual"
      break
      ;;
    *)
      echo "❌ Invalid choice. Please enter 1 or 2."
      ;;
  esac
done

# ========= MODE HANDLING =========
if [ "$MODE" = "manual" ]; then
  echo -e "\n🛠️ Manual mode selected."
  echo "You are now in root shell."
  exec bash
fi

echo -e "\n🚀 Automatic installation starting...\n"
sleep 1

# ========= AUTO INSTALL =========
apt update -y && apt upgrade -y

# --- Core + Rust native deps (FIXED) ---
apt install -y \
  curl wget git build-essential pkg-config \
  libssl-dev jq unzip ca-certificates \
  clang llvm libclang-dev

# --- Docker ---
if ! command -v docker >/dev/null 2>&1; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com | bash
  systemctl enable docker
  systemctl start docker
fi

# --- Rust ---
if ! command -v cargo >/dev/null 2>&1; then
  echo "🦀 Installing Rust..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# --- libclang ENV (critical for reth / mdbx / bindgen) ---
if [ -z "$LIBCLANG_PATH" ]; then
  export LIBCLANG_PATH=$(dirname $(find /usr/lib -name "libclang.so*" | head -n 1))
  echo "🔧 LIBCLANG_PATH set to $LIBCLANG_PATH"
fi

echo -e "\n✅ Installation completed successfully!"
echo "👑 Built by 0xDarkSeidBull"
