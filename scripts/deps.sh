#!/usr/bin/env bash
set -e

echo "🛠 Updating system and installing dependencies…"
apt update -y
apt install -y curl git build-essential pkg-config libssl-dev ca-certificates docker.io

echo "📦 Enabling Docker"
systemctl enable docker
systemctl start docker

echo "📥 Installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
