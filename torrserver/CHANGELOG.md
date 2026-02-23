# Changelog

## 2.0.0-MatriX.139 [2026-02-23]

### 🚨 Breaking changes

🔑 **Custom TMDB API Key Required**: The shared, built-in TMDB API key has been removed to prevent rate-limiting issues. You must now configure your personal API key via the app's UI settings.

**How to get your key:**
- Register or log in at [TheMovieDB.org](https://www.themoviedb.org/).
- Go to your **Profile Settings** -> **API** section.
- Request a new API key (choose the "for personal use" type).

### ✨ New features

- 🕶 Upgraded TorrServer to **MatriX.139** (changes: [MatriX.138](https://github.com/YouROK/TorrServer/releases/tag/MatriX.138) / [MatriX.139](https://github.com/YouROK/TorrServer/releases/tag/MatriX.139))
- ⚙️ Added new addon configuration options: `proxyurl` and `proxymode`.

### 🧰 Maintenance

- 🔄 Renamed "addon" to "app" throughout the project to align with Home Assistant terminology.

## 1.5.2-MatriX.137 [2026-01-06]

### 🐛 Fixes

- 🛡️ Rollback apparmor

## 1.5.1-MatriX.137 [2026-01-05]

### 🐛 Fixes

- ⚡ Changed password config type to `str` and disabled startup safety checks to prevent timeouts caused by unreachable external APIs. [#89](https://github.com/aatrubilin/hassio-torrserver/issues/89)
- 🛡️ Replace incorrect AppArmor placeholder with a valid profile.

## 1.5.0-MatriX.137 [2025-12-25]

### ✨ New features

- 🕶 Upgraded TorrServer to **MatriX.137** ([changes](https://github.com/YouROK/TorrServer/releases/tag/MatriX.137))
- 🐕 Added **Watchdog** support to monitor addon health via the `/echo` endpoint.
- 📜 Added **Weblog** configuration option to enable/disable web access logging.

### 🐛 Fixes

- 🧹 Fixed Supervisor validation errors by removing the deprecated `codenotary` field.

### ⬆️ Dependency updates

- 📦 Update `ghcr.io/hassio-addons/base` Docker tag to **v19.0.0**

### 🚨 Breaking changes

- 🗑️ Drop support for `armhf`, `armv7`, and `i386` systems

## 1.4.0-MatriX.136 [2025-08-15]

### ✨ New features

- 🕶 Upgraded TorrServer to MatriX.136

## 1.4.0-MatriX.135 [2025-07-11]

### 🚨 Breaking changes

- Make sure to reset add-on options to defaults for proper display
- Switched to host network; Ingress still enabled, but will break if default port 8090 is changed

### ✨ New features

- 🔐 Added ssl options (#59)

### Fixes

- 📺 Fixed DLNA server issue @APushchin (#75)

### ⬆️ Dependency updates

- ⬆️ Update ghcr.io/hassio-addons/base Docker tag to v18.0.3

## 1.3.1-MatriX.135 [2025-04-28]

### Fixes

- 🔗 Fixed download playlist link
- 🔒 Force use https for image links

### 🚀 Enhancements

- 🎬 Added sidebar icon

## 1.3.0-MatriX.135 [2025-04-26]

### ✨ New features

- 🕶 Upgraded TorrServer to MatriX.135
- 🔑 Added `Telegram bot token` parameter
- 🌐 Added `Custom host for M3U playlist links` parameter
- 🇷🇺 Added Russian translation

### Fixes

- 🔗 Fixed TMDB links to use the correct HTTP/HTTPS scheme (#59)

### 🚀 Enhancements

- 🐳 Update Dockerfile

### ⬆️ Dependency updates

- ⬆️ Update ghcr.io/hassio-addons/base Docker tag to v17.2.4 @renovate (#64)

## 1.2.0-MatriX.134 [2025-01-20]

### 🚀 Enhancements

- 📺️ Added TMDB API key for uploading posters of added torrents @lemeshovich (#59)

## 1.1.0-MatriX.134 [2025-01-18]

### ⬆️ Dependency updates

- ⬆️ Update ghcr.io/hassio-addons/base Docker tag to v17.1.0 @renovate (#54)

## 1.0.0-MatriX.134 [2025-01-12]

### ⬆️ Dependency updates

- 🕶️Updated TorrServer to MatriX.134

## 1.0.0-MatriX.132 [2024-04-23]

### ✨ New features

- Added ingress feature for the addon ([#7](https://github.com/aatrubilin/hassio-torrserver/issues/7))
- Added optional basic authentication ([#17](https://github.com/aatrubilin/hassio-torrserver/issues/17))

### 🧰 Maintenance

- Prebuild image for addon
