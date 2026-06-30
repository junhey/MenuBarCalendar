# MenuBarCalendar

[中文文档](README.zh-CN.md)

A lightweight macOS menu bar calendar built with SwiftUI `MenuBarExtra` (macOS 13+). Click the menu bar item to open a calendar panel with lunar calendar support, solar terms, festival countdowns, and a customizable digital clock.

**Current version: 0.0.2**

## Project Overview

MenuBarCalendar lives in the menu bar (no Dock icon) and focuses on three things: a readable clock in the menu bar, a rich calendar popover, and sensible defaults with minimal configuration.

Design principles:

- **Minimal** — core features only; small codebase and binary footprint
- **Native** — system `Form` for Settings, `MenuBarExtra` for the menu bar, `DateFormatter` for time display
- **Clean** — split calendar panel, frosted background, large lightweight digital clock

## Features

### Menu Bar

- Digital time display with 12/24-hour format, seconds, and AM/PM
- Display presets: time only, time + date, time + weekday, time + lunar date, and more
- Custom `DateFormatter` format strings
- Icon-only mode

### Calendar Panel

- **Left panel:** large digital clock, Gregorian/Lunar details, week-start toggle, solar-term and festival countdown
- **Right panel:** month grid with week numbers, lunar/festival labels, today highlight, holiday markers
- Copy date, jump to today (⌘T)

### Voice Announcements

- Optional Chinese time announcements via `NSSpeechSynthesizer`
- Intervals: hourly, every 30 minutes, or every 15 minutes

### Lunar Calendar Engine

- Gregorian ↔ Lunar conversion for 1900–2100
- Heavenly stems, earthly branches, zodiac, 24 solar terms, traditional festivals

## Screenshots

> Placeholder — add screenshots of the menu bar preview, calendar panel, and Settings window.

## Requirements

- **macOS 13.0** (Ventura) or later
- **Xcode 16+** recommended for building from source

## Build & Run

```bash
cd MenuBarCalendar
python3 generate_xcodeproj.py   # only if you changed the source file list
open MenuBarCalendar.xcodeproj
# Select the MenuBarCalendar scheme in Xcode, then press ⌘R
```

Command-line Release build:

```bash
xcodebuild -project MenuBarCalendar.xcodeproj \
  -scheme MenuBarCalendar \
  -configuration Release \
  -derivedDataPath build/DerivedData \
  build
```

## Install to Applications

```bash
cp -R build/DerivedData/Build/Products/Release/MenuBarCalendar.app ~/Applications/
open ~/Applications/MenuBarCalendar.app
```

After launch, the app icon appears in the menu bar. Click it to open the calendar panel.

## Settings

Open **Settings** from the gear icon in the panel footer, or **MenuBarCalendar → Settings** (⌘,):

| Section | Options |
|---------|---------|
| Time Display | 12/24-hour, AM/PM, seconds |
| Menu Bar | Display content, custom format, live preview |
| Calendar | Week starts on Monday, upcoming festival countdown |
| Voice | Enable announcements, interval |

Preferences are stored in `UserDefaults` and apply immediately.

## Architecture

```
MenuBarCalendar/
├── MenuBarCalendar/
│   ├── MenuBarCalendarApp.swift      # App entry, MenuBarExtra, Settings
│   ├── Core/
│   │   ├── Models/                   # Data models
│   │   ├── Services/                 # Clock, lunar, formatting, voice
│   │   └── Settings/                 # UserSettings
│   ├── Features/
│   │   ├── MenuBar/                  # Menu bar label
│   │   ├── CalendarPanel/            # Popover panel
│   │   └── Settings/                 # Settings (Form)
│   └── UI/Components/                # Theme and panel components
├── MenuBarCalendarTests/
└── MenuBarCalendar.xcodeproj
```

## Tests

```bash
xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar test
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes:

- [v0.0.2](https://github.com/junhey/MenuBarCalendar/releases/tag/v0.0.2) — streamlined UI, native Settings `Form`, smaller binary
- [v0.0.1](https://github.com/junhey/MenuBarCalendar/releases/tag/v0.0.1) — initial release with voice announcements and lunar calendar

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Contributors

- [junhey](https://github.com/junhey) — project maintainer
