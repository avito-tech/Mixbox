import UIKit
import MixboxTestability

final class MovingElementTestsView: UIView {
    private let targetView = UIView()
    private let diameter: CGFloat = 42.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        targetView.backgroundColor = .blue
        targetView.mb_size = CGSize(width: diameter, height: diameter)
        targetView.layer.cornerRadius = diameter / 2
        targetView.accessibilityIdentifier = "movingElement"
        
        addSubview(targetView)
        
        animateAndSchedule()
    }

    private func animateAndSchedule() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                var rectForView = self.bounds
                let side = min(rectForView.width, rectForView.height) - self.diameter
                rectForView.size = CGSize(width: side, height: side)
                rectForView.mb_center = self.bounds.mb_center
                
                self.targetView.center = CGPoint(
                    x: rectForView.minX + CGFloat(drand48()) * rectForView.width,
                    y: rectForView.minY + CGFloat(drand48()) * rectForView.height
                )
            }, completion: { _ in
                self.animateAndSchedule()
            }
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
