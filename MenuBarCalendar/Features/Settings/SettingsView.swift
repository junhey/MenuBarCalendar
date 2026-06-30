import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                timeDisplaySection
                menuBarSection
                calendarSection
                voiceSection
                shortcutsSection
                aboutSection

                HStack {
                    Spacer()
                    Button("完成") {
                        closeSettings()
                    }
                    .keyboardShortcut(.defaultAction)
                    .controlSize(.large)
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(24)
        }
        .frame(width: 480)
        .frame(minHeight: 560)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - Sections

    private var timeDisplaySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "时间显示")

            SettingsCard {
                SettingsRadioGroup(
                    options: MenuBarTimeStyle.allCases.map { ($0, $0.displayName) },
                    selection: $settings.menuBarTimeStyle
                )

                SettingsDivider()

                SettingsPickerRow(title: "时间制式", selection: $settings.timeFormat) {
                    ForEach(TimeFormat.allCases) { format in
                        Text(format.displayName).tag(format)
                    }
                }

                SettingsDivider()

                SettingsToggleRow(title: "显示上午/下午", isOn: $settings.showAMPM, disabled: settings.timeFormat == .hour24)
                SettingsDivider()
                SettingsToggleRow(title: "闪动时间分隔符", isOn: $settings.blinkTimeSeparator)
                SettingsDivider()
                SettingsToggleRow(title: "显示秒钟", isOn: $settings.showSeconds)
            }

            SettingsSectionFooter(text: "闪动分隔符使菜单栏与面板中的冒号每秒交替透明度，类似 macOS 时钟。")
        }
    }

    private var menuBarSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "菜单栏")

            SettingsCard {
                SettingsToggleRow(title: "仅显示图标", isOn: $settings.useIconOnly)

                if !settings.useIconOnly {
                    SettingsDivider()
                    SettingsPickerRow(title: "显示内容", selection: $settings.displayMode) {
                        ForEach(MenuBarDisplayMode.presets) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }

                    if settings.displayMode == .custom {
                        SettingsDivider()
                        SettingsTextFieldRow(title: "自定义格式", text: $settings.customFormat, placeholder: "HH:mm EEE M/d")
                    }
                }
            }

            if !settings.useIconOnly {
                MenuBarPreviewRow(settings: settings)
                    .padding(.top, 10)
            }

            if settings.displayMode == .custom {
                SettingsSectionFooter(text: "支持 DateFormatter 格式，如 HH:mm EEE M/d")
            }
        }
    }

    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "日历")

            SettingsCard {
                SettingsToggleRow(title: "周起始日为周一", isOn: $settings.weekStartsOnMonday)
                SettingsDivider()
                SettingsToggleRow(title: "显示近期节日倒计时", isOn: $settings.showUpcomingFestivals)
            }
        }
    }

    private var voiceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "语音报时")

            SettingsCard {
                SettingsToggleRow(title: "启用语音报时", isOn: $settings.voiceAnnouncementEnabled)

                if settings.voiceAnnouncementEnabled {
                    SettingsDivider()
                    SettingsPickerRow(title: "报时间隔", selection: $settings.voiceAnnouncementInterval) {
                        ForEach(VoiceAnnouncementInterval.allCases) { interval in
                            Text(interval.displayName).tag(interval)
                        }
                    }

                    SettingsDivider()
                    SettingsInfoRow(title: "报时声音", value: "系统默认")
                }
            }

            SettingsSectionFooter(text: "使用系统语音合成器以中文播报当前时间。自定义声音文件将在后续版本支持。")
        }
    }

    private var shortcutsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "快捷键")

            SettingsCard {
                SettingsInfoRow(title: "回到今天", value: "⌘ T")
                SettingsDivider()
                SettingsInfoRow(title: "打开设置", value: "⌘ ,")
                SettingsDivider()
                SettingsInfoRow(title: "切换月份", value: "← →")
                SettingsDivider()
                SettingsInfoRow(title: "复制日期", value: "右键日期")
            }
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionHeader(title: "关于")

            SettingsCard {
                SettingsInfoRow(title: "MenuBarCalendar", value: "0.0.1")
                SettingsDivider()
                SettingsInfoRow(title: "构建版本", value: "1")
                SettingsDivider()
                SettingsInfoRow(title: "许可证", value: "MIT")
            }

            SettingsSectionFooter(text: "macOS 菜单栏日历 — 农历、节气、节日与可定制时间显示。")
        }
    }

    private func closeSettings() {
        dismiss()
        if let window = NSApp.windows.first(where: { $0.title.contains("设置") || $0.title.contains("Settings") }) {
            window.close()
        }
    }
}

// MARK: - Menu Bar Preview

private struct MenuBarPreviewRow: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("菜单栏预览")
                .font(.system(size: 11))
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
