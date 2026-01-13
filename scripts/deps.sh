#!/usr/bin/env bash
set -e

echo "🔧 System update & dependencies install"

apt update -y
apt upgrade -y

apt install -y \
  curl \
  git \
  build-essential \
  pkg-config \
  libssl-dev \
  ca-certificates \
  docker.io \
  clang \
  llvm \
  libclang-dev

systemctl enable docker
systemctl start docker

echo "🦀 Installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
