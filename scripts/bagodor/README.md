<div align="center">

# 📱 pocket-devkit

**Полноценная dev-среда на телефоне — одной командой.**

Запускаешь скрипт → он сам определяет iOS или Android → устанавливает всё нужное.  
Python, Node.js, git, редакторы, утилиты — готово за минуты.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-blue)](#)
[![Shell](https://img.shields.io/badge/shell-POSIX%20sh-green)](#)

</div>

---

## ⚡ Быстрый старт

### iOS — a-Shell
```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-ios.sh \
  -o /tmp/b.sh && sh /tmp/b.sh
```

### Android — Termux
```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-termux.sh \
  -o /tmp/b.sh && bash /tmp/b.sh
```

### Не знаешь что у тебя? Авто-определение
```sh
curl --fail -fsSL \
  https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor.sh \
  -o /tmp/b.sh && sh /tmp/b.sh
```

> 💡 Сначала скачиваем в файл, потом запускаем — так безопаснее, чем `curl | sh`.  
> Всегда можно открыть `/tmp/b.sh` и прочитать перед запуском.

---

## Зачем это нужно?

Ты открываешь терминал на телефоне и хочешь **просто работать** — клонировать репо, запустить скрипт, проверить API, починить сервер.  
Но вместо этого тратишь 20 минут на установку pip, потом ещё 10 на requests, потом выясняется, что нет git...

**pocket-devkit** решает это одной командой.

---

## 🔍 Что делает скрипт — шаг за шагом

Запускаешь одну команду в терминале и дальше всё происходит само:

**1. Определяет платформу**  
Скрипт смотрит на окружение и сам понимает — это iOS (a-Shell) или Android (Termux). Не нужно ничего выбирать вручную.

**2. Проверяет, что всё готово к работе**  
Убеждается, что Python и pip доступны. Если что-то не так — сразу говорит об этом понятным сообщением, а не падает с непонятной ошибкой.

**3. Обновляет пакетный менеджер**  
На Android (Termux) — обновляет список пакетов (`pkg update`). На iOS — обновляет pip. Так ты получаешь актуальные версии, а не то что лежало в кэше.

**4. Устанавливает инструменты по категориям**  
Всё разбито на логичные группы: сначала системные утилиты, потом шеллы и редакторы, потом Python, потом Node.js и так далее. Каждый шаг подписан — ты видишь что происходит в реальном времени.

**5. Не ломается при ошибках**  
Если какой-то пакет не встал (например, на iOS некоторые C-расширения недоступны) — скрипт пишет предупреждение и идёт дальше. Не зависает, не прерывается, не требует твоего внимания.

**6. Настраивает окружение**  
- Устанавливает `zsh` как дефолтный шелл (Android)  
- Настраивает `git` (ветка `main` по умолчанию, нормальные переносы строк)  
- Проверяет наличие `lg2` — встроенного git в a-Shell (iOS)

**7. В конце показывает итог**  
Версии Python, Node.js, git — всё что установилось. Плюс подсказки что делать дальше.

> Всё это занимает от 2 до 10 минут в зависимости от скорости интернета и платформы.

---

## 🗂 Что устанавливается

### 📱 iOS — a-Shell (Python3_ios)

> a-Shell — бесплатный терминал для iPhone/iPad со встроенным Python 3.

**Ядро (по умолчанию):**

| Категория | Пакеты |
|-----------|--------|
| 🌐 HTTP | `requests`, `urllib3`, `certifi`, `aiofiles` |
| 📦 Данные | `PyYAML`, `toml`, `python-dotenv`, `rich`, `tqdm`, `click` |
| 📝 Текст | `regex`, `markdown`, `beautifulsoup4` |
| ⚡ Async | `anyio`, `aiofiles` |
| 🧪 Тесты | `pytest` |
| 🔧 Утилиты | `watchdog`, `invoke`, `typer`, `jsonschema`, `colorama` |
| 🗂 Git | `lg2` (встроенный git в a-Shell) |

**Extras (`BAGODOR_EXTRAS=1`) — тяжёлые пакеты:**

`numpy` · `scipy` · `pandas` · `matplotlib` · `pillow` · `flask` · `aiohttp` · `cryptography` · `lxml` · `hypothesis`

> ⚠️ Некоторые extras требуют нативной компиляции и могут не встать на iOS — это нормально, скрипт продолжит работу.

---

### 🤖 Android — Termux

> Termux — полноценный Linux на Android без root.

**Ядро (по умолчанию):**

| Категория | Пакеты |
|-----------|--------|
| 🐚 Шеллы | `zsh`, `fish`, `tmux`, `screen` |
| ✏️ Редакторы | `vim`, `nano`, `micro` |
| 🌐 Сеть | `curl`, `wget`, `openssh` |
| 🗂 Git | `git` (с настройкой) |
| 🔧 Сборка | `build-essential`, `clang`, `make` |
| 📁 Файлы | `zip`, `unzip`, `rsync`, `fzf`, `ripgrep`, `jq`, `bat` |
| 📊 Мониторинг | `htop`, `ncdu` |
| 🐍 Python | `python` + pip + flask, fastapi, requests, pytest, aiohttp и др. |
| 🟢 Node.js | `node` + `pnpm`, `typescript`, `ts-node`, `nodemon`, `prettier` |

**Extras (`BAGODOR_EXTRAS=1`):**

`neovim` · `emacs` · `nmap` · `gh` (GitHub CLI) · `ffmpeg` · `imagemagick` · `sqlite` · `mariadb` · `redis` · `proot-distro` · `numpy` · `pandas` · `scikit-learn` · `playwright` · `Oh-My-Zsh` · `pm2` · `yarn` · и многое другое

---

## 🎛 Опции запуска

```sh
# Принудительно указать платформу
BAGODOR_PLATFORM=ios     sh /tmp/b.sh
BAGODOR_PLATFORM=termux  sh /tmp/b.sh

# Установить тяжёлые extras
BAGODOR_EXTRAS=1         sh /tmp/b.sh

# Не менять дефолтный шелл (Termux)
BAGODOR_SKIP_SHELL_CHANGE=1 bash /tmp/b.sh

# Комбо
BAGODOR_EXTRAS=1 BAGODOR_SKIP_SHELL_CHANGE=1 bash /tmp/b.sh
```

---

## 📋 Требования

| Платформа | Приложение |
|-----------|-----------|
| iOS / iPadOS | [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) или [a-Shell mini](https://apps.apple.com/app/a-shell-mini/id1543537943) |
| Android | [Termux с F-Droid](https://f-droid.org/packages/com.termux/) ← **не из Google Play** |

> ⚠️ Termux в Google Play устарел и не получает обновления пакетов. Используй версию с F-Droid.

---

## 💡 Советы

**iOS:**
- `lg2` — это git внутри a-Shell. Используй вместо `git`: `lg2 clone`, `lg2 commit`, `lg2 push`
- `pickFolder` — даёт доступ к файлам вне песочницы
- `pip3 list` — посмотреть все установленные пакеты

**Android:**
- После первого запуска перезапусти Termux — активирует zsh
- `termux-setup-storage` — доступ к `~/storage/downloads`
- Установи [Termux:API](https://f-droid.org/packages/com.termux.api/) из F-Droid для работы с камерой, буфером обмена, SMS
- `proot-distro install ubuntu` — полноценный Ubuntu внутри Termux (только после extras)

---

## 🛠 Кастомизация

Скрипты — обычный shell. Открой любым редактором и закомментируй что не нужно:

```sh
# section "Ruby"
# pkg_install ruby ...
```

Перенести пакет из extras в core — просто переставь строчку. Всё явно и понятно.

---

## 📁 Структура

```
scripts/bagodor/
├── bagodor.sh          # Авто-определение платформы, запускает нужный скрипт
├── bagodor-ios.sh      # iOS: a-Shell / Python3_ios
├── bagodor-termux.sh   # Android: Termux
└── README.md           # Этот файл
```

---

## 🔐 Безопасность

Этот скрипт скачивает пакеты из pip и pkg. Перед запуском ты можешь прочитать исходник:

```sh
# Скачай и проверь перед запуском
curl --fail -fsSL https://raw.githubusercontent.com/dayewpplizwill-create/pocket-devkit/main/scripts/bagodor/bagodor-ios.sh -o /tmp/b.sh
cat /tmp/b.sh   # читаем
sh /tmp/b.sh    # запускаем только если всё ок
```

---

## License

MIT — делай что хочешь.

---

<div align="center">
Сделано для тех, кто работает с телефона. 📱
</div>
