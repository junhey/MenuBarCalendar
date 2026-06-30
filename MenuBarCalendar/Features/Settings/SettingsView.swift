import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared

    var body: some View {
        Form {
            Section("菜单栏显示") {
                Toggle("仅显示图标", isOn: $settings.useIconOnly)

                if !settings.useIconOnly {
                    Picker("显示内容", selection: $settings.displayMode) {
                        ForEach(MenuBarDisplayMode.allCases) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }

                    if settings.displayMode == .custom {
                        TextField("自定义格式", text: $settings.customFormat)
                        Text("支持 DateFormatter 格式，如 HH:mm EEE M/d")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("时间格式") {
                Picker("制式", selection: $settings.timeFormat) {
                    ForEach(TimeFormat.allCases) { format in
                        Text(format.displayName).tag(format)
                    }
                }
                Toggle("显示秒", isOn: $settings.showSeconds)
            }

            Section("日历") {
                Toggle("周起始日为周一", isOn: $settings.weekStartsOnMonday)
            }

            Section("预览") {
                HStack {
                    Text("菜单栏预览")
                    Spacer()
                    MenuBarLabelView(settings: settings, now: .now)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 380)
        .padding()
    }
}
