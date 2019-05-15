import UIKit

public class ErrorPresentationServiceImpl: ErrorPresentationService {

    public init() {}

    public func showError(_ error: Error) {
        let message: String

        if let error = error as? LocalizedError {
            message = error.errorDescription ?? error.localizedDescription
        } else {
            message = error.localizedDescription
        }

        showError(message: message, title: "Error")
    }

    public func showError(message: String, title: String) {
        assert(Thread.isMainThread)

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        UIViewController.findVisibleController()?.present(alert, animated: true)
    }
}
