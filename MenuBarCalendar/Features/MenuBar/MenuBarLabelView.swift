import SwiftUI

struct MenuBarLabelView: View {
    @ObservedObject var settings: UserSettings
    let now: Date

    private var formatted: MenuBarFormattedText {
        MenuBarFormatter(settings: settings).format(date: now)
    }

    var body: some View {
        if settings.useIconOnly {
            Image(systemName: "calendar")
                .font(.system(size: 13, weight: .medium))
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
