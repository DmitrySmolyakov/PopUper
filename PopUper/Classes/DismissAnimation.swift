//
//  DismissAnimation.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 3/30/17.
//
//

import UIKit

protocol DismissAnimationDelegate: class {
    func durationForDismissAnimation() -> Double
    func rotationAngleForDismissAnimation() -> CGFloat?
}

public class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    weak var delegate: DismissAnimationDelegate?
    
    var rotationAngle: CGFloat? {
        return self.delegate?.rotationAngleForDismissAnimation()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.delegate?.durationForDismissAnimation() ?? 0.25
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //abstract class do nothing
    }
}
