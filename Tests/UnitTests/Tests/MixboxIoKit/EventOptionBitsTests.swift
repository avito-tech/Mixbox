import MixboxIoKit
import XCTest

final class EventOptionBitsTests: TestCase {
    func test___debugDescription___is_correct() {
        XCTAssertEqual(
            ([.isAbsolute, .isPixelUnits, .transducer.touch, .keyboard.stickyKeysOff] as EventOptionBits).debugDescription,
            "(EventOptionBits: isAbsolute (0x1) & isPixelUnits (0x4) & keyboard.stickyKeyDown or transducer.touch (0x20000) & keyboard.stickyKeysOff (0x400000))"
        )
    }
    
    func test___debugDescription___is_correct___when_assumedOptionBitType_is_transducer() {
        XCTAssertEqual(
            ([.isAbsolute, .isPixelUnits, .transducer.touch, .keyboard.stickyKeysOff] as EventOptionBits).debugDescription(assumedOptionBitType: .transducer),
            "(EventOptionBits: isAbsolute (0x1) & isPixelUnits (0x4) & transducer.touch (0x20000) & unknown option bits (0x400000), found bits irrelevant for given assumedOptionBitType (transducer): keyboard.stickyKeysOff (0x400000))"
        )
    }
    
    func test___debugDescription___is_correct___when_assumedOptionBitType_is_keyboard() {
        XCTAssertEqual(
            ([.isAbsolute, .isPixelUnits, .transducer.touch, .keyboard.stickyKeysOff] as EventOptionBits).debugDescription(assumedOptionBitType: .keyboard),
            "(EventOptionBits: isAbsolute (0x1) & isPixelUnits (0x4) & keyboard.stickyKeyDown (0x20000) & keyboard.stickyKeysOff (0x400000))"
        )
    }
    
    func test___debugDescription___is_correct___when_assumedOptionBitType_is_general() {
        XCTAssertEqual(
            ([.isAbsolute, .isPixelUnits, .transducer.touch, .keyboard.stickyKeysOff] as EventOptionBits).debugDescription(assumedOptionBitType: .general),
            "(EventOptionBits: isAbsolute (0x1) & isPixelUnits (0x4) & unknown option bits (0x420000), found bits irrelevant for given assumedOptionBitType (general): keyboard.stickyKeyDown or transducer.touch (0x20000) & keyboard.stickyKeysOff (0x400000))"
        )
    }
}
