import UIKit
import MixboxUiKit
import TestsIpc
import MapKit
import MixboxFoundation

final class NonViewElementsTestsCustomDrawingView: UIView, TestingView, MKMapViewDelegate {
    private struct NonViewElement {
        var accessibilityFrame: CGRect
        var accessibilityIdentifier: String
        var accessibilityValue: String
    }
    
    private var nonViewElements = [NonViewElement]() {
        didSet {
            accessibilityElements = nonViewElements.map { nonViewElement in
                let accessibilityElement = UIAccessibilityElement(accessibilityContainer: self)

                accessibilityElement.accessibilityFrame = nonViewElement.accessibilityFrame
                accessibilityElement.accessibilityIdentifier = nonViewElement.accessibilityIdentifier
                
                return accessibilityElement
            }
        }
    }
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
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
        
        let colors: [UIColor] = [
            UIColor(red: 0, green: 0.5215686275, blue: 0.2588235294, alpha: 1), // Philippine Green
            UIColor(red: 1, green: 0.8784313725, blue: 0, alpha: 1), // Golden Yellow
            UIColor(red: 0.9058823529, green: 0, blue: 0.003921568627, alpha: 1) // Electric Red
        ]
        
        nonViewElements.removeAll(keepingCapacity: true)
        
        for (index, color) in colors.enumerated() {
            context.setFillColor(color.cgColor)
            
            let rect = CGRect(
                x: 0,
                y: CGFloat(index) / 3 * bounds.height,
                width: bounds.width,
                height: bounds.height / 3
            )
            
            context.fill(rect)
            
            nonViewElements.append(
                NonViewElement(
                    accessibilityFrame: UIAccessibility.convertToScreenCoordinates(rect, in: self),
                    accessibilityIdentifier: "element\(index)",
                    accessibilityValue: "0"
                )
            )
            
            accessibilityElementsHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            for index in nonViewElements.indices {
                if nonViewElements[index].accessibilityFrame.contains(touch.location(in: nil)) {
                    nonViewElements[index].accessibilityValue = "1"
                }
            }
        }
    }
}
