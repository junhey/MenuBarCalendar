import SwiftUI

struct CalendarPanelView: View {
    @StateObject private var viewModel: CalendarPanelViewModel
    @ObservedObject private var settings = UserSettings.shared

    init(clock: ClockService) {
        _viewModel = StateObject(wrappedValue: CalendarPanelViewModel(clock: clock))
    }

    var body: some View {
        HStack(spacing: 0) {
            LeftPanelView(viewModel: viewModel, settings: settings)
                .frame(width: AppTheme.sidebarWidth)

            Divider()
                .opacity(0.3)

            MonthGridView(viewModel: viewModel, settings: settings)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: AppTheme.panelWidth, height: AppTheme.panelHeight)
        .background {
            RoundedRectangle(cornerRadius: AppTheme.panelCornerRadius, style: .continuous)
                .fill(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.panelCornerRadius, style: .continuous))
        .shadow(color: AppTheme.cardShadow, radius: 24, y: 8)
    }
}
