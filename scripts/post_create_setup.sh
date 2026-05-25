#!/usr/bin/env bash
set -euo pipefail

APT_GET="apt-get"
if command -v sudo >/dev/null 2>&1; then
  APT_GET="sudo apt-get"
fi

echo "Installing system libraries required by the R package stack..."
$APT_GET update
DEBIAN_FRONTEND=noninteractive $APT_GET install -y --no-install-recommends \
  fonts-noto-cjk \
  libfontconfig1-dev \
  libfreetype6-dev \
  libfribidi-dev \
  libharfbuzz-dev \
  libjpeg-dev \
  libpng-dev \
  libtiff5-dev \
  libwebp-dev \
  pkg-config \
  zlib1g-dev

if command -v fc-cache >/dev/null 2>&1; then
  echo "Refreshing font cache..."
  fc-cache -f
fi

echo "Installing OpenCode CLI..."

if curl -fsSL https://opencode.ai/install | bash; then
  if [ -d "$HOME/.opencode/bin" ]; then
    export PATH="$HOME/.opencode/bin:$PATH"
    if [ -f "$HOME/.bashrc" ] && ! grep -Fq 'export PATH="$HOME/.opencode/bin:$PATH"' "$HOME/.bashrc"; then
      printf '\nexport PATH="$HOME/.opencode/bin:$PATH"\n' >> "$HOME/.bashrc"
    fi
  fi

  if command -v opencode >/dev/null 2>&1; then
    opencode --version
  else
    echo "WARNING: OpenCode installed but is not yet on PATH in this shell." >&2
    echo "Run: export PATH=\"\$HOME/.opencode/bin:\$PATH\"" >&2
  fi
else
  echo "WARNING: OpenCode installation failed. Quarto and R setup completed, but OpenCode must be installed manually." >&2
fi

echo "Installing required R packages..."
Rscript scripts/install_required_packages.R
