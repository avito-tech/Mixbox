import UIKit
import MixboxTestability

private extension UIView {
    func setCircleDiameter(_ diameter: CGFloat) {
        mb_size = CGSize(width: diameter, height: diameter)
        layer.cornerRadius = diameter / 2
    }
}

// Idea of the view:
//
// When button is tapped
//     Two views are shown
//     Application remains still for \(applicationIdlingDuration) seconds
//     Animation is happening for \(animationDuration) seconds
//     Then one become hidden in some way
//
final class ChangingHierarchyTestsView: UIView {
    private var buttons = [ButtonWithClosures]()
    
    private let duplicatedViewsContainer = UIView()
    private let duplicatedView0 = UIView()
    private let duplicatedView1 = UIView()
    
    private let progressIndicator = UILabel()
    
    private let applicationIdlingDuration: TimeInterval = 2
    private let animationDuration: TimeInterval = 2
    private let diameter: CGFloat = 42.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        duplicatedView0.backgroundColor = .blue
        duplicatedView0.accessibilityIdentifier = "duplicatedView"
        duplicatedView0.testability_customValues["index"] = 0
        duplicatedView0.setCircleDiameter(diameter)
        
        duplicatedView1.backgroundColor = .blue
        duplicatedView1.accessibilityIdentifier = "duplicatedView"
        duplicatedView1.testability_customValues["index"] = 1
        duplicatedView1.setCircleDiameter(diameter)
        
        addSubview(duplicatedViewsContainer)
        duplicatedViewsContainer.addSubview(duplicatedView0)
        duplicatedViewsContainer.addSubview(duplicatedView1)
        
        addButton("Reset") { [weak self] in
            self?.reset()
        }
        addButton("Alpha") { [weak self] in
            self?.idle {
                self?.animationWithAlpha()
            }
        }
        addButton("Hidden") { [weak self] in
            self?.idle {
                self?.animationWithHidden()
            }
        }
        addButton("Frame") { [weak self] in
            self?.idle {
                self?.animationWithFrame()
            }
        }
        
        addSubview(progressIndicator)
        progressIndicator.textColor = .black
        progressIndicator.text = "Ready"
        progressIndicator.accessibilityIdentifier = "progressIndicator"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 10
        
        let frameToLayoutIn = bounds.mb_shrinked(layoutMargins)
        var top = frameToLayoutIn.mb_top + spacing
        for button in buttons {
            button.sizeToFit()
            button.mb_top = top
            button.mb_centerX = bounds.mb_centerX
            top = button.mb_bottom + spacing
        }
        
        duplicatedViewsContainer.mb_size = CGSize(
            width: diameter * 2 + spacing,
            height: diameter
        )
        duplicatedViewsContainer.mb_centerX = bounds.mb_centerX
        duplicatedViewsContainer.mb_top = top
        
        placeDuplicatedViews()
        
        progressIndicator.layout(
            left: frameToLayoutIn.mb_left,
            right: frameToLayoutIn.mb_right,
            bottom: frameToLayoutIn.mb_bottom,
            height: 40
        )
    }
    
    private func placeDuplicatedViews() {
        duplicatedView0.setCircleDiameter(diameter)
        duplicatedView1.setCircleDiameter(diameter)
        duplicatedView0.mb_left = 0
        duplicatedView0.mb_top = 0
        duplicatedView1.mb_right = duplicatedViewsContainer.mb_width
        duplicatedView1.mb_top = 0
    }
    
    private func addButton(_ title: String, onTap: @escaping () -> ()) {
        let button = ButtonWithClosures()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.onTap = onTap
        button.accessibilityIdentifier = "\(title)-button"
        addSubview(button)
        buttons.append(button)
    }
    
    private func idle(completion: @escaping () -> ()) {
        progressIndicator.text = "Idling"
        
        DispatchQueue.global(qos: .background).asyncAfter(
            deadline: .now() + applicationIdlingDuration,
            execute: {
                DispatchQueue.main.async(execute: completion)
            }
        )
    }
    
    private func animate(animations: @escaping () -> (), completion: @escaping () -> ()) {
        progressIndicator.text = "Animation"
        
        UIView.animate(
            withDuration: self.animationDuration,
            animations: {
                animations()
            },
            completion: { _ in
                completion()
                
                self.progressIndicator.text = "Ready"
            }
        )
    }
    
    private func animationWithAlpha() {
        animate(
            animations: {
                self.duplicatedView0.alpha = 0
            }, completion: {
            }
        )
    }
    
    private func animationWithHidden() {
        animate(
            animations: {
                self.duplicatedView0.backgroundColor = .black
            },
            completion: {
                self.duplicatedView0.isHidden = true
            }
        )
    }
    
    private func animationWithFrame() {
        animate(
            animations: {
                let center = self.duplicatedView0.center
                self.duplicatedView0.mb_size = .zero
                self.duplicatedView0.center = center
            }, completion: {
            }
        )
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = diameter / 2
        animation.toValue = 0
        animation.duration = animationDuration
        duplicatedView0.layer.add(animation, forKey: "cornerRadius")
    }
    
    private func reset() {
        for view in [duplicatedView0, duplicatedView1] {
            view.backgroundColor = .blue
            view.alpha = 1
            view.isHidden = false
        }
        placeDuplicatedViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
