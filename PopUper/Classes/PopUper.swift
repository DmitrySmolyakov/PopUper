//
//  PopUper.swift
//  Pods
//
//  Created by Dmitry Smolyakov on 3/30/17.
//
//

import UIKit

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
        tempCloseButton.translatesAutoresizingMaskIntoConstraints = false
        return tempCloseButton
    }()
    
    lazy var presentationAnimation: PresentationAnimation = {
        return FadePresentationAnimation()
    }()
    lazy var dismissingAnimation: DismissAnimation = {
        return FadeDismissAnimation()
    }()
    
    // Content view size
    var constraintManager: ConstraintsManager?
    
    open var widthMultiplier: CGFloat = 0.7 {
        didSet {
            constraintManager?.contentConstraints.widthMultiplierStatus = true
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var width: CGFloat = 250 {
        didSet {
            constraintManager?.contentConstraints.widthMultiplierStatus = false
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var heightMultiplier: CGFloat = 0.6 {
        didSet {
            constraintManager?.contentConstraints.heightMultiplierStatus = true
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var height: CGFloat = 300 {
        didSet {
            constraintManager?.contentConstraints.heightMultiplierStatus = false
            constraintManager?.setupConstraintsForContentView()
        }
    }
    
    //Content view position
    open var finalPositionRotationAngle: CGFloat?
    open var centerMultiplierX: CGFloat = 1 {
        didSet {
            constraintManager?.contentConstraints.centerMultiplierStatus = true
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var centerOffsetX: CGFloat = 0 {
        didSet {
            constraintManager?.contentConstraints.centerMultiplierStatus = false
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var centerMultiplierY: CGFloat = 1 {
        didSet {
            constraintManager?.contentConstraints.centerMultiplierStatus = true
            constraintManager?.setupConstraintsForContentView()
        }
    }
    open var centerOffsetY: CGFloat = 0 {
        didSet {
            constraintManager?.contentConstraints.centerMultiplierStatus = false
            constraintManager?.setupConstraintsForContentView()
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
        self.constraintManager = ConstraintsManager(popUper: self)
    }
    
    public init(showedViewController: UIViewController) {
        self.showedViewController = showedViewController
        super.init(nibName: nil, bundle: nil)
        self.constraintManager = ConstraintsManager(popUper: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundView)
        constraintManager?.addFillContraintsFor(fromView: backgroundView, toView: self.view)

        self.view.addSubview(contentView)
        constraintManager?.prepareContentViewConstraints(contentView: contentView, toView: self.view)
        constraintManager?.setupConstraintsForContentView()
        
        self.addChildViewController(showedViewController)
        self.contentView.addSubview(showedViewController.view)
        showedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        constraintManager?.addFillContraintsFor(fromView: showedViewController.view, toView: self.contentView)
        self.showedViewController.didMove(toParentViewController: self)
        
        self.contentView.addSubview(closeButton)
        constraintManager?.addCloseButtonConstraints(closeButton: closeButton, toItem: self.contentView)
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
