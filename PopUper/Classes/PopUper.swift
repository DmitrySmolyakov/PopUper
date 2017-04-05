//
//  PopUper.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 3/30/17.
//
//

import UIKit
import SnapKit

open class PopUper: UIViewController, TransitionAnimation {
    
    let showedViewController: UIViewController
    lazy open var contentView: UIView = {
        let tempContentView = UIView()
        tempContentView.clipsToBounds = true
        tempContentView.layer.cornerRadius = self.cornerRadius
        tempContentView.translatesAutoresizingMaskIntoConstraints = false
        return tempContentView
    }()
    
    lazy open var backgroundView: UIView = {
        let tempBackgroundView = UIView()
        tempBackgroundView.backgroundColor = self.backgroundColor
        tempBackgroundView.alpha = self.backgroundViewAlpha
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onBackViewTap))
        tempBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tempBackgroundView.addGestureRecognizer(tap)
        return tempBackgroundView
    }()
    
    lazy open var closeButton: UIButton = {
        let tempCloseButton = UIButton(type: .custom)
        tempCloseButton.tintColor = self.closeButtonTintColor
        tempCloseButton.isHidden = self.closeButtonIsHidden
        tempCloseButton.setImage(self.getImageFromBundle(name: "closeButton").withRenderingMode(.alwaysTemplate),
                                 for: .normal)
        tempCloseButton.addTarget(self, action: #selector(self.closeButtonTapped), for: .touchUpInside)
        return tempCloseButton
    }()
    
    lazy var presentationAnimation: PresentationAnimation = {
        return FadePresentationAnimation()
    }()
    lazy var dismissingAnimation: DismissAnimation = {
        return FadeDismissAnimation()
    }()
    
    // Content view size
    private struct ContentSizeConstraints {
        var widthMultiplierConstraint: NSLayoutConstraint
        var widthAbsoluteConstraint: NSLayoutConstraint
        var heightMultiplierConstraint: NSLayoutConstraint
        var heightAbsoluteConstraint: NSLayoutConstraint
        var centerAbsoluteXConstraint: NSLayoutConstraint
        var centerAbsoluteYConstraint: NSLayoutConstraint
        var centerMultiplierXConstraint: NSLayoutConstraint
        var centerMultiplierYConstraint: NSLayoutConstraint
        var widthMultiplierStatus: Bool
        var heightMultiplierStatus: Bool
        var centerMultiplierStatus: Bool
    }
    private var contentSizeConstraints = ContentSizeConstraints(widthMultiplierConstraint: NSLayoutConstraint(), widthAbsoluteConstraint: NSLayoutConstraint(), heightMultiplierConstraint: NSLayoutConstraint(), heightAbsoluteConstraint: NSLayoutConstraint(), centerAbsoluteXConstraint: NSLayoutConstraint(), centerAbsoluteYConstraint: NSLayoutConstraint(), centerMultiplierXConstraint: NSLayoutConstraint(), centerMultiplierYConstraint: NSLayoutConstraint(), widthMultiplierStatus: true, heightMultiplierStatus: true, centerMultiplierStatus: true)
    open var widthMultiplier: CGFloat = 0.7 {
        didSet {
            contentSizeConstraints.widthMultiplierStatus = true
            setupConstraintsForContentView()
        }
    }
    open var width: CGFloat = 250 {
        didSet {
            contentSizeConstraints.widthMultiplierStatus = false
            setupConstraintsForContentView()
        }
    }
    open var heightMultiplier: CGFloat = 0.6 {
        didSet {
            contentSizeConstraints.heightMultiplierStatus = true
            setupConstraintsForContentView()
        }
    }
    open var height: CGFloat = 300 {
        didSet {
            contentSizeConstraints.heightMultiplierStatus = false
            setupConstraintsForContentView()
        }
    }
    
    //Content view position
    open var finalPositionRotationAngle: CGFloat?
    open var centerMultiplierX: CGFloat = 1 {
        didSet {
            contentSizeConstraints.centerMultiplierStatus = true
            setupConstraintsForContentView()
        }
    }
    open var centerOffsetX: CGFloat = 0 {
        didSet {
            contentSizeConstraints.centerMultiplierStatus = false
            setupConstraintsForContentView()
        }
    }
    open var centerMultiplierY: CGFloat = 1 {
        didSet {
            contentSizeConstraints.centerMultiplierStatus = true
            setupConstraintsForContentView()
        }
    }
    open var centerOffsetY: CGFloat = 0 {
        didSet {
            contentSizeConstraints.centerMultiplierStatus = false
            setupConstraintsForContentView()
        }
    }
    
    //Setup content view border
    open var cornerRadius: CGFloat = 25 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }
    open var borderWidth: CGFloat = 0 {
        didSet {
            contentView.layer.borderWidth = borderWidth
        }
    }
    open var borderColor: UIColor = .black {
        didSet {
            contentView.layer.borderColor = borderColor.cgColor
        }
    }
    
    //Background view setup
    open var backgroundColor: UIColor = .black {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    open var backgroundViewAlpha: CGFloat = 0.6 {
        didSet {
            backgroundView.alpha = backgroundViewAlpha
        }
    }
    open var backgroundViewIsHidden = false {
        didSet {
            backgroundView.alpha = backgroundViewIsHidden ? 0 : backgroundViewAlpha
        }
    }
    open var hideByTapIsOn: Bool = true
    
    
    //Close button setup
    open var closeButtonIsHidden: Bool = true {
        didSet {
            closeButton.isHidden = closeButtonIsHidden
        }
    }
    open var closeButtonTintColor: UIColor = .black {
        didSet {
            closeButton.tintColor = closeButtonTintColor
        }
    }
    
    //animation setup
    open var presentAnimationDuration: Double = 0.5
    open var presentAnimationRotationAngle: CGFloat?
    
    open var dismissAnimationDuration: Double = 0.25
    open var dismissAnimationRotationAngle: CGFloat?
    
    open var presentAnimation: Animation = .fade {
        didSet {
            switch presentAnimation {
            case .slide(let direction, let rotation):
                self.presentationAnimation = SlidePresentationAnimation(direction: direction, rotation: rotation)
                self.presentationAnimation.delegate = self
            case .fade:
                self.presentationAnimation = FadePresentationAnimation()
                self.presentationAnimation.delegate = self
            }
        }
    }
    open var dismissAnimation: Animation = .fade {
        didSet {
            switch dismissAnimation {
            case .slide(let direction, let rotation):
                self.dismissingAnimation = SlideDismissAnimation(direction: direction, rotation: rotation)
                self.dismissingAnimation.delegate = self
            case .fade:
                self.dismissingAnimation = FadeDismissAnimation()
                self.presentationAnimation.delegate = self
            }
        }
    }
    
    // MARK: Initialization
    public init(showedViewController: UIViewController, widthMultiplier: CGFloat = 1, heightMultiplier: CGFloat = 1) {
        self.showedViewController = showedViewController
        self.widthMultiplier = widthMultiplier
        self.heightMultiplier = heightMultiplier
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(showedViewController: UIViewController) {
        self.showedViewController = showedViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundView)
        NSLayoutConstraint(item: backgroundView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .width,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .height,
                           multiplier: 1.0, constant: 0).isActive = true

        self.view.addSubview(contentView)
        self.setupConstraintsForContentView()
        
        self.addChildViewController(showedViewController)
        self.contentView.addSubview(showedViewController.view)
        showedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showedViewController.view,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerX,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: showedViewController.view,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerY,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: showedViewController.view,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .width,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: showedViewController.view,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .height,
                           multiplier: 1.0, constant: 0).isActive = true
        self.showedViewController.didMove(toParentViewController: self)
        
        self.contentView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -20).isActive = true
    }
    
    // MARK: Actions
    dynamic private func onBackViewTap() {
        if hideByTapIsOn {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    dynamic private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    private func getImageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: PopUper.self)
        return UIImage(named: name, in: podBundle, compatibleWith: nil)!
    }

    private func setupConstraintsForContentView() {

        if contentSizeConstraints.widthMultiplierStatus {
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: widthMultiplier, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width).isActive = true
        }
        if contentSizeConstraints.heightMultiplierStatus {
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: heightMultiplier, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height).isActive = true
        }
        if contentSizeConstraints.centerMultiplierStatus {
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: centerMultiplierX, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: centerOffsetX).isActive = true
        }
        if contentSizeConstraints.centerMultiplierStatus {
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: centerMultiplierY, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: centerOffsetY).isActive = true
        }
    }
}

// MARK: DSPresentationAnimationDelegate
extension PopUper: PresentationAnimationDelegate {
    func durationForPresentationAnimation() -> Double {
        return presentAnimationDuration
    }
    
    func rotationAngleForPresentAnimation() -> CGFloat? {
        return presentAnimationRotationAngle
    }
    
    func contentFinalRotationAngleForPresentAnimation() -> CGFloat? {
        return finalPositionRotationAngle
    }
}

// MARK: DSDismissAnimationDelegate
extension PopUper: DismissAnimationDelegate {
    func durationForDismissAnimation() -> Double {
        return dismissAnimationDuration
    }
    
    func rotationAngleForDismissAnimation() -> CGFloat? {
        return dismissAnimationRotationAngle
    }
}

// MARK: Presenting methods
extension PopUper {
    open static func showViewController(presenter: UIViewController, showedViewController: UIViewController) {
        let viewController = PopUper(showedViewController: showedViewController)
        viewController.show(presenter: presenter)
    }
    
    open func show(presenter: UIViewController) {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .overFullScreen
        presenter.present(self, animated: true, completion: nil)
    }
    
    open func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension PopUper: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimation
    }
}
