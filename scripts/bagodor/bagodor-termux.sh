#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# bagodor-termux.sh  —  Android Termux Bootstrap
# Installs system packages, Python, Node.js, and common dev tools in Termux.
#
# HOW TO USE:
#   curl --fail -fsSL https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-termux.sh \
#     -o /tmp/bagodor-termux.sh && bash /tmp/bagodor-termux.sh
#
# INSTALL EXTRAS (heavier tools: emacs, DB servers, playwright, etc.):
#   BAGODOR_EXTRAS=1 bash /tmp/bagodor-termux.sh
#
# SKIP shell change (prevents chsh to zsh):
#   BAGODOR_SKIP_SHELL_CHANGE=1 bash /tmp/bagodor-termux.sh
# ─────────────────────────────────────────────────────────────────────────────

# Do NOT use 'set -e' — we handle errors per-package intentionally.

# ── Colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { printf "${CYAN}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERR]${RESET}   %s\n" "$*" >&2; }
section() { printf "\n${BOLD}${CYAN}▶  %s${RESET}\n" "$*"; }

pkg_install() {
    info "pkg: $*"
    pkg install -y "$@" 2>/dev/null && success "$*" || warn "$* unavailable or failed"
}

pip_install() {
    info "pip: $1"
    pip install "$1" --quiet 2>/dev/null && success "$1" || warn "$1 failed"
}

npm_global() {
    info "npm -g: $1"
    npm install -g "$1" 2>/dev/null && success "$1" || warn "$1 failed"
}

# ── Environment check ─────────────────────────────────────────────────────────
section "Checking Termux environment"

if [ -z "$TERMUX_VERSION" ] && [ ! -d "/data/data/com.termux" ]; then
    warn "TERMUX_VERSION not set — this script is designed for Termux on Android."
fi
success "Termux version: ${TERMUX_VERSION:-unknown}"

if ! command -v pkg >/dev/null 2>&1; then
    error "'pkg' not found. Run this inside Termux."
    exit 1
fi

# ── Storage access ────────────────────────────────────────────────────────────
section "Storage access"
info "Setting up storage symlinks (~/storage → internal storage)..."
termux-setup-storage 2>/dev/null || warn "termux-setup-storage failed — you may need to grant permission manually"

# ── System update ─────────────────────────────────────────────────────────────
section "Updating package index"
pkg update -y && pkg upgrade -y
success "Packages updated"

# ═══════════════════════════════════════════════════════════════════════════════
# CORE packages
# ═══════════════════════════════════════════════════════════════════════════════

section "Essential system tools (core)"
pkg_install coreutils findutils grep sed gawk diffutils less which file tree

section "Shell & multiplexing (core)"
pkg_install bash zsh fish tmux screen

# Only change default shell if explicitly allowed (it is persistent across runs)
if [ "${BAGODOR_SKIP_SHELL_CHANGE:-0}" != "1" ]; then
    if command -v zsh >/dev/null 2>&1; then
        chsh -s zsh 2>/dev/null \
            && success "Default shell set to zsh (run BAGODOR_SKIP_SHELL_CHANGE=1 to skip this)" \
            || warn "Could not set zsh as default shell"
    fi
else
    info "Skipping shell change (BAGODOR_SKIP_SHELL_CHANGE=1)"
fi

section "Text editors (core)"
pkg_install vim nano micro

section "Networking tools (core)"
pkg_install curl wget openssh

section "File utilities (core)"
pkg_install zip unzip tar gzip rsync fzf bat fd ripgrep jq

section "System monitoring (core)"
pkg_install htop ncdu

section "Version control (core)"
pkg_install git
# Only set git config keys that are not already set
if [ -z "$(git config --global init.defaultBranch 2>/dev/null)" ]; then
    git config --global init.defaultBranch main
fi
if [ -z "$(git config --global core.autocrlf 2>/dev/null)" ]; then
    git config --global core.autocrlf false
fi
success "git configured"

section "Build tools (core)"
pkg_install build-essential clang make

section "Python (core)"
pkg_install python python-pip || { error "Python install failed"; exit 1; }
pip install --upgrade pip setuptools wheel --quiet && success "pip/setuptools/wheel upgraded"

section "Python: HTTP & networking (core)"
for pkg in requests httpx urllib3 certifi aiofiles; do pip_install "$pkg"; done

section "Python: data & serialisation (core)"
for pkg in PyYAML toml python-dotenv colorama rich tqdm click jsonschema; do pip_install "$pkg"; done

section "Python: web frameworks (core)"
for pkg in flask flask-cors fastapi "uvicorn[standard]"; do pip_install "$pkg"; done

