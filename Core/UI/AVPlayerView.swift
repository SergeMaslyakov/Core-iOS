import AVFoundation
import UIKit

public final class AVPlayerView: UIView {
    override public static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    public var player: AVPlayer? {
        get {
            playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    public var playerLayer: AVPlayerLayer {
        // swiftlint:disable:next force_cast
        layer as! AVPlayerLayer
    }

    public func togglePlayerState() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }
}
