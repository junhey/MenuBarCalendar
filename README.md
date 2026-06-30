# MenuBarCalendar

macOS 菜单栏日历应用，基于 SwiftUI `MenuBarExtra`（macOS 13+）构建。点击菜单栏即可查看精美日历面板，支持农历、节气、节日倒计时与高度可定制的时间显示。

**当前版本：0.0.1**

## 功能

### 菜单栏与时间
- **数码 / 指针样式**：数码为默认文字时间；指针样式在菜单栏显示时钟图标，面板内展示模拟表盘
- **时间制式**：12 / 24 小时制
- **显示秒钟**、**显示上午/下午**（12 小时制）
- **闪动分隔符**：冒号每秒交替透明度，类似 macOS 系统时钟
- **多种显示预设**：仅时间、时间+日期、时间+星期、农历等，支持自定义 `DateFormatter` 格式
- **仅图标模式**：菜单栏只显示日历图标

### 日历面板
- 左右分栏布局，层次清晰
- 左侧：大号时间（数码/指针）、公历/农历、周数、周起始日、节气/节日倒计时
- 右侧：月历网格（周数列、农历/节日标注、今日高亮、节假日绿色标记）

### 语音报时
- 开关控制，支持整点 / 每 30 分钟 / 每 15 分钟
- 使用 `NSSpeechSynthesizer` 中文播报当前时间

### 设置
- macOS 系统设置风格：分组卡片、行分隔、右侧控件对齐
- 底部「完成」按钮关闭设置窗口
- 关于页显示版本号

### 农历引擎
- 1900–2100 年农历转换、干支生肖、二十四节气、传统节日

## 系统要求

- macOS 13.0 或更高版本
- Xcode 16+（推荐）

## 构建与运行

```bash
cd MenuBarCalendar
open MenuBarCalendar.xcodeproj
# 在 Xcode 中选择 MenuBarCalendar scheme，⌘R 运行
```

或使用命令行 Release 构建：

```bash
xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar -configuration Release -derivedDataPath build/DerivedData build
cp -R build/DerivedData/Build/Products/Release/MenuBarCalendar.app ~/Applications/
open ~/Applications/MenuBarCalendar.app
```

运行后应用图标出现在菜单栏（无 Dock 图标）。点击即可展开日历面板。

## 运行测试

```bash
xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar test
```

## 设置说明

打开 **设置**（应用内左下角齿轮按钮，或菜单栏 `MenuBarCalendar` → `设置`，快捷键 ⌘,）：

| 分组 | 选项 | 说明 |
|------|------|------|
| 时间显示 | 数码 / 指针 | 菜单栏与面板时间样式 |
| 时间显示 | 时间制式 | 12 / 24 小时制 |
| 时间显示 | 显示上午/下午 | 12 小时制下是否显示 |
| 时间显示 | 闪动分隔符 | 冒号每秒闪动 |
| 时间显示 | 显示秒钟 | 是否显示秒 |
| 菜单栏 | 显示内容 | 多种预设或自定义格式 |
| 日历 | 周起始日 | 周一或周日 |
| 语音报时 | 启用 / 间隔 | 整点或定间隔中文播报 |

设置保存在 `UserDefaults`，立即生效。

## 项目结构

```
MenuBarCalendar/
├── MenuBarCalendar/
│   ├── MenuBarCalendarApp.swift      # 应用入口、MenuBarExtra
│   ├── Core/
│   │   ├── Models/                   # 数据模型
│   │   ├── Services/                 # 时钟、农历、格式化、语音报时
│   │   └── Settings/                 # UserSettings
│   ├── Features/
│   │   ├── MenuBar/                  # 菜单栏标签视图
│   │   ├── CalendarPanel/            # 弹窗面板 UI + ViewModel
│   │   └── Settings/                 # 设置界面
│   └── UI/Components/                # 主题、系统设置风格组件
├── MenuBarCalendarTests/             # 单元测试
└── MenuBarCalendar.xcodeproj
```

## 架构说明

- **分层**：`Core`（纯逻辑）→ `Features`（UI + ViewModel）→ `App`（组合根）
- **可测试**：农历引擎、日历网格、菜单栏格式化、中文报时均有单元测试
- **可扩展**：新增节日/设置项只需扩展 `HolidayCatalog` 或 `UserSettings`

## 许可证

MIT
