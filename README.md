# MenuBarCalendar

macOS 菜单栏日历应用，基于 SwiftUI `MenuBarExtra`（macOS 13+）构建。点击菜单栏即可查看精美日历面板，支持农历、节气、节日倒计时与高度可定制的菜单栏显示。

## 功能

- **菜单栏显示**：实时时间、日期、星期，多种预设格式与自定义 `DateFormatter` 模式
- **日历弹窗**：左右分栏布局
  - 左侧：大号时钟、公历/农历、周数、周起始日切换、节气/节日倒计时、「今天」按钮
  - 右侧：月历网格（周数列、农历/节日标注、今日高亮、节假日绿色标记）
- **农历引擎**：1900–2100 年农历转换、干支生肖、二十四节气、传统节日
- **设置面板**：系统设置中配置菜单栏显示内容与时间格式

## 系统要求

- macOS 13.0 或更高版本
- Xcode 16+（推荐）

## 构建与运行

```bash
cd MenuBarCalendar
open MenuBarCalendar.xcodeproj
# 在 Xcode 中选择 MenuBarCalendar scheme，⌘R 运行
```

或使用命令行：

```bash
xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar -configuration Debug build
open ~/Library/Developer/Xcode/DerivedData/MenuBarCalendar-*/Build/Products/Debug/MenuBarCalendar.app
```

运行后应用图标出现在菜单栏（无 Dock 图标）。点击即可展开日历面板。

## 运行测试

```bash
xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar test
```

## 菜单栏自定义

打开 **系统设置**（应用内左下角齿轮按钮，或菜单栏 `MenuBarCalendar` → `设置`）：

| 选项 | 说明 |
|------|------|
| 仅显示图标 | 菜单栏只显示日历图标 |
| 显示内容 | 仅时间 / 时间+日期 / 时间+星期 / 完整 / 自定义 |
| 自定义格式 | 如 `HH:mm EEE M/d`，遵循 `DateFormatter` 语法 |
| 时间制式 | 12 / 24 小时制 |
| 显示秒 | 是否在菜单栏显示秒 |
| 周起始日 | 周一或周日（影响月历网格） |

设置保存在 `UserDefaults`，立即生效。

## 项目结构

```
MenuBarCalendar/
├── MenuBarCalendar/
│   ├── MenuBarCalendarApp.swift      # 应用入口、MenuBarExtra
│   ├── Core/
│   │   ├── Models/                   # 数据模型
│   │   ├── Services/                 # 时钟、农历、日历引擎、格式化
│   │   └── Settings/                 # UserSettings
│   ├── Features/
│   │   ├── MenuBar/                  # 菜单栏标签视图
│   │   ├── CalendarPanel/            # 弹窗面板 UI + ViewModel
│   │   └── Settings/                 # 设置界面
│   └── UI/Components/                  # 主题、通用组件
├── MenuBarCalendarTests/             # 单元测试
└── MenuBarCalendar.xcodeproj
```

## 架构说明

- **分层**：`Core`（纯逻辑）→ `Features`（UI + ViewModel）→ `App`（组合根）
- **可测试**：农历引擎、日历网格、菜单栏格式化均有单元测试
- **可扩展**：新增节日/设置项只需扩展 `HolidayCatalog` 或 `UserSettings`

## 许可证

MIT
