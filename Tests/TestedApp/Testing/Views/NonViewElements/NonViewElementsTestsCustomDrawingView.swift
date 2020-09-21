import UIKit
import MixboxUiKit
import TestsIpc
import MapKit
import MixboxFoundation
import MixboxTestability

final class NonViewElementsTestsCustomDrawingView: UIView, TestingView, MKMapViewDelegate {
    private class Rectangle: BaseMutableTestabilityElement {
        let color: UIColor
        let id: String
        
        var isTapped: Bool = false {
            didSet {
                mb_testability_customValues["isTapped"] = isTapped
            }
        }
        
        init(color: UIColor, id: String) {
            self.color = color
            self.id = id
            
            super.init()
            
            isTapped = false
        }
        
        override func mb_testability_accessibilityIdentifier() -> String? {
            return id
        }
    }
    
    private let rectangles: [Rectangle]
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        let colors: [UIColor] = [
            UIColor(red: 0, green: 0.5215686275, blue: 0.2588235294, alpha: 1), // Philippine Green
            UIColor(red: 1, green: 0.8784313725, blue: 0, alpha: 1), // Golden Yellow
            UIColor(red: 0.9058823529, green: 0, blue: 0.003921568627, alpha: 1) // Electric Red
        ]
        
        rectangles = colors.enumerated().map { index, color in
            Rectangle(
                color: color,
                id: "element\(index)"
            )
        }
        
        super.init(frame: .zero)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for (index, rectangle) in rectangles.enumerated() {
            context.setFillColor(rectangle.color.cgColor)
            
            let rect = CGRect(
                x: 0,
                y: CGFloat(index) / CGFloat(rectangles.count) * bounds.height,
                width: bounds.width,
                height: bounds.height / CGFloat(rectangles.count)
            )
            
            context.fill(rect)
            
            rectangle.set(frame: rect, container: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            let point = touch.location(in: nil)
            
            for rectangle in rectangles {
                if rectangle.frameRelativeToScreen.contains(point) {
                    rectangle.isTapped = true
                }
            }
        }
    }
    
    // MARK: - Private
    
    override func mb_testability_children() -> [TestabilityElement] {
        return rectangles
    }
}
