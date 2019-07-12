import Foundation

public extension UIDevice {

    enum Device: CaseIterable {
        case iphone5
        case iphone6
        case iphone6Plus
        case iphoneXR
        case iphoneX
        case iphoneXMax

        var screenHeight: CGFloat {
            switch self {
            case .iphone5:
                return 1136
            case .iphoneX:
                return 2436
            case .iphoneXMax:
                return 2688
            case .iphoneXR:
                return 1792
            case .iphone6:
                return 1134
            case .iphone6Plus:
                return 1920
            }
        }

        init?(height: CGFloat) {
            guard let device = Device.allCases.first(where: { $0.screenHeight == height }) else { return nil }
            self = device
        }
    }

    static let device: Device = Device(height: UIScreen.main.nativeBounds.height) ?? .iphone6

    var isX2Layout: Bool {
        return UIDevice.device == .iphone5 || UIDevice.device == .iphone6 || UIDevice.device == .iphoneXR
    }

    var isIphone5: Bool {
        return UIDevice.device == .iphone5
    }

}