section "Python: web scraping (core)"
for pkg in beautifulsoup4 lxml html5lib; do pip_install "$pkg"; done

section "Python: security (core)"
for pkg in cryptography pyjwt; do pip_install "$pkg"; done

section "Python: testing (core)"
for pkg in pytest pytest-cov coverage; do pip_install "$pkg"; done

section "Python: async (core)"
for pkg in anyio trio aiohttp; do pip_install "$pkg"; done

section "Node.js (core)"
pkg_install nodejs
if command -v npm >/dev/null 2>&1; then
    for npkg in pnpm typescript ts-node nodemon prettier http-server; do
        npm_global "$npkg"
    done
    success "Node.js: $(node --version), npm: $(npm --version)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# EXTRAS — heavier or less commonly needed tools.
# Install with: BAGODOR_EXTRAS=1 bash bagodor-termux.sh
# ═══════════════════════════════════════════════════════════════════════════════

if [ "${BAGODOR_EXTRAS:-0}" = "1" ]; then

    section "Extras: advanced editors"
    pkg_install neovim emacs

    section "Extras: additional networking"
    pkg_install nmap netcat-openbsd iproute2 dnsutils whois traceroute

    section "Extras: GitHub CLI"
    pkg_install gh

    section "Extras: file tools"
    pkg_install bzip2 p7zip rclone yq

    section "Extras: Ruby"
    pkg_install ruby
    if command -v gem >/dev/null 2>&1; then
        gem install bundler rake 2>/dev/null && success "bundler + rake" || warn "gem install failed"
    fi

    section "Extras: Perl"
    pkg_install perl

    section "Extras: database engines"
    pkg_install sqlite mariadb redis

    section "Extras: media tools"
    pkg_install ffmpeg imagemagick

    section "Extras: container / proot"
    pkg_install proot proot-distro

    section "Extras: strace / lsof"
    pkg_install lsof

    section "Extras: Python scientific stack"
    for pkg in numpy scipy pandas matplotlib pillow scikit-learn; do pip_install "$pkg"; done

    section "Extras: Python DB clients"
    for pkg in sqlalchemy pymysql psycopg2-binary redis pymongo; do pip_install "$pkg"; done

    section "Extras: Python scraping"
    for pkg in playwright selenium; do pip_install "$pkg"; done

    section "Extras: Python testing"
    for pkg in pytest-asyncio hypothesis; do pip_install "$pkg"; done

    section "Extras: Python security"
    for pkg in bcrypt paramiko pyotp; do pip_install "$pkg"; done

    section "Extras: Node.js pm2 + yarn"
    npm_global pm2
    npm_global yarn

    # Oh-My-Zsh — download to temp file, verify, then run
    section "Extras: Oh-My-Zsh"
    if command -v zsh >/dev/null 2>&1 && [ ! -d "$HOME/.oh-my-zsh" ]; then
        OMZ_INSTALLER="$(mktemp /tmp/omz_install_XXXXXX.sh)"
        if curl --fail --silent --location \
               "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" \
               -o "$OMZ_INSTALLER" && [ -s "$OMZ_INSTALLER" ]; then
            sh "$OMZ_INSTALLER" --unattended && success "Oh-My-Zsh installed" \
                || warn "Oh-My-Zsh install failed (non-fatal)"
        else
            warn "Could not download Oh-My-Zsh installer"
        fi
        rm -f "$OMZ_INSTALLER"
    else
        info "Oh-My-Zsh already installed or zsh unavailable — skipping"
    fi

    section "Extras: Termux add-on packages"
    pkg_install termux-api termux-tools

else
    info "Skipping extras. Run with BAGODOR_EXTRAS=1 to install heavier tools."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
section "Done!"
printf "\n${GREEN}${BOLD}bagodor-termux setup complete.${RESET}\n\n"
printf "  Python:  %s\n"  "$(python --version 2>&1)"
printf "  pip:     %s\n"  "$(pip --version 2>&1 | awk '{print $1,$2}')"
command -v node >/dev/null 2>&1 && printf "  Node.js: %s\n" "$(node --version)"
command -v git  >/dev/null 2>&1 && printf "  Git:     %s\n" "$(git --version)"
printf "\n${CYAN}Tip:${RESET} Restart Termux to activate zsh.\n"
printf "${CYAN}Tip:${RESET} Run with BAGODOR_EXTRAS=1 to install heavier tools.\n"
printf "${CYAN}Tip:${RESET} Use 'termux-setup-storage' to access ~/storage/downloads.\n\n"
