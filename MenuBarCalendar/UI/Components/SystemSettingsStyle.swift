import SwiftUI

// MARK: - macOS System Settings Style Components

struct SettingsSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 6)
    }
}

struct SettingsSectionFooter: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 6)
    }
}

struct SettingsCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 0.5)
        )
    }
}

struct SettingsDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 16)
    }
}

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var disabled: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)
                .disabled(disabled)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .opacity(disabled ? 0.45 : 1)
    }
}

struct SettingsPickerRow<Selection: Hashable, Content: View>: View {
    let title: String
    @Binding var selection: Selection
    @ViewBuilder let content: Content

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Picker("", selection: $selection) {
                content
            }
            .labelsHidden()
            .frame(width: 160)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct SettingsRadioGroup<Selection: Hashable>: View {
    let options: [(Selection, String)]
    @Binding var selection: Selection

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button {
                    selection = option.0
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: selection == option.0 ? "largecircle.fill.circle" : "circle")
                            .font(.system(size: 14))
                            .foregroundStyle(selection == option.0 ? Color.accentColor : .secondary)
                        Text(option.1)
                            .font(.system(size: 13))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < options.count - 1 {
                    SettingsDivider()
                }
            }
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct SettingsTextFieldRow: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Analog Clock

struct AnalogClockView: View {
    let date: Date
    var size: CGFloat = 120

    private var hourAngle: Double {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: date) % 12)
        let minute = Double(calendar.component(.minute, from: date))
        return (hour + minute / 60) * 30
    }

    private var minuteAngle: Double {
        let minute = Double(Calendar.current.component(.minute, from: date))
        let second = Double(Calendar.current.component(.second, from: date))
        return (minute + second / 60) * 6
    }

    private var secondAngle: Double {
        Double(Calendar.current.component(.second, from: date)) * 6
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1.5)

            ForEach(0..<12, id: \.self) { tick in
                Rectangle()
                    .fill(Color.primary.opacity(tick % 3 == 0 ? 0.35 : 0.15))
                    .frame(width: tick % 3 == 0 ? 1.5 : 1, height: tick % 3 == 0 ? 6 : 4)
                    .offset(y: -(size / 2 - 10))
                    .rotationEffect(.degrees(Double(tick) * 30))
            }

            ClockHand(length: size * 0.22, width: 3, angle: hourAngle)
            ClockHand(length: size * 0.32, width: 2, angle: minuteAngle)
            ClockHand(length: size * 0.36, width: 1, angle: secondAngle, color: .accentColor)

            Circle()
                .fill(Color.primary.opacity(0.8))
                .frame(width: 5, height: 5)
        }
        .frame(width: size, height: size)
    }
}

private struct ClockHand: View {
    let length: CGFloat
    let width: CGFloat
    let angle: Double
    var color: Color = .primary

    var body: some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(.degrees(angle))
    }
}

// MARK: - Panel Time Display

struct PanelTimeDisplay: View {
    @ObservedObject var settings: UserSettings
    let now: Date

    private var separatorVisible: Bool {
        Calendar.current.component(.second, from: now) % 2 == 0
    }

    var body: some View {
        if settings.menuBarTimeStyle == .analog {
            AnalogClockView(date: now, size: 130)
                .padding(.bottom, 8)
        } else if settings.blinkTimeSeparator {
            panelBlinkingTime
                .font(.system(size: 52, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
        } else {
            Text(panelTimeString)
                .font(.system(size: 52, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
        }
    }

    private var panelTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = panelTimePattern()
        return formatter.string(from: now)
    }

    private var panelBlinkingTime: some View {
        let segments = MenuBarFormatter(settings: settings).format(date: now).timeSegments ?? []
        return HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                Text(segment.text)
                    .opacity(segment.isBlinkingSeparator && !separatorVisible ? 0.25 : 1)
            }
        }
    }

    private func panelTimePattern() -> String {
        switch settings.timeFormat {
        case .hour24:
            return settings.showSeconds ? "HH:mm:ss" : "HH:mm"
        case .hour12:
            if settings.showAMPM {
                return settings.showSeconds ? "h:mm:ss a" : "h:mm a"
            }
            return settings.showSeconds ? "h:mm:ss" : "h:mm"
        }
    }
}
