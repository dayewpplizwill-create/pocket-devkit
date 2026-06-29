<div align="center">

<h1>📱 pocket-devkit</h1>

<p><strong>Полноценная dev-среда на телефоне — одной командой.</strong></p>

<p>Запускаешь скрипт → он сам определяет iOS или Android → устанавливает всё нужное.<br>
Python, Node.js, git, редакторы, утилиты — готово за минуты.</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-blue)](#)
[![Shell](https://img.shields.io/badge/shell-POSIX%20sh-lightgrey)](#)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#-участие)

</div>

---

<div align="center">

### Работаешь с телефона — хочешь просто открыть терминал и писать код.
### Вместо этого полчаса ставишь pip, потом git, потом выясняется что нет curl.
### pocket-devkit — это одна команда вместо тридцати.

</div>

---

## ⚡ Запуск

### 📱 iOS — a-Shell

```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-ios.sh \
  -o /tmp/b.sh && sh /tmp/b.sh
```

### 🤖 Android — Termux

```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-termux.sh \
  -o /tmp/b.sh && bash /tmp/b.sh
```

### 🔍 Не знаешь что у тебя? Авто-определение

```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor.sh \
  -o /tmp/b.sh && sh /tmp/b.sh
```

> **Почему не `curl | sh`?**  
> Скачиваем сначала в файл — можешь открыть и прочитать перед запуском. Безопаснее.

---

## 🔍 Что происходит после запуска

```
▶ Определяет платформу ........... iOS или Android — автоматически
▶ Проверяет окружение ............. Python, pip, pkg — всё на месте?
▶ Обновляет пакеты ................ актуальные версии, не кэш
▶ Устанавливает инструменты ....... по категориям, с прогрессом
▶ Не ломается при ошибках ......... пишет предупреждение → идёт дальше
▶ Настраивает окружение ........... zsh, git, lg2
▶ Показывает итог ................. что встало, что делать дальше
```

Всё занимает **от 2 до 10 минут** в зависимости от скорости интернета.

---

## 📦 Что устанавливается

<details>
<summary><strong>📱 iOS — a-Shell (нажми чтобы раскрыть)</strong></summary>

a-Shell — бесплатный терминал для iPhone/iPad со встроенным Python 3 (Python3_ios).

**Ядро — всегда устанавливается:**

| Категория | Пакеты |
|-----------|--------|
| 🌐 HTTP | `requests`, `urllib3`, `certifi`, `aiofiles` |
| 📦 Данные | `PyYAML`, `toml`, `python-dotenv`, `rich`, `tqdm`, `click`, `colorama` |
| 📝 Текст | `regex`, `markdown`, `beautifulsoup4`, `html5lib` |
| ⚡ Async | `anyio`, `aiofiles` |
| 🧪 Тесты | `pytest` |
| 🔧 Утилиты | `watchdog`, `invoke`, `typer`, `jsonschema` |
| 🗂 Git | `lg2` (встроенный git в a-Shell) |

**Extras — с флагом `BAGODOR_EXTRAS=1`:**

`numpy` · `scipy` · `pandas` · `matplotlib` · `pillow` · `flask` · `flask-cors` · `bottle` · `aiohttp` · `cryptography` · `paramiko` · `lxml` · `nltk` · `hypothesis` · `pytest-cov`

> Некоторые extras требуют нативной компиляции — на iOS могут не встать. Скрипт это знает и продолжит работу без них.

</details>

<details>
<summary><strong>🤖 Android — Termux (нажми чтобы раскрыть)</strong></summary>

Termux — полноценный Linux на Android без root.

**Ядро — всегда устанавливается:**

| Категория | Пакеты |
|-----------|--------|
| 🐚 Шеллы | `zsh`, `fish`, `tmux`, `screen` |
| ✏️ Редакторы | `vim`, `nano`, `micro` |
| 🌐 Сеть | `curl`, `wget`, `openssh` |
| 🗂 Git | `git` |
| 🔧 Сборка | `build-essential`, `clang`, `make` |
| 📁 Файлы | `zip`, `unzip`, `rsync`, `fzf`, `ripgrep`, `jq`, `bat`, `fd` |
| 📊 Мониторинг | `htop`, `ncdu` |
| 🐍 Python | `python` + pip + `flask`, `fastapi`, `uvicorn`, `requests`, `pytest`, `aiohttp`, `cryptography`, `beautifulsoup4`, `rich`, `click` и др. |
| 🟢 Node.js | `node` + `pnpm`, `typescript`, `ts-node`, `nodemon`, `prettier`, `http-server` |

**Extras — с флагом `BAGODOR_EXTRAS=1`:**

`neovim` · `emacs` · `nmap` · `gh` (GitHub CLI) · `ffmpeg` · `imagemagick` · `sqlite` · `mariadb` · `redis` · `proot` · `proot-distro` · `numpy` · `pandas` · `scikit-learn` · `sqlalchemy` · `playwright` · `selenium` · `bcrypt` · `pyotp` · `pm2` · `yarn` · `Oh-My-Zsh` · `termux-api`

</details>

---

## 🎛 Опции

```sh
# Принудительно указать платформу (если авто-определение не сработало)
BAGODOR_PLATFORM=ios     sh /tmp/b.sh
BAGODOR_PLATFORM=termux  sh /tmp/b.sh

# Установить тяжёлые extras поверх ядра
BAGODOR_EXTRAS=1  sh /tmp/b.sh

# Не менять дефолтный шелл (Termux)
BAGODOR_SKIP_SHELL_CHANGE=1  bash /tmp/b.sh

# Всё сразу
BAGODOR_EXTRAS=1 BAGODOR_SKIP_SHELL_CHANGE=1  bash /tmp/b.sh
```

---

## 📋 Требования

| Платформа | Нужное приложение |
|-----------|------------------|
| **iOS / iPadOS** | [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) или [a-Shell mini](https://apps.apple.com/app/a-shell-mini/id1543537943) — Python уже внутри |
| **Android** | [Termux с F-Droid](https://f-droid.org/packages/com.termux/) — **не из Google Play** |

> ⚠️ **Termux из Google Play устарел** — пакеты там не обновляются. Только [F-Droid](https://f-droid.org/packages/com.termux/).

---

## 💡 Советы после установки

**iOS (a-Shell):**
- Вместо `git` используй `lg2` — это встроенный git: `lg2 clone`, `lg2 push`, `lg2 commit`
- `pickFolder` — открывает доступ к файлам вне песочницы приложения
- `pip3 list` — посмотреть всё что установлено

**Android (Termux):**
- Перезапусти Termux после установки — активирует zsh
- `termux-setup-storage` — даёт доступ к `~/storage/downloads`
- Установи [Termux:API](https://f-droid.org/packages/com.termux.api/) для работы с камерой, буфером обмена и SMS
- После extras: `proot-distro install ubuntu` — полноценный Ubuntu внутри Termux

---

## 📁 Структура

```
scripts/bagodor/
├── bagodor.sh           # Авто-определение платформы
├── bagodor-ios.sh       # iOS: a-Shell / Python3_ios
├── bagodor-termux.sh    # Android: Termux
└── README.md            # Подробная документация
```

---

## 🤝 Участие

Нашёл пакет которого не хватает? Скрипт сломался на твоём устройстве?  
Открывай [Issue](https://github.com/dayewpplizwill-create/pocket-devkit/issues) или присылай PR — всё приветствуется.

---

## License

[MIT](LICENSE) — делай что хочешь.

---

<div align="center">
<sub>Сделано для тех, кто работает с телефона. 📱</sub>
</div>
