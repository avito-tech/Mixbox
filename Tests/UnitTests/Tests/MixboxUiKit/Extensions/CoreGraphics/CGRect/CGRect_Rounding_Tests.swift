import XCTest
import MixboxUiKit

// swiftlint:disable function_body_length
final class CGRect_Rounding_Tests: TestCase {
    func test___mb_integralInside() {
        func assert(_ source: CGRect, _ expected: CGRect, file: StaticString = #file, line: UInt = #line) {
            Self.assert(source, { $0.mb_integralInside() }, expected, file: file, line: line)
        }
        
        func expectedRect(
            left: CGFloat = 1,
            right: CGFloat = 1,
            top: CGFloat = 1,
            bottom: CGFloat = 1)
            -> CGRect
        {
            return CGRect.mb_init(
                left: left,
                right: right,
                top: top,
                bottom: bottom
            )
        }
        
        // Left/top, int values
        
        assert(
            sourceRect(left: 0),
            expectedRect(left: 0)
        )
        assert(
            sourceRect(left: 1),
            expectedRect(left: 1)
        )
        assert(
            sourceRect(top: 0),
            expectedRect(top: 0)
        )
        assert(
            sourceRect(top: 1),
            expectedRect(top: 1)
        )
        
        // Left/top, float values
        
        assert(
            sourceRect(left: 0.1),
            expectedRect(left: 1)
        )
        assert(
            sourceRect(left: 0.5),
            expectedRect(left: 1)
        )
        assert(
            sourceRect(left: 0.9),
            expectedRect(left: 1)
        )
        
        assert(
            sourceRect(top: 0.1),
            expectedRect(top: 1)
        )
        assert(
            sourceRect(left: 0.5),
            expectedRect(top: 1)
        )
        assert(
            sourceRect(left: 0.9),
            expectedRect(top: 1)
        )
        
        // Right/bottom, int values
        
        assert(
            sourceRect(right: 1),
            expectedRect(right: 1)
        )
        assert(
            sourceRect(right: 2),
            expectedRect(right: 2)
        )
        assert(
            sourceRect(bottom: 1),
            expectedRect(bottom: 1)
        )
        assert(
            sourceRect(bottom: 2),
            expectedRect(bottom: 2)
        )
        
        // Right/bottom, float values
        
        assert(
            sourceRect(right: 1.1),
            expectedRect(right: 1)
        )
        assert(
            sourceRect(right: 1.5),
            expectedRect(right: 1)
        )
        assert(
            sourceRect(right: 1.9),
            expectedRect(right: 1)
        )
        
        assert(
            sourceRect(bottom: 1.1),
            expectedRect(bottom: 1)
        )
        assert(
            sourceRect(bottom: 1.5),
            expectedRect(bottom: 1)
        )
        assert(
            sourceRect(bottom: 1.9),
            expectedRect(bottom: 1)
        )
    }
    
    func test___mb_integralOutside() {
        func assert(_ source: CGRect, _ expected: CGRect, file: StaticString = #file, line: UInt = #line) {
            Self.assert(source, { $0.mb_integralOutside() }, expected, file: file, line: line)
        }
        
        func expectedRect(
            left: CGFloat = 0,
            right: CGFloat = 2,
            top: CGFloat = 0,
            bottom: CGFloat = 2)
            -> CGRect
        {
            return CGRect.mb_init(
                left: left,
                right: right,
                top: top,
                bottom: bottom
            )
        }
        
        // Left/top, int values
        
        assert(
            sourceRect(left: 0),
            expectedRect(left: 0)
        )
        assert(
            sourceRect(left: 1),
            expectedRect(left: 1)
        )
        assert(
            sourceRect(top: 0),
            expectedRect(top: 0)
        )
        assert(
            sourceRect(top: 1),
            expectedRect(top: 1)
        )
        
        // Left/top, float values
        
        assert(
            sourceRect(left: 0.1),
            expectedRect(left: 0)
        )
        assert(
            sourceRect(left: 0.5),
            expectedRect(left: 0)
        )
        assert(
            sourceRect(left: 0.9),
            expectedRect(left: 0)
        )
        
        assert(
            sourceRect(top: 0.1),
            expectedRect(top: 0)
        )
        assert(
            sourceRect(left: 0.5),
            expectedRect(top: 0)
        )
        assert(
            sourceRect(left: 0.9),
            expectedRect(top: 0)
        )
        
        // Right/bottom, int values
        
        assert(
            sourceRect(right: 1),
            expectedRect(right: 1)
        )
        assert(
            sourceRect(right: 2),
            expectedRect(right: 2)
        )
        assert(
            sourceRect(bottom: 1),
            expectedRect(bottom: 1)
        )
        assert(
            sourceRect(bottom: 2),
            expectedRect(bottom: 2)
        )
        
        // Right/bottom, float values
        
        assert(
            sourceRect(right: 1.1),
            expectedRect(right: 2)
        )
        assert(
            sourceRect(right: 1.5),
            expectedRect(right: 2)
        )
        assert(
            sourceRect(right: 1.9),
            expectedRect(right: 2)
        )
        
        assert(
            sourceRect(bottom: 1.1),
            expectedRect(bottom: 2)
        )
        assert(
            sourceRect(bottom: 1.5),
            expectedRect(bottom: 2)
        )
        assert(
            sourceRect(bottom: 1.9),
            expectedRect(bottom: 2)
        )
    }
    
    func sourceRect(
        left: CGFloat = 0.5,
        right: CGFloat = 1.5,
        top: CGFloat = 0.5,
        bottom: CGFloat = 1.5)
        -> CGRect
    {
        return CGRect.mb_init(
            left: left,
            right: right,
            top: top,
            bottom: bottom
        )
    }
    
    private static func assert(
        _ source: CGRect,
        _ transform: (CGRect) -> CGRect,
        _ expected: CGRect,
        file: StaticString = #file,
        line: UInt = #line)
    {
        func coordinates(_ rect: CGRect) -> String {
            return "(\(rect.mb_left), \(rect.mb_right), \(rect.mb_top), \(rect.mb_bottom))"
        }
        
        let actual = transform(source)
        
        XCTAssertEqual(
            actual,
            expected,
            """
            Rects aren't equal. \
            Coordinates: \(coordinates(actual)) != \(coordinates(expected)). \
            Source coordinates: \(coordinates(source)).  \
            Source rect: \(source).
            """,
            file: file,
            line: line
        )
    }
}
