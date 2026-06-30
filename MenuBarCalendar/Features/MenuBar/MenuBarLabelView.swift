import SwiftUI

struct MenuBarLabelView: View {
    @ObservedObject var settings: UserSettings
    let now: Date

    private var formatted: MenuBarFormattedText {
        MenuBarFormatter(settings: settings).format(date: now)
    }

    private var separatorVisible: Bool {
        Calendar.current.component(.second, from: now) % 2 == 0
    }

    var body: some View {
        if settings.useIconOnly {
            Image(systemName: "calendar")
                .font(.system(size: 13, weight: .medium))
        } else if formatted.usesAnalogIcon {
            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .medium))
                if !formatted.text.isEmpty {
                    Text(formatted.text)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
            }
        } else if let segments = formatted.timeSegments, !segments.isEmpty {
            HStack(spacing: 0) {
                ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                    Text(segment.text)
                        .opacity(segment.isBlinkingSeparator && !separatorVisible ? 0.25 : 1)
                }
            }
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .monospacedDigit()
        } else if formatted.text.isEmpty {
            Image(systemName: "calendar")
                .font(.system(size: 13, weight: .medium))
        } else {
            Text(formatted.text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .monospacedDigit()
        }
    }
}
