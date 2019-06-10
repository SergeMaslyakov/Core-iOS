import UIKit

/// Min refresh interval = 0.1 ms
public final class RefreshJobWorker {

    private var refreshTimer: Timer?
    private var refreshInterval: TimeInterval = 1

    private var shouldRepeat = true
    private var halted = true

    private var refreshJob: (() -> Void)?

    public init() {
        subscribeOnNotifications()
    }

    deinit {
        invalidateRefreshTimer()
    }

    // MARK: - Public interface

    public func start(refreshInterval: TimeInterval, shouldRepeat: Bool = true, refreshJob: @escaping () -> Void) {
        self.refreshInterval = max(0.1, refreshInterval)
        self.refreshJob = refreshJob
        self.shouldRepeat = shouldRepeat

        halted = false
        scheduleNextRefreshTime()
    }

    public func stop() {
        invalidateRefreshTimer()
        halted = true
    }

    // MARK: - Private

    private func scheduleNextRefreshTime() {
        let refreshTimer = Timer(timeInterval: refreshInterval,
                                 target: self,
                                 selector: #selector(refreshJobHandler),
                                 userInfo: nil,
                                 repeats: false)

        RunLoop.main.add(refreshTimer, forMode: .common)
        self.refreshTimer = refreshTimer
    }

    private func invalidateRefreshTimer() {
        guard refreshTimer != nil else { return }

        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    private func subscribeOnNotifications() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(didEnterBackgroundHandler),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)

        notificationCenter.addObserver(self, selector: #selector(willResignActiveHandler),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)

        notificationCenter.addObserver(self, selector: #selector(didBecomeActiveHandler),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
    }

    @objc private func refreshJobHandler() {
        invalidateRefreshTimer()

        refreshJob?()

        if shouldRepeat {
            scheduleNextRefreshTime()
        } else {
            halted = true
        }
    }

    @objc private func didEnterBackgroundHandler() {
        guard !halted else { return }

        invalidateRefreshTimer()
    }

    @objc private func willResignActiveHandler() {
        guard !halted else { return }

        invalidateRefreshTimer()
    }

    @objc private func didBecomeActiveHandler() {
        guard !halted else { return }

        scheduleNextRefreshTime()
    }

}
