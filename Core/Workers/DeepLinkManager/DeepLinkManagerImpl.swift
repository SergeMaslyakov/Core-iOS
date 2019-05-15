import UIKit

import RxSwift
import RxCocoa
import RxRelay

public final class DeepLinkManagerImpl: DeepLinkManager {

    private typealias DeepLinkData = (url: URL, app: UIApplication, options: [UIApplication.OpenURLOptionsKey: Any])

    private let deepLinkParsers: [DeepLinkParser]
    private let userActivityParsers: [UserActivityParser]
    private let handlers: [DeepLinkHandler]

    private let onNewDeepLink = PublishSubject<DeepLinkData>()
    private let onNewUserActivity = PublishSubject<NSUserActivity>()

    private let disposeBag = DisposeBag()

    public init(deepLinkParsers: [DeepLinkParser], userActivityParsers: [UserActivityParser], handlers: [DeepLinkHandler]) {
        self.deepLinkParsers = deepLinkParsers
        self.userActivityParsers = userActivityParsers
        self.handlers = handlers

        bind()
    }

    // MARK: - DeepLinkManager

    public func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        deepLinkParsers.forEach { $0.configure(launchOptions: launchOptions) }
        userActivityParsers.forEach { $0.configure(launchOptions: launchOptions) }
    }

    public func canHandleDeepLink(_ url: URL) -> Bool {
        return deepLinkParsers.first(where: { $0.canHandle(url) }) != nil
    }

    public func canHandleUserActivity(_ userActivity: NSUserActivity) -> Bool {
        return userActivityParsers.first(where: { $0.canHandle(userActivity) }) != nil
    }

    public func handleDeepLink(_ url: URL, app: UIApplication, options: [UIApplication.OpenURLOptionsKey: Any]) {
        guard deepLinkParsers.first(where: { $0.canHandle(url) }) != nil else { return }

        onNewDeepLink.onNext(DeepLinkData(url: url, app: app, options: options))
    }

    public func handleUserActivity(_ userActivity: NSUserActivity) {
        guard userActivityParsers.first(where: { $0.canHandle(userActivity) }) != nil else { return }

        onNewUserActivity.onNext(userActivity)
    }

    // MARK: - Internal

    private func bind() {
        onNewDeepLink
            .asObservable()
            .flatMap { [unowned self] data -> Observable<DeepLinkType> in
                return self.parseDeepLinkIfPossible(data).observeOn(MainScheduler.asyncInstance)
            }
            .filter { !$0.isUnknownDeepLink }
            .flatMap { [unowned self] deepLink -> Observable<Void> in
                return self.handleDeepLinkIfPossible(deepLink).observeOn(MainScheduler.asyncInstance)
            }
            .subscribe()
            .disposed(by: disposeBag)

        onNewUserActivity
            .asObservable()
            .flatMap { [unowned self] userActivity -> Observable<DeepLinkType> in
                return self.parseUserActivityIfPossible(userActivity).observeOn(MainScheduler.asyncInstance)
            }
            .filter { !$0.isUnknownDeepLink }
            .flatMap { [unowned self] deepLink -> Observable<Void> in
                return self.handleDeepLinkIfPossible(deepLink).observeOn(MainScheduler.asyncInstance)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func parseUserActivityIfPossible(_ userActivity: NSUserActivity) -> Observable<DeepLinkType> {
        guard let parser = userActivityParsers.first(where: { $0.canHandle(userActivity) }) else { return .just(.unknown) }

        return parser.parse(userActivity)
    }

    private func parseDeepLinkIfPossible(_ data: DeepLinkData) -> Observable<DeepLinkType> {
        guard let parser = deepLinkParsers.first(where: { $0.canHandle(data.url) }) else { return .just(.unknown) }

        return parser.parse(data.url, app: data.app, options: data.options)
    }

    private func handleDeepLinkIfPossible(_ deepLink: DeepLinkType) -> Observable<Void> {
        guard let handler = handlers.first(where: { $0.canHandle(deepLink) }) else { return .empty() }

        return handler.handle(deepLink)
    }

}
