//
//  ConstraintsManager.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 4/5/17.
//
//

import Foundation

class ConstraintsManager {

    static func addFillContraintsFor(fromView: UIView, toView: UIView) {
        NSLayoutConstraint(item: fromView, attribute: .centerX, relatedBy: .equal,
                           toItem: toView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .centerY, relatedBy: .equal,
                           toItem: toView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .width, relatedBy: .equal,
                           toItem: toView, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .height, relatedBy: .equal,
                           toItem: toView, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
    }
    
    static func addCloseButtonConstraints(closeButton: UIView, toItem: UIView) {
        NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal,
                           toItem: nil, attribute: .width, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal,
                           toItem: nil, attribute: .height, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal,
                           toItem: toItem, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .right, relatedBy: .equal,
                           toItem: toItem, attribute: .right, multiplier: 1, constant: -20).isActive = true
    }
}

extension NSLayoutConstraint {
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        return newConstraint
    }
}
