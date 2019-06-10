import Foundation
import RxSwift
import RxCocoa

public final class CountryServiceImpl: CountryService {

    private var models: [CountryModel] = []
    private let decoder = JSONDecoder()

    private let disposeBag = DisposeBag()
    private let serialScheduler: SerialRxScheduler = .makeSerialBackgroundScheduler("country-service-serial-scheduler")
    private let countriesRelay = BehaviorRelay<[CountryModel]>(value: [])

    public var countries: Observable<[CountryModel]> {
        return loadCountriesIfNeeded().observeOn(MainScheduler.asyncInstance)
    }

    public init() { }

    private func loadCountriesIfNeeded() -> Observable<[CountryModel]> {

        return Observable.create { [weak self] observer -> Disposable in

            if self?.models.isEmpty == true {

                do {
                    let countries = try self?.fetchCountries() ?? []
                    self?.models = countries

                    observer.onNext(countries)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }

            } else {
                observer.onNext(self?.models ?? [])
                observer.onCompleted()
            }

            return Disposables.create()

        }.subscribeOn(serialScheduler)

    }

    private func fetchCountries() throws -> [CountryModel] {

        do {
            let fileData = try AppBundleResourceLoader.readFile(path: "CountryCodes",
                                                                extension: "json",
                                                                bundle: Bundle(for: type(of: self)))
            let jsonData = try JSONSerialization.jsonObject(with: fileData, options: [])

            if let nestedJson = (jsonData as AnyObject).value(forKeyPath: "countries") {
                let data = try JSONSerialization.data(withJSONObject: nestedJson)

                let models = try decoder.decode(Array<CountryModel>.self, from: data)
                return models.sorted(by: { $0.name < $1.name })
            }

            throw AppError.unexpected

        } catch {

            if let error = error as? AppError {
               throw error
            } else {
                throw AppError.unexpectedWithUnderlying(error)
            }
        }
    }
}
