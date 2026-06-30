import SwiftUI

enum AppTheme {
    static let accent = Color.accentColor
    static let accentSoft = Color.accentColor.opacity(0.14)
    static let holidayGreen = Color(red: 0.20, green: 0.68, blue: 0.42)
    static let holidayGreenSoft = Color(red: 0.20, green: 0.68, blue: 0.42).opacity(0.12)

    static var panelBackground: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    static var sidebarBackground: Color {
        Color(nsColor: .controlBackgroundColor).opacity(0.55)
    }

    static var cardBackground: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static let subtleText = Color.secondary
    static let mutedDay = Color.secondary.opacity(0.4)
    static let cardShadow = Color.black.opacity(0.06)

    static let panelCornerRadius: CGFloat = 18
    static let panelWidth: CGFloat = 720
    static let panelHeight: CGFloat = 440
    static let sidebarWidth: CGFloat = 280
}

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppTheme.cardBackground.opacity(0.85))
                    .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
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
                .font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 11)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.accent : Color.primary.opacity(0.06))
                )
                .foregroundStyle(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
    }
}

struct CountdownRow: View {
    let info: CountdownInfo
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppTheme.accent.opacity(0.85))
                .frame(width: 5, height: 5)

            Text(info.title)
                .font(.system(size: compact ? 11 : 12))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer(minLength: 4)

            Text("\(info.daysRemaining) 天")
                .font(.system(size: compact ? 11 : 12, weight: .semibold, design: .rounded))
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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(isToday ? "今日" : "选中日期")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.tertiary)
                    .textCase(.uppercase)

                Spacer()

                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 11))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
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
