import UIKit
import MixboxUiKit
import TestsIpc
import MapKit
import MixboxFoundation

final class NonViewElementsTestsCustomDrawingView: UIView, TestingView, MKMapViewDelegate {
    private struct Rectangle {
        let color: UIColor
        let accessibilityElement: UIAccessibilityElement
    }
    
    private var rectangles = [Rectangle]() {
        didSet {
            updateAccessibilityElements()
        }
    }
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let colors: [UIColor] = [
            UIColor(red: 0, green: 0.5215686275, blue: 0.2588235294, alpha: 1), // Philippine Green
            UIColor(red: 1, green: 0.8784313725, blue: 0, alpha: 1), // Golden Yellow
            UIColor(red: 0.9058823529, green: 0, blue: 0.003921568627, alpha: 1) // Electric Red
        ]
        
        rectangles = colors.enumerated().map { index, color in
            let accessibilityElement = UIAccessibilityElement(accessibilityContainer: self)
            
            accessibilityElement.accessibilityIdentifier = "element\(index)"
            accessibilityElement.mb_testability_customValues["tapped"] = false
                
            return Rectangle(
                color: color,
                accessibilityElement: accessibilityElement
            )
        }
        
        updateAccessibilityElements()
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
            
            rectangle.accessibilityElement.accessibilityFrame = UIAccessibility.convertToScreenCoordinates(
                rect,
                in: self
            )
            rectangle.accessibilityElement.accessibilityFrameInContainerSpace = rect
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            let point = touch.location(in: nil)
            
            for rectangle in rectangles {
                if rectangle.accessibilityElement.accessibilityFrame.contains(point) {
                    rectangle.accessibilityElement.mb_testability_customValues["tapped"] = true
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func updateAccessibilityElements() {
        self.accessibilityElements = rectangles.map { $0.accessibilityElement }
    }
}
