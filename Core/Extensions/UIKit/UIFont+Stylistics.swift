import UIKit

public extension UIFont {
    func activateFirstStylisticSet() -> UIFont {
        let stylisticSet: [UIFontDescriptor.FeatureKey: Int] = [
            .featureIdentifier: kStylisticAlternativesType,
            .typeIdentifier: 2
        ]

        let newDescriptor = fontDescriptor.addingAttributes([
            .featureSettings: [stylisticSet]
        ])

        return UIFont(descriptor: newDescriptor, size: 0)
    }
}
