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
                .font(.system(size: 52, weight: .light, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .padding(.bottom, 4)

            Text(viewModel.dayDetail.gregorian)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                Label(viewModel.dayDetail.weekday, systemImage: "calendar")
                Text("第 \(viewModel.dayDetail.weekOfYear) 周")
            }
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .padding(.top, 4)

            Divider()
                .padding(.vertical, 14)

            HStack(spacing: 8) {
                Text("周起始")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                PillToggle(title: "周一", isSelected: settings.weekStartsOnMonday) {
                    settings.weekStartsOnMonday = true
                }
                PillToggle(title: "周日", isSelected: !settings.weekStartsOnMonday) {
                    settings.weekStartsOnMonday = false
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.dayDetail.lunarFull)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.accent)

                if let term = viewModel.dayDetail.solarTerm {
                    Text("今日节气 · \(term)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 14)

            VStack(alignment: .leading, spacing: 6) {
                if let solar = viewModel.nextSolarTerm {
                    CountdownRow(info: solar)
                }
                if let festival = viewModel.nextFestival {
                    CountdownRow(info: festival)
                }
            }
            .padding(.top, 12)

            Spacer()

            HStack {
                Button("今天") {
                    viewModel.goToToday()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
                .controlSize(.small)

                Spacer()

                Button {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } label: {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("设置")
            }
            .padding(.bottom, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(AppTheme.sidebarBackground)
    }
}
