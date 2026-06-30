import SwiftUI

enum AppTheme {
    static let accent = Color.accentColor
    static let accentSoft = Color.accentColor.opacity(0.12)
    static let holidayGreen = Color(red: 0.22, green: 0.65, blue: 0.42)
    static let holidayGreenSoft = Color(red: 0.22, green: 0.65, blue: 0.42).opacity(0.10)

    static var panelBackground: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    static var sidebarBackground: Color {
        Color(nsColor: .controlBackgroundColor).opacity(0.45)
    }

    static var cardBackground: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static let subtleText = Color.secondary
    static let mutedDay = Color.secondary.opacity(0.38)
    static let cardShadow = Color.black.opacity(0.05)

    static let panelCornerRadius: CGFloat = 16
    static let panelWidth: CGFloat = 720
    static let panelHeight: CGFloat = 440
    static let sidebarWidth: CGFloat = 272

    static let cardCornerRadius: CGFloat = 10
    static let cellCornerRadius: CGFloat = 8
}

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .fill(AppTheme.cardBackground.opacity(0.7))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.05), lineWidth: 0.5)
            )
    }
}

struct CountdownRow: View {
    let info: CountdownInfo
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppTheme.accent.opacity(0.7))
                .frame(width: 4, height: 4)

            Text(info.title)
                .font(.system(size: compact ? 11 : 12))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer(minLength: 4)

            Text("\(info.daysRemaining) 天")
                .font(.system(size: compact ? 11 : 12, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.accent)
                .monospacedDigit()
        }
    }
}

struct DayDetailCard: View {
    let detail: DayDetail
    let isToday: Bool
    let onCopy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(isToday ? "今日" : "选中日期")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .textCase(.uppercase)
                    .tracking(0.3)

                Spacer()

                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 11))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tertiary)
                .help("复制日期")
            }

            Text(detail.lunarFull)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppTheme.accent)
                .lineLimit(2)

            if let festival = detail.festival {
                Label(festival, systemImage: "star.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(AppTheme.holidayGreen)
            } else if let term = detail.solarTerm {
                Label("节气 · \(term)", systemImage: "leaf")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
