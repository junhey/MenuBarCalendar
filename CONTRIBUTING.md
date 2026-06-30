# Contributing to MenuBarCalendar

Thank you for your interest in contributing! This project is a small, focused macOS menu bar utility. Contributions that keep the codebase lean and native are especially welcome.

## Getting Started

1. Fork the repository and clone your fork locally.
2. Open `MenuBarCalendar.xcodeproj` in Xcode 16+ (or run `python3 generate_xcodeproj.py` if you changed the source file list).
3. Build and run the **MenuBarCalendar** scheme (⌘R).

## Development Guidelines

- **Keep it minimal** — prefer native APIs (`MenuBarExtra`, `Form`, `DateFormatter`) over custom UI chrome.
- **Match existing style** — follow Swift naming and file layout under `Core/`, `Features/`, and `UI/`.
- **Test when relevant** — run unit tests before submitting:

  ```bash
  xcodebuild -project MenuBarCalendar.xcodeproj -scheme MenuBarCalendar test
  ```

## Submitting Changes

1. Create a feature branch from `main`.
2. Write clear commit messages (imperative mood, concise subject line).
3. Open a pull request against `main` with:
   - A short summary of what changed and why
   - Screenshots for UI changes (if applicable)
   - Confirmation that tests pass locally

## Reporting Issues

Please use [GitHub Issues](https://github.com/junhey/MenuBarCalendar/issues) and include:

- macOS version
- MenuBarCalendar version
- Steps to reproduce
- Expected vs. actual behavior

## Code of Conduct

Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Be respectful and constructive — we aim for a welcoming environment for all contributors.

---

# 参与贡献（中文）

感谢你对 MenuBarCalendar 的关注！本项目是轻量 macOS 菜单栏工具，欢迎保持代码精简、尽量使用系统原生 API 的改动。

## 开始

1. Fork 仓库并克隆到本地。
2. 用 Xcode 16+ 打开 `MenuBarCalendar.xcodeproj`（若修改了源文件列表，先运行 `python3 generate_xcodeproj.py`）。
3. 选择 **MenuBarCalendar** scheme 构建运行（⌘R）。

## 提交改动

1. 从 `main` 创建功能分支。
2. 提交信息简洁清晰。
3. 向 `main` 发起 Pull Request，说明改动原因；UI 变更请附截图；确认本地测试通过。

## 反馈问题

请在 [GitHub Issues](https://github.com/junhey/MenuBarCalendar/issues) 中提供 macOS 版本、应用版本、复现步骤及期望与实际行为。
