import Foundation

struct MenuBarFormatter {
    private let settings: UserSettings

    init(settings: UserSettings) {
        self.settings = settings
    }

    func format(date: Date) -> MenuBarFormattedText {
        if settings.useIconOnly {
            return MenuBarFormattedText(text: "")
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

        return MenuBarFormattedText(text: text)
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
