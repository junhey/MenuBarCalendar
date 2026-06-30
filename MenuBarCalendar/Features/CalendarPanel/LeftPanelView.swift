import SwiftUI

struct LeftPanelView: View {
    @ObservedObject var viewModel: CalendarPanelViewModel
    @ObservedObject var settings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 8)

            PanelTimeDisplay(settings: settings, now: viewModel.now)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.dayDetail.gregorian)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                HStack(spacing: 8) {
                    Text(viewModel.dayDetail.weekday)
                    Text("·")
                        .foregroundStyle(.quaternary)
                    Text("第 \(viewModel.dayDetail.weekOfYear) 周")
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
            .padding(.top, settings.menuBarTimeStyle == .analog ? 4 : 0)

            Divider()
                .opacity(0.35)
                .padding(.vertical, 16)

            VStack(alignment: .leading, spacing: 8) {
                Text("周起始")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .textCase(.uppercase)
                    .tracking(0.3)

                Picker("周起始", selection: $settings.weekStartsOnMonday) {
                    Text("周一").tag(true)
                    Text("周日").tag(false)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
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
                    .padding(.top, 6)
            }

            if settings.showUpcomingFestivals || viewModel.nextSolarTerm != nil {
                VStack(alignment: .leading, spacing: 6) {
                    Text("即将到来")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                        .tracking(0.3)
                        .padding(.bottom, 2)

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
