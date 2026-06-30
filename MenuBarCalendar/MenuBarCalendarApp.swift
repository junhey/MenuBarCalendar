import SwiftUI

@main
struct MenuBarCalendarApp: App {
    @StateObject private var clock = ClockService()
    @StateObject private var settings = UserSettings.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarRootView(clock: clock, settings: settings)
        } label: {
            MenuBarLabelView(settings: settings, now: clock.now)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }
}

struct MenuBarRootView: View {
    @ObservedObject var clock: ClockService
    @ObservedObject var settings: UserSettings

    var body: some View {
        CalendarPanelView(clock: clock)
            .onAppear { clock.start() }
    }
}
