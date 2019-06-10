import Foundation
import RxSwift
import RxCocoa

public final class AppVersionCheckerWorkerImpl: AppVersionCheckerWorker {

    private enum Keys: String {
        case lastShowDate = "app_update_prompt_last_show_date"
        case lastCheckDate = "appstore_version_last_check_date"

        case suiteName = "appstore_version_checker"

        var bundleRelatedKey: String {
            return AppBundle.bundleIdentifier + "." + self.rawValue
        }
    }

    private let api: AppStoreVersionAPI
    private let defaults: UserDefaults

    private let checkVersionPeriod: DateComponents
    private let showPromptPeriod: DateComponents
    private let releaseDatePeriod: DateComponents

    private let _onAppOutdated = PublishSubject<Void>()
    private let checkTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    public init(api: AppStoreVersionAPI) {
        self.api = api

        self.defaults = UserDefaults(suiteName: Keys.suiteName.bundleRelatedKey) ?? .standard
        self.onAppOutdated = _onAppOutdated.asObservable().share(replay: 1, scope: .forever)

        // constants
        self.showPromptPeriod = DateComponents(calendar: .current, hour: 72)
        self.checkVersionPeriod = DateComponents(calendar: .current, hour: 6)
        self.releaseDatePeriod = DateComponents(calendar: .current, day: 30)

        bind()
    }

    // MARK: - Public

    public let onAppOutdated: Observable<Void>

    public func checkAppStoreVersionIfNeeded() {
        guard shouldCheckAppStoreVersion() else { return }

        checkTrigger.onNext(())
    }

    // MARK: - Private

    private func bind() {
        checkTrigger
            .flatMapLatest { [weak self, unowned api] in
                return api.appStoreVersion().do(onNext: { _ in self?.lastCheckDate = Date() })
            }
            .asDriver(onErrorJustReturn: AppStoreVersionModel.makeZeroVersion())
            .map { [weak self] in return self?.canShowPrompt($0) ?? false }
            .filter { $0 }
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?._onAppOutdated.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private func canShowPrompt(_ model: AppStoreVersionModel) -> Bool {
        let appVersion = AppVersion.makeFromString(AppBundle.version) ?? .makeZeroVersion()
        let appStoreVersion = AppVersion.makeFromString(model.version) ?? .makeZeroVersion()
        let releaseDate = model.releaseDate ?? Date()

        return appStoreVersion > appVersion
            && releaseDate.ifPeriodExpired(releaseDatePeriod)
            && lastShowDate.ifPeriodExpired(showPromptPeriod)
    }

    private func shouldCheckAppStoreVersion() -> Bool {
        return lastCheckDate.ifPeriodExpired(checkVersionPeriod)
    }

    // MARK: - Persistent Flags

    private var lastShowDate: Date {
        get {
            let ti = defaults.double(forKey: Keys.lastShowDate.bundleRelatedKey)
            return Date(timeIntervalSince1970: ti)
        }

        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastShowDate.bundleRelatedKey)
        }
    }

    private var lastCheckDate: Date {
        get {
            let ti = defaults.double(forKey: Keys.lastCheckDate.bundleRelatedKey)
            return Date(timeIntervalSince1970: ti)
        }

        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastCheckDate.bundleRelatedKey)
        }
    }

}
