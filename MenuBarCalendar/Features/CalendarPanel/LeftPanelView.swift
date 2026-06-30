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
            Spacer(minLength: 8)

            Text(timeString)
                .font(.system(size: 52, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .padding(.bottom, 4)

            Text(viewModel.dayDetail.gregorian)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                Text(viewModel.dayDetail.weekday)
                Text("·")
                    .foregroundStyle(.quaternary)
                Text("第 \(viewModel.dayDetail.weekOfYear) 周")
            }
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .padding(.top, 4)

            Divider()
                .opacity(0.35)
                .padding(.vertical, 18)

            Picker("周起始", selection: $settings.weekStartsOnMonday) {
                Text("周一").tag(true)
                Text("周日").tag(false)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            GlassCard {
                DayDetailCard(
                    detail: viewModel.dayDetail,
                    isToday: viewModel.isSelectedToday,
                    onCopy: viewModel.copySelectedDate
                )
            }
            .padding(.top, 16)

            if viewModel.copiedFeedback {
                Text("已复制到剪贴板")
                    .font(.system(size: 10))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.top, 6)
            }

            if settings.showUpcomingFestivals || viewModel.nextSolarTerm != nil {
                VStack(alignment: .leading, spacing: 6) {
                    if let solar = viewModel.nextSolarTerm {
                        CountdownRow(info: solar)
                    }
                    if settings.showUpcomingFestivals {
                        ForEach(viewModel.upcomingFestivals, id: \.targetDate) { festival in
                            CountdownRow(info: festival, compact: true)
                        }
                    }
                }
                .padding(.top, 14)
            }

            Spacer()

            HStack(spacing: 10) {
                Button("今天") {
                    viewModel.goToToday()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .keyboardShortcut("t", modifiers: .command)

                Spacer()

                SettingsGearButton()
            }
            .padding(.bottom, 4)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(AppTheme.sidebarBackground)
    }
}
