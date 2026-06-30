import AppKit
import SwiftUI

@MainActor
enum SettingsPresenter {
    static func show() {
        NSApp.activate(ignoringOtherApps: true)
        if !NSApp.sendAction(Selector(("showSettingsWindow:")), to: NSApp, from: nil) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        }
    }
}

struct SettingsGearButton: View {
    var body: some View {
        if #available(macOS 14.0, *) {
            SettingsGearButtonModern()
        } else {
            gearButton(action: SettingsPresenter.show)
        }
    }

    private func gearButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "gearshape")
                .font(.system(size: 13))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .help("设置 (⌘,)")
    }
}

@available(macOS 14.0, *)
private struct SettingsGearButtonModern: View {
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        Button {
            NSApp.activate(ignoringOtherApps: true)
            openSettings()
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: 13))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .help("设置 (⌘,)")
    }
}
