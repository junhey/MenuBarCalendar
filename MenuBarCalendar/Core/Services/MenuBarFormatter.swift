import Foundation

struct MenuBarFormatter {
    private let settings: UserSettings
    private let calendar: Calendar

    init(settings: UserSettings, calendar: Calendar = .current) {
        self.settings = settings
        self.calendar = calendar
    }

    func format(date: Date) -> MenuBarFormattedText {
        if settings.useIconOnly {
            return MenuBarFormattedText(text: "")
        }

        if settings.menuBarTimeStyle == .analog && settings.displayMode.includesTime {
            let suffix = nonTimeSuffix(for: date)
            return MenuBarFormattedText(
                text: suffix.isEmpty ? "" : suffix,
                usesAnalogIcon: true
            )
        }

        let text: String
        switch settings.displayMode {
        case .timeOnly:
            text = formatTime(date)
        case .timeAndDate:
            text = "\(formatTime(date))  \(formatDate(date))"
        case .timeAndWeekday:
            text = "\(formatTime(date))  \(formatWeekday(date))"
        case .timeDateWeekday:
            text = "\(formatTime(date))  \(formatDate(date))  \(formatWeekday(date))"
        case .timeDateLunar:
            text = "\(formatTime(date))  \(formatDate(date))  \(formatLunar(date))"
        case .dateOnly:
            text = formatDate(date)
        case .dateWeekday:
            text = "\(formatDate(date))  \(formatWeekday(date))"
        case .custom:
            text = formatCustom(date)
        }

        let segments: [MenuBarTimeSegment]?
        if settings.displayMode.includesTime && settings.blinkTimeSeparator {
            var timeSegs = timeSegments(for: date)
            let suffix = menuBarSuffix(for: date)
            if !suffix.isEmpty {
                timeSegs.append(MenuBarTimeSegment(text: "  " + suffix, isBlinkingSeparator: false))
            }
            segments = timeSegs
        } else {
            segments = nil
        }

        return MenuBarFormattedText(text: text, timeSegments: segments)
    }

    private func menuBarSuffix(for date: Date) -> String {
        switch settings.displayMode {
        case .timeOnly:
            return ""
        case .timeAndDate:
            return formatDate(date)
        case .timeAndWeekday:
            return formatWeekday(date)
        case .timeDateWeekday:
            return "\(formatDate(date))  \(formatWeekday(date))"
        case .timeDateLunar:
            return "\(formatDate(date))  \(formatLunar(date))"
        case .dateOnly, .dateWeekday, .custom:
            return ""
        }
    }

    private func nonTimeSuffix(for date: Date) -> String {
        switch settings.displayMode {
        case .timeOnly:
            return ""
        case .timeAndDate:
            return formatDate(date)
        case .timeAndWeekday:
            return formatWeekday(date)
        case .timeDateWeekday:
            return "\(formatDate(date))  \(formatWeekday(date))"
        case .timeDateLunar:
            return "\(formatDate(date))  \(formatLunar(date))"
        case .dateOnly, .dateWeekday, .custom:
            return format(date: date).text
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = timePattern(includeAMPM: settings.timeFormat == .hour12 && settings.showAMPM)
        return formatter.string(from: date)
    }

    private func timePattern(includeAMPM: Bool) -> String {
        switch settings.timeFormat {
        case .hour24:
            return settings.showSeconds ? "HH:mm:ss" : "HH:mm"
        case .hour12:
            if includeAMPM {
                return settings.showSeconds ? "h:mm:ss a" : "h:mm a"
            }
            return settings.showSeconds ? "h:mm:ss" : "h:mm"
        }
    }

    private func timeSegments(for date: Date) -> [MenuBarTimeSegment] {
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        guard let hour = components.hour, let minute = components.minute else { return [] }

        let second = components.second ?? 0
        let hourText: String
        let ampmText: String?

        switch settings.timeFormat {
        case .hour24:
            hourText = String(format: "%02d", hour)
            ampmText = nil
        case .hour12:
            let displayHour = hour % 12 == 0 ? 12 : hour % 12
            hourText = String(format: "%d", displayHour)
            ampmText = settings.showAMPM ? (hour < 12 ? "上午" : "下午") : nil
        }

        let minuteText = String(format: "%02d", minute)
        var segments: [MenuBarTimeSegment] = []

        if let ampm = ampmText {
            segments.append(MenuBarTimeSegment(text: ampm + " ", isBlinkingSeparator: false))
        }

        segments.append(MenuBarTimeSegment(text: hourText, isBlinkingSeparator: false))
        segments.append(MenuBarTimeSegment(text: ":", isBlinkingSeparator: true))
        segments.append(MenuBarTimeSegment(text: minuteText, isBlinkingSeparator: false))

        if settings.showSeconds {
            segments.append(MenuBarTimeSegment(text: ":", isBlinkingSeparator: true))
            segments.append(MenuBarTimeSegment(text: String(format: "%02d", second), isBlinkingSeparator: false))
        }

        return segments
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }

    private func formatWeekday(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func formatLunar(_ date: Date) -> String {
        LunarCalendarEngine.lunarShortLabel(for: date)
    }

    private func formatCustom(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        var pattern = settings.customFormat
        if settings.timeFormat == .hour12 {
            pattern = pattern
                .replacingOccurrences(of: "HH", with: "h")
                .replacingOccurrences(of: "H", with: "h")
            if !settings.showAMPM {
                pattern = pattern
                    .replacingOccurrences(of: " a", with: "")
                    .replacingOccurrences(of: "a", with: "")
            }
        }
        if !settings.showSeconds {
            pattern = pattern
                .replacingOccurrences(of: ":ss", with: "")
                .replacingOccurrences(of: " ss", with: "")
        }
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }
}

private extension MenuBarDisplayMode {
    var includesTime: Bool {
        switch self {
        case .timeOnly, .timeAndDate, .timeAndWeekday, .timeDateWeekday, .timeDateLunar, .custom:
            return true
        case .dateOnly, .dateWeekday:
            return false
        }
    }
}
