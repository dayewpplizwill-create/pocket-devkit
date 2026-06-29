# bagodor — Mobile Terminal Bootstrap

One-command setup for mobile terminal environments.

| Platform | Terminal app | Script |
|----------|-------------|--------|
| 📱 iOS / iPadOS | [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) (Python3_ios) | `bagodor-ios.sh` |
| 🤖 Android | [Termux from F-Droid](https://f-droid.org/packages/com.termux/) | `bagodor-termux.sh` |

> ⚠️ **Security note:** Always review shell scripts before running them. These scripts download and run code from the internet. Read the source before executing.

---

## Quick Start

### Step 1 — Download first, then run (recommended)

**iOS (a-Shell):**
```sh
curl --fail -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor/bagodor-ios.sh \
  -o /tmp/bagodor-ios.sh && sh /tmp/bagodor-ios.sh
```

**Android (Termux):**
```sh
curl --fail -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor/bagodor-termux.sh \
  -o /tmp/bagodor-termux.sh && bash /tmp/bagodor-termux.sh
```

**Auto-detect (runs the right script for your platform):**
```sh
curl --fail -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/bagodor/bagodor.sh \
  -o /tmp/bagodor.sh && sh /tmp/bagodor.sh
```

### Step 2 — Include extras (optional)

Extras install heavier or less commonly needed packages on top of the core set:

```sh
BAGODOR_EXTRAS=1 sh /tmp/bagodor.sh
# or
BAGODOR_EXTRAS=1 bash /tmp/bagodor-termux.sh
```

### Force a platform (when auto-detect fails)

```sh
BAGODOR_PLATFORM=ios     sh /tmp/bagodor.sh
BAGODOR_PLATFORM=termux  sh /tmp/bagodor.sh
```

### Skip shell change (Termux: don't switch default shell to zsh)

```sh
BAGODOR_SKIP_SHELL_CHANGE=1 bash /tmp/bagodor-termux.sh
```

---

## What gets installed

### iOS — a-Shell (Python3_ios)

a-Shell ships Python3_ios, a native Python 3 port for iOS. Packages needing C extensions not compiled into Python3_ios will fail gracefully — this is a platform limitation.

**Core (installed by default):**

| Category | Packages |
|----------|----------|
| HTTP | `requests`, `httpx` (extras), `urllib3`, `certifi` |
| Data | `PyYAML`, `toml`, `python-dotenv`, `colorama`, `rich`, `tqdm`, `click` |
| Text | `regex`, `markdown`, `beautifulsoup4`, `html5lib` |
| Async | `aiofiles`, `anyio` |
| Dev | `watchdog`, `invoke`, `typer`, `jsonschema` |
| Testing | `pytest` |
| Git | `lg2` (a-Shell's built-in libgit2 git client) |

**Extras (`BAGODOR_EXTRAS=1`):**

| Category | Packages |
|----------|----------|
| Scientific | `numpy`, `scipy`, `pandas`, `matplotlib`, `pillow` |
| Web | `flask`, `flask-cors`, `bottle`, `aiohttp` |
| Crypto | `cryptography`, `paramiko` |
| Parsing | `lxml`, `nltk`, `textblob` |
| Testing | `pytest-asyncio`, `pytest-cov`, `hypothesis`, `coverage` |

### Android — Termux

Termux provides a full Linux userland on Android with its own APT-based package manager.

**Core (installed by default):**

| Category | Packages |
|----------|----------|
| System | `coreutils`, `findutils`, `grep`, `sed`, `tree`, `fzf`, `ripgrep`, `jq`, `bat`, `fd` |
| Shells | `bash`, `zsh`, `fish`, `tmux`, `screen` |
| Editors | `vim`, `nano`, `micro` |
| Networking | `curl`, `wget`, `openssh` |
| Git | `git` |
| Build | `build-essential`, `clang`, `make` |
| Files | `zip`, `unzip`, `tar`, `gzip`, `rsync` |
| Monitoring | `htop`, `ncdu` |
| Python | `python`, `pip` + `requests`, `httpx`, `flask`, `fastapi`, `uvicorn`, `beautifulsoup4`, `cryptography`, `pytest`, `anyio`, `aiohttp` + more |
| Node.js | `node`, `npm`, `pnpm`, `typescript`, `ts-node`, `nodemon`, `prettier`, `http-server` |

**Extras (`BAGODOR_EXTRAS=1`):**

| Category | Packages |
|----------|----------|
| Editors | `neovim`, `emacs` |
| Networking | `nmap`, `netcat`, `gh` (GitHub CLI), `whois`, `traceroute` |
| Ruby | `ruby`, `bundler`, `rake` |
| Perl | `perl` |
| Databases | `sqlite`, `mariadb`, `redis` |
| Media | `ffmpeg`, `imagemagick` |
| Container | `proot`, `proot-distro` |
| Python: scientific | `numpy`, `scipy`, `pandas`, `matplotlib`, `pillow`, `scikit-learn` |
| Python: DB clients | `sqlalchemy`, `pymysql`, `psycopg2-binary`, `redis`, `pymongo` |
| Python: scraping | `playwright`, `selenium` |
| Python: security | `bcrypt`, `paramiko`, `pyotp` |
| Node.js extras | `pm2`, `yarn` |
| Oh-My-Zsh | installed from official repo |
| Termux extras | `termux-api`, `termux-tools` |

---

## Tips

### iOS (a-Shell)
- Use `lg2` instead of `git` — it's a-Shell's built-in git client powered by libgit2.
- Use `pickFolder` to browse files outside the sandbox.
- Run `pip3 list` to see all installed Python packages.
- Some packages requiring native C extensions may not install — this is expected on iOS.

### Android (Termux)
- **Install from [F-Droid](https://f-droid.org/packages/com.termux/)**, not the Google Play Store — the Play version is outdated and may not receive package updates.
- Run `termux-setup-storage` to get access to your Downloads folder via `~/storage/downloads`.
- Install the **[Termux:API](https://f-droid.org/packages/com.termux.api/)** companion app from F-Droid to unlock `termux-api` package features (battery, clipboard, camera, SMS, etc.).
- Use `proot-distro install ubuntu` (after installing extras) to get a full Ubuntu environment inside Termux.
- Restart Termux after the script completes to activate zsh.

---

## Requirements

| Platform | Requirement |
|----------|-------------|
| iOS | [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) or [a-Shell mini](https://apps.apple.com/app/a-shell-mini/id1543537943) — Python3_ios is bundled |
| Android | [Termux from F-Droid](https://f-droid.org/packages/com.termux/) — NOT the Google Play version |

---

## Customising

All scripts are plain shell. Open them in any text editor and comment out sections you don't need:

```sh
# section "Ruby"
# pkg_install ruby ...
```

Each section is labelled. The `core` vs `extras` split is also adjustable — move packages between sections to suit your workflow.
