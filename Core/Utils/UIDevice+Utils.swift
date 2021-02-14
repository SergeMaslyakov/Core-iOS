import Foundation

public extension UIDevice {

    enum Device: CaseIterable {
        case iphone5
        case iphone6
        case iphone6Plus
        case iphoneXR
        case iphoneX
        case iphoneXMax
        case iphone12Mini
        case iphone12
        case iphone12Pro

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
                return 1334
            case .iphone6Plus:
                return 1920
            case . iphone12Mini:
                return 2340
            case . iphone12:
                return 2532
            case . iphone12Pro:
                return 2778
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
