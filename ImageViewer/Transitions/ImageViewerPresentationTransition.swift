import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let fromImageView: UIImageView

    init(fromImageView: UIImageView) {
        self.fromImageView = fromImageView
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            transitionContext.completeTransition(false)
            return
        }

        let imageView = AnimatableImageView()
        imageView.image = fromImageView.image
        if let fromParentView = fromImageView.superview {
            imageView.frame = fromParentView.convert(fromImageView.frame, to: nil)
        } else {
            imageView.frame = fromImageView.frame
        }
        imageView.contentMode = fromImageView.contentMode

        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0

        toView.frame = containerView.bounds
        toView.isHidden = true
        fromImageView.isHidden = true

        containerView.addSubview(toView)
        containerView.addSubview(fadeView)
        containerView.addSubview(imageView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,  animations: {
            imageView.contentMode = .scaleAspectFit
            imageView.frame = containerView.bounds
            fadeView.alpha = 1.0
        }, completion: { _ in
            toView.isHidden = false
            fadeView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
