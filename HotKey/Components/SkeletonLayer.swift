import UIKit

class SkeletonLayer: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeletonLayer()
    }
    
    private func setupSkeletonLayer() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5) // màu xám nhạt
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.lightGray.cgColor,
            UIColor.white.cgColor,
            UIColor.lightGray.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        
        startAnimating()
    }
    
    private func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 0.8
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "skeletonAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        stopAnimating()
    }
    
    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}
