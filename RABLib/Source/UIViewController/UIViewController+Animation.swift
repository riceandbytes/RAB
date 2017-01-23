
import Foundation

extension UIViewController: CAAnimationDelegate {
    
    public func viewSlideInFromRightToLeft(_ view: UIView) {
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
    
    public func viewSlideInFromLeftToRight(_ view: UIView) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
}
