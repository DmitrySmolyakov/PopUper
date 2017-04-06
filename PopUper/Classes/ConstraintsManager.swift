//
//  ConstraintsManager.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 4/5/17.
//
//

import Foundation

struct ContentConstraints {
    var widthMultiplierConstraint: NSLayoutConstraint?
    var widthAbsoluteConstraint: NSLayoutConstraint?
    var heightMultiplierConstraint: NSLayoutConstraint?
    var heightAbsoluteConstraint: NSLayoutConstraint?
    var centerAbsoluteXConstraint: NSLayoutConstraint?
    var centerAbsoluteYConstraint: NSLayoutConstraint?
    var centerMultiplierXConstraint: NSLayoutConstraint?
    var centerMultiplierYConstraint: NSLayoutConstraint?
    var widthMultiplierStatus: Bool
    var heightMultiplierStatus: Bool
    var centerMultiplierStatus: Bool
    
    init(widthMultiplierStatus: Bool, heightMultiplierStatus: Bool, centerMultiplierStatus: Bool,
         widthMultiplierConstraint: NSLayoutConstraint? = nil,
         widthAbsoluteConstraint: NSLayoutConstraint? = nil,
         heightMultiplierConstraint: NSLayoutConstraint? = nil,
         heightAbsoluteConstraint: NSLayoutConstraint? = nil,
         centerAbsoluteXConstraint: NSLayoutConstraint? = nil,
         centerAbsoluteYConstraint: NSLayoutConstraint? = nil,
         centerMultiplierXConstraint: NSLayoutConstraint? = nil,
         centerMultiplierYConstraint: NSLayoutConstraint? = nil) {
        self.widthMultiplierStatus = widthMultiplierStatus
        self.heightMultiplierStatus = heightMultiplierStatus
        self.centerMultiplierStatus = centerMultiplierStatus
        self.widthMultiplierConstraint = widthMultiplierConstraint
        self.widthAbsoluteConstraint = widthAbsoluteConstraint
        self.heightMultiplierConstraint = heightMultiplierConstraint
        self.heightAbsoluteConstraint = heightAbsoluteConstraint
        self.centerMultiplierXConstraint = centerMultiplierXConstraint
        self.centerMultiplierYConstraint = centerMultiplierYConstraint
        self.centerAbsoluteXConstraint = centerAbsoluteXConstraint
        self.centerAbsoluteYConstraint = centerAbsoluteYConstraint
    }
}

class ConstraintsManager {
    
    let popUper: PopUper
    var contentConstraints = ContentConstraints(widthMultiplierStatus: true,
                                                heightMultiplierStatus: true,
                                                centerMultiplierStatus: true)
    init(popUper: PopUper) {
        self.popUper = popUper
    }
    
    func prepareContentViewConstraints(contentView: UIView, toView: UIView) {
        
        contentConstraints.widthMultiplierConstraint =
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: toView,
                               attribute: .width, multiplier: popUper.widthMultiplier, constant: 0)
        contentConstraints.widthAbsoluteConstraint =
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .width, multiplier: 1, constant: popUper.width)
        contentConstraints.heightMultiplierConstraint =
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: toView,
                               attribute: .height, multiplier: popUper.heightMultiplier, constant: 0)
        contentConstraints.heightAbsoluteConstraint =
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .height, multiplier: 1, constant: popUper.height)
        contentConstraints.centerMultiplierXConstraint =
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: toView,
                               attribute: .centerX, multiplier: popUper.centerMultiplierX, constant: 0)
        contentConstraints.centerAbsoluteXConstraint =
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: toView,
                               attribute: .centerX, multiplier: 1, constant: popUper.centerOffsetX)
        contentConstraints.centerMultiplierYConstraint =
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: toView,
                               attribute: .centerY, multiplier: popUper.centerMultiplierY, constant: 0)
        contentConstraints.centerAbsoluteYConstraint =
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: toView,
                               attribute: .centerY, multiplier: 1, constant: popUper.centerOffsetY)
    }
    
    func setupConstraintsForContentView() {
        
        contentConstraints.widthMultiplierConstraint =
            contentConstraints.widthMultiplierConstraint?.setMultiplier(multiplier: popUper.widthMultiplier)
        contentConstraints.widthMultiplierConstraint?.isActive = contentConstraints.widthMultiplierStatus
        
        contentConstraints.widthAbsoluteConstraint?.constant = popUper.width
        contentConstraints.widthAbsoluteConstraint?.isActive = !contentConstraints.widthMultiplierStatus
        
        contentConstraints.heightMultiplierConstraint =
            contentConstraints.heightMultiplierConstraint?.setMultiplier(multiplier: popUper.heightMultiplier)
        contentConstraints.heightMultiplierConstraint?.isActive = contentConstraints.heightMultiplierStatus
        
        contentConstraints.heightAbsoluteConstraint?.constant = popUper.height
        contentConstraints.heightAbsoluteConstraint?.isActive = !contentConstraints.heightMultiplierStatus
        
        contentConstraints.centerMultiplierXConstraint =
            contentConstraints.centerMultiplierXConstraint?.setMultiplier(multiplier: popUper.centerMultiplierX)
        contentConstraints.centerMultiplierXConstraint?.isActive = contentConstraints.centerMultiplierStatus
        
        contentConstraints.centerMultiplierYConstraint =
            contentConstraints.centerMultiplierYConstraint?.setMultiplier(multiplier: popUper.centerMultiplierY)
        contentConstraints.centerMultiplierYConstraint?.isActive = contentConstraints.centerMultiplierStatus
        
        contentConstraints.centerAbsoluteXConstraint?.constant = popUper.centerOffsetX
        contentConstraints.centerAbsoluteXConstraint?.isActive = !contentConstraints.centerMultiplierStatus
        
        contentConstraints.centerAbsoluteYConstraint?.constant = popUper.centerOffsetY
        contentConstraints.centerAbsoluteYConstraint?.isActive = !contentConstraints.centerMultiplierStatus
    }

    
    func addFillContraintsFor(fromView: UIView, toView: UIView) {
        NSLayoutConstraint(item: fromView, attribute: .centerX, relatedBy: .equal,
                           toItem: toView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .centerY, relatedBy: .equal,
                           toItem: toView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .width, relatedBy: .equal,
                           toItem: toView, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: fromView, attribute: .height, relatedBy: .equal,
                           toItem: toView, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func addCloseButtonConstraints(closeButton: UIView, toItem: UIView) {
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
