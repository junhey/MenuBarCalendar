import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared

    var body: some View {
        Form {
            Section {
                Toggle("仅显示图标", isOn: $settings.useIconOnly)

                if !settings.useIconOnly {
                    Picker("显示内容", selection: $settings.displayMode) {
                        ForEach(MenuBarDisplayMode.presets) { mode in
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

                MenuBarPreviewRow(settings: settings)
            } header: {
                Text("菜单栏显示")
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
                Toggle("显示近期节日倒计时", isOn: $settings.showUpcomingFestivals)
            }

            Section("快捷键") {
                LabeledContent("回到今天") {
                    Text("⌘ T").foregroundStyle(.secondary)
                }
                LabeledContent("打开设置") {
                    Text("⌘ ,").foregroundStyle(.secondary)
                }
                LabeledContent("切换月份") {
                    Text("← →").foregroundStyle(.secondary)
                }
                LabeledContent("复制日期") {
                    Text("右键日期").foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 440, height: 480)
    }
}

// MARK: - Menu Bar Preview

private struct MenuBarPreviewRow: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("菜单栏预览")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Spacer()
                MenuBarLabelView(settings: settings, now: .now)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(nsColor: .windowBackgroundColor))
                    .shadow(color: .black.opacity(0.06), radius: 1, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
            )
        }
        .padding(.top, 4)
    }
}
