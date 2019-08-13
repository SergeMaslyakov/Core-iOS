import UIKit
import AVFoundation

public final class AVPlayerView: UIView {

    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    public var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    public var playerLayer: AVPlayerLayer {
        // swiftlint:disable:next force_cast
        return layer as! AVPlayerLayer
    }

    public func togglePlayerState() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }

}
