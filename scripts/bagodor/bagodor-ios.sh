#!/bin/sh
# ─────────────────────────────────────────────────────────────────────────────
# bagodor-ios.sh  —  iOS Terminal Bootstrap (a-Shell / Python3_ios)
# Installs Python packages and essential tools for a-Shell on iPhone/iPad.
#
# HOW TO USE:
#   curl --fail -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor/bagodor-ios.sh \
#     -o /tmp/bagodor-ios.sh && sh /tmp/bagodor-ios.sh
#
# INSTALL EXTRAS (heavier, more likely to fail on iOS):
#   BAGODOR_EXTRAS=1 sh /tmp/bagodor-ios.sh
#
# NOTE: Some packages require C extensions not compiled into Python3_ios
# and will fail gracefully. This is a platform limitation, not a bug.
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

pip_install() {
    PKG="$1"
    info "pip: $PKG"
    if pip3 install "$PKG" --quiet 2>/dev/null; then
        success "$PKG"
    else
        warn "$PKG failed (may require C extensions not available on iOS)"
    fi
}

# ── Environment check ─────────────────────────────────────────────────────────
section "Checking environment"

if ! command -v python3 >/dev/null 2>&1; then
    error "python3 not found. Open a-Shell and try again."
    exit 1
fi
success "Python3: $(python3 --version 2>&1)"

if ! command -v pip3 >/dev/null 2>&1; then
    error "pip3 not found. Python3_ios may not be fully set up."
    exit 1
fi
success "pip3: $(pip3 --version 2>&1 | awk '{print $1,$2}')"

# ── pip self-update ───────────────────────────────────────────────────────────
section "Upgrading pip"
pip3 install --upgrade pip --quiet 2>/dev/null && success "pip upgraded" \
    || warn "pip upgrade failed (non-fatal)"

# ═══════════════════════════════════════════════════════════════════════════════
# CORE packages — high success rate on Python3_ios
# ═══════════════════════════════════════════════════════════════════════════════

section "HTTP & networking (core)"
for pkg in requests urllib3 certifi charset-normalizer idna; do
    pip_install "$pkg"
done

section "Data handling (core)"
for pkg in PyYAML toml python-dotenv colorama rich tqdm click; do
    pip_install "$pkg"
done

section "Text processing (core)"
for pkg in regex markdown; do
    pip_install "$pkg"
done

section "Web scraping (core)"
for pkg in beautifulsoup4 html5lib; do
    pip_install "$pkg"
done

section "Async utilities (core)"
for pkg in aiofiles anyio; do
    pip_install "$pkg"
done

section "Testing (core)"
for pkg in pytest; do
    pip_install "$pkg"
done

section "Dev utilities (core)"
for pkg in watchdog invoke typer jsonschema; do
    pip_install "$pkg"
done

# ═══════════════════════════════════════════════════════════════════════════════
# EXTRAS — heavier packages; more likely to fail on iOS.
# Install with: BAGODOR_EXTRAS=1 sh bagodor-ios.sh
# ═══════════════════════════════════════════════════════════════════════════════

if [ "${BAGODOR_EXTRAS:-0}" = "1" ]; then
    section "Extras: scientific & data"
    warn "Some of these require C extensions and may fail on iOS."
    for pkg in numpy scipy pandas matplotlib pillow; do
        pip_install "$pkg"
    done

    section "Extras: async networking"
    for pkg in httpx aiohttp websockets; do
        pip_install "$pkg"
    done

    section "Extras: web frameworks"
    for pkg in flask flask-cors bottle; do
        pip_install "$pkg"
    done

    section "Extras: serialisation"
    for pkg in openpyxl xlrd; do
        pip_install "$pkg"
    done

    section "Extras: security & crypto"
    warn "Crypto packages often require native compilation — expect some failures."
    for pkg in cryptography paramiko; do
        pip_install "$pkg"
    done

    section "Extras: testing"
    for pkg in pytest-asyncio pytest-cov hypothesis coverage; do
        pip_install "$pkg"
    done

    section "Extras: NLP & parsing"
    for pkg in lxml nltk textblob; do
        pip_install "$pkg"
    done
else
    info "Skipping extras. Run with BAGODOR_EXTRAS=1 to install heavy packages."
fi

# ── Git via lg2 (a-Shell built-in) ───────────────────────────────────────────
section "Git (lg2 — a-Shell built-in)"
if command -v lg2 >/dev/null 2>&1; then
    success "lg2 available — use 'lg2 clone', 'lg2 commit', etc."
else
    warn "lg2 not found. Update a-Shell to get the built-in git client."
fi

# ── a-Shell pkg extras ────────────────────────────────────────────────────────
section "a-Shell pkg extras"
if command -v pkg >/dev/null 2>&1; then
    info "Trying a-Shell pkg: python_ios"
    pkg install python_ios 2>/dev/null && success "python_ios" \
        || warn "python_ios unavailable (may already be installed)"
else
    warn "'pkg' command not found — skipping a-Shell package installs"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
section "Done!"
printf "\n${GREEN}${BOLD}bagodor-ios setup complete.${RESET}\n"
printf "\nInstalled packages:\n"
pip3 list --format=columns 2>/dev/null
printf "\n${CYAN}Tip:${RESET} Use 'lg2' instead of 'git' inside a-Shell.\n"
printf "${CYAN}Tip:${RESET} Run with BAGODOR_EXTRAS=1 to install heavier packages.\n\n"
