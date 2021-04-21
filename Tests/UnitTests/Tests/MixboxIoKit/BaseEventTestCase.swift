import MixboxIoKit
import XCTest
import MixboxFoundation

class BaseEventTestCase: TestCase {
    func checkValueIsPassedViaInit<T: Equatable>(
        value: T,
        file: StaticString = #filePath,
        line: UInt = #line,
        initAndGetValue: (T) -> T)
    {
        XCTAssertEqual(
            initAndGetValue(value),
            value,
            file: file,
            line: line
        )
    }
    
    // TODO: Implement random data generation tools
    @nonobjc
    func random() -> Int {
        return 30294
    }
    
    @nonobjc
    func random() -> Double {
        return 30294
    }
    
    @nonobjc
    func random() -> UInt32 {
        return 30294
    }
    
    @nonobjc
    func random() -> DigitizerEventMask {
        return [.range, .touch, .swipeMask]
    }
    
    @nonobjc
    func random() -> EventOptionBits {
        return [.isAbsolute, .isPixelUnits]
    }
    
    @nonobjc
    func random() -> DigitizerTransducerType {
        return DigitizerTransducerType.puck
    }
    
    @nonobjc
    func random() -> AbsoluteTime {
        return AbsoluteTime(lo: random(), hi: random())
    }
}
