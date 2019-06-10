import Foundation

public enum UserReaction {
    case proceed
    case cancel
}

public protocol ErrorPresentationService {

    func showError(_ error: Error)

    func showError(message: String, title: String)

}
