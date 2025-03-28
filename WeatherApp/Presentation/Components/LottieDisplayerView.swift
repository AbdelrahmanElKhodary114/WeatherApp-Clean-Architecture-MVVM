import SwiftUI
import Lottie

struct LottieDisplayerView: View {
    
    let fileName: String
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var playLoopMode: LottieLoopMode = .loop
    var onAnimationDidFinish: (() -> Void)?
    
    var body: some View {
        LottieView(animation: .named(fileName))
            .configure { lottieAnimationView in
                lottieAnimationView.contentMode = contentMode
                lottieAnimationView.shouldRasterizeWhenIdle = true
            }
            .playbackMode(.playing(.toProgress(1, loopMode: playLoopMode)))
            .animationDidFinish { _ in
                onAnimationDidFinish?()
            }
    }
}
