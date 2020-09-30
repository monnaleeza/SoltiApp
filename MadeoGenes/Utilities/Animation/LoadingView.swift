import Foundation
import UIKit
import Lottie

class LoadingView {
    
    var animationView = AnimationView()
    var view: UIView?
    
    init(_ view: UIView){
        self.view = view
        animationView.animation = Animation.named("progress_loading")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
    }
    func startAnimation(){
        animationView.play();
        view!.addSubview(animationView)
    }
    
    func stopAnimation(){
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
