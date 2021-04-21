import MixboxReflection
import UIKit
import XCTest

final class ValueIsObjectCheckerTests: TestCase {
    func test() {
        checkIsObject(self)
        checkIsObject(NSNumber(value: 1))
        checkIsObject((1 as AnyObject) as Any)// SE-0116, value is bridged to Obj-C here
        
        checkIsNotObject(1)
        checkIsNotObject((nil as Int?) as Any)
        checkIsNotObject(CGRect())
    }
    
    private func checkIsObject(
        _ value: Any,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        XCTAssertTrue(
            ValueIsObjectChecker.isObject(value),
            "Value \(value) is not object",
            file: file,
            line: line
        )
    }
    
    private func checkIsNotObject(
        _ value: Any,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        XCTAssertFalse(
            ValueIsObjectChecker.isObject(value),
            "Value \(value) is object",
            file: file,
            line: line
        )
    }
}
