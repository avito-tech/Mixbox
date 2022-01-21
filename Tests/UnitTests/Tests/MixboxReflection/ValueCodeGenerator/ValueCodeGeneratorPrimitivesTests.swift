import XCTest
import MixboxReflection
import UIKit

final class ValueCodeGeneratorPrimitivesTests: BaseValueCodeGeneratorTests {
    func test___generateCode___generates_code___for_Int() {
        check(
            1,
            """
            1
            """
        )
    }
    
    func test___generateCode___generates_code___for_Int8() {
        check(
            Int8(1),
            """
            Int8(1)
            """
        )
    }
    
    func test___generateCode___generates_code___for_UInt8() {
        check(
            UInt8(1),
            """
            UInt8(1)
            """
        )
    }
    
    func test___generateCode___generates_code___for_Double() {
        check(
            1.0,
            """
            1.0
            """
        )
    }
    
    func test___generateCode___generates_code___for_Float() {
        check(
            Float(1.0),
            """
            Float(1.0)
            """
        )
    }
    
    func test___generateCode___generates_code___for_CGFloat() {
        check(
            CGFloat(1.0),
            """
            CGFloat(1.0)
            """
        )
    }
    
    func test___generateCode___generates_code___for_String() {
        check(
            "a string",
            """
            "a string"
            """
        )
    }
    
    func test___generateCode___generates_code___for_StaticString() {
        check(
            StaticString("a string"),
            """
            StaticString("a string")
            """
        )
    }
}
