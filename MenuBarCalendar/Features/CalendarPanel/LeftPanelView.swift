import SwiftUI

struct LeftPanelView: View {
    @ObservedObject var viewModel: CalendarPanelViewModel
    @ObservedObject var settings: UserSettings

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        switch settings.timeFormat {
        case .hour24:
            formatter.dateFormat = settings.showSeconds ? "HH:mm:ss" : "HH:mm"
        case .hour12:
            formatter.dateFormat = settings.showSeconds ? "h:mm:ss a" : "h:mm a"
        }
        return formatter.string(from: viewModel.now)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 12)

            Text(timeString)
                .font(.system(size: 56, weight: .thin, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .padding(.bottom, 2)

            Text(viewModel.dayDetail.gregorian)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                Label(viewModel.dayDetail.weekday, systemImage: "calendar")
                Text("第 \(viewModel.dayDetail.weekOfYear) 周")
            }
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .padding(.top, 6)

            Divider()
                .opacity(0.5)
                .padding(.vertical, 16)

            HStack(spacing: 8) {
                Text("周起始")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                PillToggle(title: "周一", isSelected: settings.weekStartsOnMonday) {
                    settings.weekStartsOnMonday = true
                }
                PillToggle(title: "周日", isSelected: !settings.weekStartsOnMonday) {
                    settings.weekStartsOnMonday = false
                }
            }

            GlassCard {
                DayDetailCard(
                    detail: viewModel.dayDetail,
                    isToday: viewModel.isSelectedToday,
                    onCopy: viewModel.copySelectedDate
                )
            }
            .padding(.top, 14)

            if viewModel.copiedFeedback {
                Text("已复制到剪贴板")
                    .font(.system(size: 10))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                if let solar = viewModel.nextSolarTerm {
                    CountdownRow(info: solar)
                }
                ForEach(viewModel.upcomingFestivals, id: \.targetDate) { festival in
                    CountdownRow(info: festival, compact: true)
                }
            }
            .padding(.top, 12)

            Spacer()

            HStack(spacing: 10) {
                Button("今天") {
                    viewModel.goToToday()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
                .controlSize(.small)
                .keyboardShortcut("t", modifiers: .command)

                Spacer()

                SettingsGearButton()
            }
            .padding(.bottom, 6)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(AppTheme.sidebarBackground)
    }
}
