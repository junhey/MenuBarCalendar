import AppKit
import Foundation

@MainActor
final class VoiceAnnouncementService: ObservableObject {
    private let synthesizer = NSSpeechSynthesizer()
    private var lastAnnouncedSlot: String?

    func handleTick(now: Date, settings: UserSettings, calendar: Calendar = .current) {
        guard settings.voiceAnnouncementEnabled else {
            lastAnnouncedSlot = nil
            return
        }

        let components = calendar.dateComponents([.hour, .minute], from: now)
        guard let hour = components.hour, let minute = components.minute else { return }

        let interval = settings.voiceAnnouncementInterval.rawValue
        guard minute % interval == 0 else { return }

        let slot = "\(hour)-\(minute / interval)"
        guard slot != lastAnnouncedSlot else { return }
        lastAnnouncedSlot = slot

        let text = ChineseTimeAnnouncer.announcement(for: now, settings: settings, calendar: calendar)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking()
        }
        if let voice = NSSpeechSynthesizer.availableVoices.first(where: {
            $0.rawValue.contains("Ting-Ting") || $0.rawValue.contains("Meijia")
        }) {
            synthesizer.setVoice(voice)
        }
        synthesizer.startSpeaking(text)
    }
}

enum ChineseTimeAnnouncer {
    static func announcement(for date: Date, settings: UserSettings, calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            return "现在时间"
        }

        let second = components.second ?? 0
        var parts = ["现在时间"]

        switch settings.timeFormat {
        case .hour24:
            parts.append("\(hour)点")
        case .hour12:
            let period = hour < 12 ? "上午" : "下午"
            let displayHour = hour % 12 == 0 ? 12 : hour % 12
            if settings.showAMPM {
                parts.append(period)
            }
            parts.append("\(displayHour)点")
        }

        if minute == 0 && !settings.showSeconds {
            parts.append("整")
        } else {
            parts.append("\(minute)分")
            if settings.showSeconds && second > 0 {
                parts.append("\(second)秒")
            }
        }

        return parts.joined()
    }
}
