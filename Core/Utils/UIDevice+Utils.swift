import Foundation

public extension UIDevice {
    enum Device: CaseIterable {
        case iphone3GS, iphone3G, iphone
        case iphone4, iphone4s
        case iphone5, iphone5c, iphone5s, iphoneSE
        case iphone6, iphone6Plus, iphone6s, iphone6sPlus
        case iphone7, iphone7Plus, iphone8Plus
        case iphone8, iphoneX, iphoneXS, iphoneXSMax
        case iphoneXR, iphone11, iphone11Pro, iphone11ProMax
        case iphoneSE2, iphone12Mini, iphone12, iphone12Pro, iphone12ProMax
        case iphone13Mini, iphone13, iphone13Pro, iphone13ProMax

        var screenHeight: CGFloat {
            switch self {
            case .iphone3GS, .iphone3G, .iphone:
                return 480
            case .iphone4, .iphone4s:
                return 960
            case .iphone5, .iphone5c, .iphone5s, .iphoneSE:
                return 1136
            case .iphone6, .iphone6s, .iphone7, .iphone8, .iphoneSE2:
                return 1334
            case .iphoneXR, .iphone11:
                return 1792
            case .iphone6Plus, .iphone6sPlus, .iphone7Plus, .iphone8Plus:
                return 2208
            case .iphoneX, .iphoneXS, .iphone11Pro, .iphone12Mini, .iphone13Mini:
                return 2436
            case .iphone12, .iphone12Pro, .iphone13, .iphone13Pro:
                return 2532
            case .iphoneXSMax, .iphone11ProMax:
                return 2688
            case .iphone12ProMax, .iphone13ProMax:
                return 2778
            }
        }

        init?(height: CGFloat) {
            guard
                let device = Device.allCases.first(where: { $0.screenHeight == height })
            else {
                return nil
            }

            self = device
        }
    }

    private static let iphone5Layout: [Device] = [
        .iphone5, .iphone5c, .iphone5s, .iphoneSE
    ]

    static let device = Device(height: UIScreen.main.nativeBounds.height) ?? .iphone6

    var isX2Layout: Bool {
        Int(UIScreen.main.nativeScale) == 2
    }

    var isX3Layout: Bool {
        Int(UIScreen.main.nativeScale) == 3
    }

    var isIphone5: Bool {
        UIDevice.iphone5Layout.contains(UIDevice.device)
    }

    var isSmallLayout: Bool {
        UIDevice.device.screenHeight < Device.iphoneXR.screenHeight
    }
}
