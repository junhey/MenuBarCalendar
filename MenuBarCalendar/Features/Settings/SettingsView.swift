import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared

    var body: some View {
        Form {
            Section {
                Picker("时间制式", selection: $settings.timeFormat) {
                    ForEach(TimeFormat.allCases) { format in
                        Text(format.displayName).tag(format)
                    }
                }
                Toggle("显示上午/下午", isOn: $settings.showAMPM)
                    .disabled(settings.timeFormat == .hour24)
                Toggle("显示秒钟", isOn: $settings.showSeconds)
            } header: {
                Text("时间显示")
            }

            Section {
                Toggle("仅显示图标", isOn: $settings.useIconOnly)

                if !settings.useIconOnly {
                    Picker("显示内容", selection: $settings.displayMode) {
                        ForEach(MenuBarDisplayMode.presets) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }

                    if settings.displayMode == .custom {
                        TextField("自定义格式", text: $settings.customFormat, prompt: Text("HH:mm EEE M/d"))
                    }
                }
            } header: {
                Text("菜单栏")
            } footer: {
                if settings.displayMode == .custom {
                    Text("支持 DateFormatter 格式，如 HH:mm EEE M/d")
                }
            }

            if !settings.useIconOnly {
                Section {
                    MenuBarPreviewRow(settings: settings)
                }
            }

            Section {
                Toggle("周起始日为周一", isOn: $settings.weekStartsOnMonday)
                Toggle("显示近期节日倒计时", isOn: $settings.showUpcomingFestivals)
            } header: {
                Text("日历")
            }

            Section {
                Toggle("启用语音报时", isOn: $settings.voiceAnnouncementEnabled)

                if settings.voiceAnnouncementEnabled {
                    Picker("报时间隔", selection: $settings.voiceAnnouncementInterval) {
                        ForEach(VoiceAnnouncementInterval.allCases) { interval in
                            Text(interval.displayName).tag(interval)
                        }
                    }
                }
            } header: {
                Text("语音报时")
            } footer: {
                if settings.voiceAnnouncementEnabled {
                    Text("使用系统语音以中文播报当前时间。")
                }
            }

            Section {
                LabeledContent("回到今天", value: "⌘ T")
                LabeledContent("打开设置", value: "⌘ ,")
                LabeledContent("切换月份", value: "← →")
                LabeledContent("复制日期", value: "右键日期")
            } header: {
                Text("快捷键")
            }
        }
        .formStyle(.grouped)
        .frame(width: 450)
        .frame(minHeight: 480)
    }
}

// MARK: - Menu Bar Preview

private struct MenuBarPreviewRow: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("菜单栏预览")
                .font(.caption)
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
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 0.5)
            )
        }
    }
}
