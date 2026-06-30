# MenuBarCalendar

macOS 菜单栏日历应用，基于 SwiftUI `MenuBarExtra`（macOS 13+）构建。点击菜单栏即可查看日历面板，支持农历、节气、节日倒计时与可定制的数码时间显示。

**当前版本：0.0.2**

## 设计理念

- **精简**：只保留核心能力，去掉花哨选项，代码与体积尽量小
- **原生**：设置页使用系统 `Form`，菜单栏用 `MenuBarExtra`，时间格式用 `DateFormatter`
- **大气**：面板左右分栏、毛玻璃背景、大号轻量数码时钟，视觉干净专业

## 功能

### 菜单栏
- 数码时间显示，支持 12 / 24 小时制、秒钟、上午/下午
- 多种显示预设：仅时间、时间+日期、时间+星期、农历等
- 自定义 `DateFormatter` 格式
- 仅图标模式

### 日历面板
- 左侧：大号数码时钟、公历/农历详情、周起始切换、节气/节日倒计时
- 右侧：月历网格（周数、农历/节日标注、今日高亮、节假日标记）
- 复制日期、回到今天（⌘T）

### 语音报时
- 可选开启，支持整点 / 每 30 分钟 / 每 15 分钟
- 系统 `NSSpeechSynthesizer` 中文播报

### 农历引擎
- 1900–2100 年农历转换、干支生肖、二十四节气、传统节日

## 截图

> 截图占位：菜单栏预览、日历面板、设置页（待补充）

## 系统要求

- macOS 13.0 或更高版本
- Xcode 16+（推荐）

## 构建与运行

```bash
cd MenuBarCalendar
python3 generate_xcodeproj.py   # 若修改了源文件列表
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

## 设置

打开 **设置**（面板左下角齿轮，或菜单栏 `MenuBarCalendar` → `设置`，快捷键 ⌘,）：

| 分组 | 选项 |
|------|------|
| 时间显示 | 时间制式、上午/下午、秒钟 |
| 菜单栏 | 显示内容、自定义格式、预览 |
| 日历 | 周起始日、节日倒计时 |
| 语音报时 | 开关、报时间隔 |

设置保存在 `UserDefaults`，立即生效。

## 项目结构

```
MenuBarCalendar/
├── MenuBarCalendar/
│   ├── MenuBarCalendarApp.swift      # 应用入口、MenuBarExtra、Settings
│   ├── Core/
│   │   ├── Models/                   # 数据模型
│   │   ├── Services/                 # 时钟、农历、格式化、语音报时
│   │   └── Settings/                 # UserSettings
│   ├── Features/
│   │   ├── MenuBar/                  # 菜单栏标签
│   │   ├── CalendarPanel/            # 弹窗面板
│   │   └── Settings/                 # 设置（Form）
│   └── UI/Components/                # 主题与面板组件
├── MenuBarCalendarTests/
└── MenuBarCalendar.xcodeproj
```

## 许可证

MIT
