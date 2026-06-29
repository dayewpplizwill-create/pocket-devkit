#!/bin/sh
# ─────────────────────────────────────────────────────────────────────────────
# bagodor.sh  —  Universal Mobile Terminal Bootstrap
#
# Auto-detects whether you're running on:
#   • iOS  — a-Shell / Python3_ios
#   • Android — Termux
# and runs the correct platform script.
#
# HOW TO USE:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor/bagodor.sh | sh
#
# Or, if you've cloned the repo:
#   sh scripts/bagodor/bagodor.sh
#
# FORCE a platform (required when platform cannot be auto-detected):
#   BAGODOR_PLATFORM=ios     sh bagodor.sh
#   BAGODOR_PLATFORM=termux  sh bagodor.sh
#
# INSTALL EXTRAS (optional heavy packages on top of core):
#   BAGODOR_EXTRAS=1         sh bagodor.sh
# ─────────────────────────────────────────────────────────────────────────────

# Do NOT use 'set -e' at the top level — sub-scripts handle their own errors.

# ── Colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { printf "${CYAN}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERR]${RESET}   %s\n" "$*" >&2; }
banner()  {
    printf "\n${BOLD}${CYAN}"
    printf "╔══════════════════════════════════════════╗\n"
    printf "║         bagodor — mobile bootstrap       ║\n"
    printf "║   iOS (a-Shell) + Android (Termux)       ║\n"
    printf "╚══════════════════════════════════════════╝\n"
    printf "${RESET}\n"
}

banner

# ── Platform detection ────────────────────────────────────────────────────────
detect_platform() {
    # 1. Honour explicit override
    if [ -n "$BAGODOR_PLATFORM" ]; then
        printf '%s' "$BAGODOR_PLATFORM"
        return
    fi

    # 2. Termux: TERMUX_VERSION env var or characteristic data path
    if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
        printf '%s' "termux"
        return
    fi

    # 3. a-Shell: has pickFolder builtin or ASHELL_VERSION env var
    if command -v pickFolder >/dev/null 2>&1 || [ -n "$ASHELL_VERSION" ]; then
        printf '%s' "ios"
        return
    fi

    # 4. iOS general fallback — /var/mobile is iOS-specific
    if [ -d "/var/mobile" ]; then
        printf '%s' "ios"
        return
    fi

    printf '%s' "unknown"
}

PLATFORM="$(detect_platform)"

case "$PLATFORM" in
    ios)
        success "Platform: iOS (a-Shell / Python3_ios)"
        ;;
    termux)
        success "Platform: Android (Termux)"
        ;;
    *)
        error "Platform could not be auto-detected."
        error "Re-run with BAGODOR_PLATFORM set explicitly:"
        error "  BAGODOR_PLATFORM=ios     sh bagodor.sh"
        error "  BAGODOR_PLATFORM=termux  sh bagodor.sh"
        exit 1
        ;;
esac

# ── Locate or fetch sub-scripts ───────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || echo ".")"
IOS_SCRIPT="$SCRIPT_DIR/bagodor-ios.sh"
TERMUX_SCRIPT="$SCRIPT_DIR/bagodor-termux.sh"
BASE_URL="${BAGODOR_BASE_URL:-https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor}"

# Download to a temp file and verify before executing.
# Piping curl/wget directly into sh hides download failures.
fetch_script() {
    SCRIPT_NAME="$1"
    DEST="$2"
    if command -v curl >/dev/null 2>&1; then
        info "Downloading $SCRIPT_NAME..."
        curl --fail --silent --location --show-error \
            "$BASE_URL/$SCRIPT_NAME" -o "$DEST"
    elif command -v wget >/dev/null 2>&1; then
        info "Downloading $SCRIPT_NAME..."
        wget --quiet "$BASE_URL/$SCRIPT_NAME" -O "$DEST"
    else
        error "Neither curl nor wget found. Cannot download $SCRIPT_NAME."
        error "Please download it manually from: $BASE_URL/$SCRIPT_NAME"
        return 1
    fi
}

run_platform_script() {
    SCRIPT_NAME="$1"
    LOCAL_PATH="$2"

    if [ -f "$LOCAL_PATH" ]; then
        info "Running local: $LOCAL_PATH"
        sh "$LOCAL_PATH"
        return $?
    fi

    # Not local — download to a temp file first, then run
    TMP_SCRIPT="$(mktemp /tmp/bagodor_XXXXXX.sh)" || {
        error "mktemp failed — cannot create temp file"
        return 1
    }

    fetch_script "$SCRIPT_NAME" "$TMP_SCRIPT" || {
        rm -f "$TMP_SCRIPT"
        error "Failed to download $SCRIPT_NAME. Check your internet connection."
        return 1
    }

    # Sanity-check the download is non-empty
    if [ ! -s "$TMP_SCRIPT" ]; then
        rm -f "$TMP_SCRIPT"
        error "Downloaded file is empty: $SCRIPT_NAME"
        return 1
    fi

    info "Running $SCRIPT_NAME..."
    sh "$TMP_SCRIPT"
    STATUS=$?
    rm -f "$TMP_SCRIPT"
    return $STATUS
}

# ── Export extras flag so sub-scripts can read it ─────────────────────────────
export BAGODOR_EXTRAS

# ── Dispatch ──────────────────────────────────────────────────────────────────
case "$PLATFORM" in
    ios)
        run_platform_script "bagodor-ios.sh" "$IOS_SCRIPT"
        ;;
    termux)
        run_platform_script "bagodor-termux.sh" "$TERMUX_SCRIPT"
        ;;
esac
