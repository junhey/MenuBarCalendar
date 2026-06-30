import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared

    var body: some View {
        Form {
            Section("菜单栏显示") {
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

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 8) {
                        ForEach(MenuBarDisplayMode.presets.filter { $0 != .custom }) { mode in
                            Button {
                                settings.displayMode = mode
                            } label: {
                                Text(mode.displayName)
                                    .font(.system(size: 11))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.bordered)
                            .tint(settings.displayMode == mode ? AppTheme.accent : .secondary)
                        }
                    }
                    .padding(.vertical, 4)
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

            Section("预览") {
                HStack {
                    Text("菜单栏预览")
                    Spacer()
                    MenuBarLabelView(settings: settings, now: .now)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 460, height: 520)
        .padding()
    }
}
