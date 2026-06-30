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
                        .font(.system(size: 12, weight: .semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                Button(action: viewModel.nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)

            HStack(spacing: 0) {
                Text("周")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 28)

                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            let data = viewModel.monthData
            ForEach(Array(data.weeks.enumerated()), id: \.offset) { index, week in
                HStack(spacing: 0) {
                    Text("\(data.weekNumbers.indices.contains(index) ? data.weekNumbers[index] : 0)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .frame(width: 28)

                    ForEach(0..<7, id: \.self) { col in
                        if let day = week.indices.contains(col) ? week[col] : nil {
                            DayCellView(
                                day: day,
                                isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                            ) {
                                viewModel.select(day.date)
                            }
                        } else {
                            Color.clear.frame(maxWidth: .infinity, minHeight: 44)
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

private struct DayCellView: View {
    let day: CalendarDay
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(day.dayNumber)")
                    .font(.system(size: 14, weight: day.isToday ? .bold : .medium, design: .rounded))
                    .foregroundStyle(dayTextColor)

                Text(day.festivalLabel ?? day.lunarLabel)
                    .font(.system(size: 9))
                    .lineLimit(1)
                    .foregroundStyle(subLabelColor)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
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
        if day.festivalLabel != nil && day.isCurrentMonth { return AppTheme.holidayGreen }
        if !day.isCurrentMonth { return AppTheme.mutedDay }
        return .secondary
    }

    @ViewBuilder
    private var background: some View {
        if day.isToday {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(AppTheme.accent)
        } else if isSelected {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(AppTheme.accentSoft)
        } else {
            Color.clear
        }
    }
}
