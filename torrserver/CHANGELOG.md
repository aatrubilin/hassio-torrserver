# Changelog

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
