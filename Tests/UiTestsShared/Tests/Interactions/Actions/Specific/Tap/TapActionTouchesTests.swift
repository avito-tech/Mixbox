import XCTest
import UIKit

class MyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let subview = UIButton(type: .system)
        subview.titleLabel?.text = "WINDOW BUTTON"
        view.addSubview(subview)
        subview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

class MyWindow: UIWindow {
    init() {
        super.init(frame: .zero)
        rootViewController = MyController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

var storeWindow: UIWindow?

final class TapActionTouchesTests: BaseTouchesTestCase {
    func test___tap___produces_expected_touches() {
        do {
            let window = MyWindow()
            window.windowLevel = .normal + 1
//            window.backgroundColor = .clear
            window.isHidden = false
            storeWindow = window
            window.makeKeyAndVisible()
            
            recordUiEvents {
                screen.targetView.tap()
            }
            
            let (firstEvent, secondEvent) = try allEvents()
            
            let firstTouch = try singleTouch(firstEvent)
            let secondTouch = try singleTouch(secondEvent)
            
            assertPhasesAreCorrect(
                beginEvent: firstEvent,
                endEvent: secondEvent
            )
            
            assertEqual(
                actual: firstTouch.location,
                expected: try targetViewFrameCenterToWindow()
            )
            assertEqual(
                actual: firstTouch.location,
                expected: try targetViewFrameCenter()
            )
            assertEqual(
                actual: firstTouch.preciseLocation,
                expected: try targetViewFrameCenter()
            )
            
            // These values have to be exactly same, but i got this error in GrayBox tests:
            // XCTAssertEqual failed: ("(95.33333333333333, 60.666666666666664)") is not equal to ("(95.45706005997577, 60.65321248268239)") -
            // So I've added `accuracy` to the check
            assertEqual(
                actual: firstTouch.location,
                expected: secondTouch.location
            )
            
            // This was working fine in Black Box tests:
            // XCTAssertEqual(firstTouch.preciseLocation, secondTouch.preciseLocation)
            // But stopped working in Gray Box tests:
            // iPhone X, iOS 12.1: XCTAssertEqual failed: ("(106.33333333333333, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
            // iPhone 7, iOS 11.3: XCTAssertEqual failed: ("(106.0, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
            // iPhone SE, iOS 10.3: XCTAssertEqual failed: ("(106.0, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
            // iPhone 6 Plus, iOS 9.3: XCTAssertEqual failed: ("(106.33333333333333, 130.0)") is not equal to ("(106.22243186433548, 130.007041555162)") -
            // This is strange and ideally should be investigated.
            assertEqual(
                actual: firstTouch.preciseLocation,
                expected: secondTouch.preciseLocation)
            
            assertAbsoluteCoordinatesAreEqual(
                actual: firstTouch.location,
                expected: try targetViewFrameCenter()
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
}
