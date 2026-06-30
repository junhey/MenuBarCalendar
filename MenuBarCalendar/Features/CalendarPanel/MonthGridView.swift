import SwiftUI

struct MonthGridView: View {
    @ObservedObject var viewModel: CalendarPanelViewModel
    @ObservedObject var settings: UserSettings

    private var weekdaySymbols: [String] {
        settings.weekStartsOnMonday
            ? ["一", "二", "三", "四", "五", "六", "日"]
            : ["日", "一", "二", "三", "四", "五", "六"]
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: viewModel.displayedMonth)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: viewModel.previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .semibold))
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.primary.opacity(0.04)))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("上个月 (←)")
                .keyboardShortcut(.leftArrow, modifiers: [])

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: viewModel.nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.primary.opacity(0.04)))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("下个月 (→)")
                .keyboardShortcut(.rightArrow, modifiers: [])
            }

            HStack(spacing: 4) {
                Text("周")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.quaternary)
                    .frame(width: 24)

                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            let data = viewModel.monthData
            ForEach(Array(data.weeks.enumerated()), id: \.offset) { index, week in
                HStack(spacing: 4) {
                    Text("\(data.weekNumbers.indices.contains(index) ? data.weekNumbers[index] : 0)")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.quaternary)
                        .frame(width: 24)

                    ForEach(0..<7, id: \.self) { col in
                        if let day = week.indices.contains(col) ? week[col] : nil {
                            DayCellView(
                                day: day,
                                isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                            ) {
                                viewModel.select(day.date)
                            } onCopy: {
                                viewModel.select(day.date)
                                viewModel.copySelectedDate()
                            }
                        } else {
                            Color.clear.frame(maxWidth: .infinity, minHeight: 46)
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }
}

private struct DayCellView: View {
    let day: CalendarDay
    let isSelected: Bool
    let onTap: () -> Void
    let onCopy: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(day.dayNumber)")
                    .font(.system(size: 14, weight: day.isToday ? .semibold : .regular, design: .rounded))
                    .foregroundStyle(dayTextColor)

                Text(day.festivalLabel ?? day.lunarLabel)
                    .font(.system(size: 8.5))
                    .lineLimit(1)
                    .foregroundStyle(subLabelColor)
            }
            .frame(maxWidth: .infinity, minHeight: 46)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cellCornerRadius, style: .continuous))
            .overlay {
                if day.isHoliday && day.isCurrentMonth && !day.isToday {
                    RoundedRectangle(cornerRadius: AppTheme.cellCornerRadius, style: .continuous)
                        .strokeBorder(AppTheme.holidayGreen.opacity(0.30), lineWidth: 0.5)
                }
            }
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("复制日期") { onCopy() }
            Button("跳转到此日") { onTap() }
        }
    }

    private var dayTextColor: Color {
        if day.isToday { return .white }
        if day.isHoliday && day.isCurrentMonth { return AppTheme.holidayGreen }
        if !day.isCurrentMonth { return AppTheme.mutedDay }
        if day.isWeekend { return .secondary }
        return .primary
    }

    private var subLabelColor: Color {
        if day.isToday { return .white.opacity(0.85) }
        if day.festivalLabel != nil && day.isCurrentMonth { return AppTheme.holidayGreen.opacity(0.85) }
        if !day.isCurrentMonth { return AppTheme.mutedDay }
        return .secondary.opacity(0.8)
    }

    @ViewBuilder
    private var background: some View {
        if day.isToday {
            RoundedRectangle(cornerRadius: AppTheme.cellCornerRadius, style: .continuous)
                .fill(AppTheme.accent)
        } else if isSelected {
            RoundedRectangle(cornerRadius: AppTheme.cellCornerRadius, style: .continuous)
                .fill(AppTheme.accentSoft)
        } else if day.isHoliday && day.isCurrentMonth {
            RoundedRectangle(cornerRadius: AppTheme.cellCornerRadius, style: .continuous)
                .fill(AppTheme.holidayGreenSoft)
        } else {
            Color.clear
        }
    }
}
