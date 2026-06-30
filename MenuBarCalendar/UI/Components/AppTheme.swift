import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.22, green: 0.55, blue: 0.98)
    static let accentSoft = Color(red: 0.22, green: 0.55, blue: 0.98).opacity(0.12)
    static let holidayGreen = Color(red: 0.18, green: 0.72, blue: 0.45)
    static let panelBackground = Color(nsColor: .windowBackgroundColor)
    static let sidebarBackground = Color(nsColor: .controlBackgroundColor)
    static let subtleText = Color.secondary
    static let mutedDay = Color.secondary.opacity(0.45)
    static let cardShadow = Color.black.opacity(0.08)

    static let panelCornerRadius: CGFloat = 16
    static let panelWidth: CGFloat = 680
    static let panelHeight: CGFloat = 420
}

struct RoundedCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
    }
}

struct PillToggle: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.accent : Color(nsColor: .separatorColor).opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

struct CountdownRow: View {
    let info: CountdownInfo

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "hourglass")
                .font(.system(size: 11))
                .foregroundStyle(AppTheme.accent)
            Text(info.title)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(info.daysRemaining) 天")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.accent)
        }
    }
}
