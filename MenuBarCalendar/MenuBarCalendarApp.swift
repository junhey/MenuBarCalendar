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
        .commands {
            AppCommands()
        }

        Settings {
            SettingsView()
        }
    }
}

struct AppCommands: Commands {
    var body: some Commands {
        if #available(macOS 14.0, *) {
            AppSettingsCommands14()
        } else {
            CommandGroup(replacing: .appSettings) {
                Button("设置…") {
                    SettingsPresenter.show()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}

@available(macOS 14.0, *)
struct AppSettingsCommands14: Commands {
    @Environment(\.openSettings) private var openSettings

    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button("设置…") {
                NSApp.activate(ignoringOtherApps: true)
                openSettings()
            }
            .keyboardShortcut(",", modifiers: .command)
        }
    }
}

struct MenuBarRootView: View {
    @ObservedObject var clock: ClockService
    @ObservedObject var settings: UserSettings
    @StateObject private var voiceService = VoiceAnnouncementService()

    var body: some View {
        CalendarPanelView(clock: clock)
            .onAppear { clock.start() }
            .onReceive(clock.$now) { now in
                voiceService.handleTick(now: now, settings: settings)
            }
    }
}
