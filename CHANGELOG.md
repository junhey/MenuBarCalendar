# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2026-06-30

### Added

- README badges (license, macOS, Swift, release version, CI, stars)
- GitHub Actions CI workflow (Release build + unit tests on macOS)
- `CODE_OF_CONDUCT.md` (Contributor Covenant)
- GitHub Releases distribution with downloadable `.zip` artifact
- Installation instructions in README (Releases download or build from source)

### Changed

- Professionalized commit history (English conventional messages, no tooling co-author trailers)
- English-first documentation defaults; bilingual README maintained

### 中文摘要

- 新增 README 徽章、GitHub Actions CI、行为准则
- 通过 GitHub Releases 提供 zip 安装包；README 补充安装说明
- 提交历史专业化（英文 conventional commit，移除 AI 工具署名）

## [0.0.2] - 2026-06-30

### Changed

- Streamlined the app: removed analog clock, blinking time separator, About page, and the Settings “Done” button
- Settings now use the native macOS `Form` instead of custom grouped cards
- Removed `SystemSettingsStyle` custom UI components
- Release binary size reduced by approximately 25%

### Removed

- Pointer-style clock display
- Blinking colon separator option
- Dedicated About page in Settings

## [0.0.1] - 2026-06-30

### Added

- Initial public release
- Menu bar calendar with `MenuBarExtra` (macOS 13+)
- Digital menu bar time with 12/24-hour, seconds, AM/PM, presets, and custom `DateFormatter` formats
- Calendar panel with Gregorian/Lunar details, solar terms, and festival countdown
- Voice announcements via `NSSpeechSynthesizer` (hourly / 30 min / 15 min intervals)
- Lunar calendar engine (1900–2100), week numbers, holiday markers
- Unit tests for the lunar calendar engine

[0.0.3]: https://github.com/junhey/MenuBarCalendar/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/junhey/MenuBarCalendar/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/junhey/MenuBarCalendar/releases/tag/v0.0.1
