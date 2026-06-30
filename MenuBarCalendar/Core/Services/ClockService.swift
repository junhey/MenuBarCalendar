import Foundation
import Combine

@MainActor
final class ClockService: ObservableObject {
    @Published private(set) var now: Date = .now

    private var timer: AnyCancellable?

    init() {
        start()
    }

    func start() {
        now = .now
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.now = date
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }
}
