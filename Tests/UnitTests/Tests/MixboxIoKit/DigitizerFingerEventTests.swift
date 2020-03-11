import MixboxFoundation
import MixboxIoKit
import XCTest
import MixboxGray

final class DigitizerFingerEventTests: BaseEventTestCase {
    func test___type___returns_correct_type() {
        XCTAssertEqual(digitizerFingerEvent().type, EventType.digitizer)
    }
    
    func test___transducer___is_finger_by_default() {
        XCTAssertEqual(digitizerFingerEvent().transducer, .finger)
    }
    
    func test___timeStamp___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(timeStamp: $0).timeStamp
        }
    }
    
    func test___index___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(index: $0).index
        }
    }
    
    func test___identifier___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(identity: $0).identity
        }
    }
    
    func test___eventMask___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(eventMask: $0).eventMask
        }
    }
    
    func test___x___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(x: $0).x
        }
    }
    
    func test___y___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(y: $0).y
        }
    }
    
    func test___z___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(z: $0).z
        }
    }
    
    func test___tipPressure___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(tipPressure: $0).pressure
        }
    }
    
    func test___twist___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(twist: $0).twist
        }
    }
    
    func test___range___returns_value_set_in_init() {
        for value in [false, true] {
            checkValueIsPassedViaInit(value: value) {
                digitizerFingerEvent(range: $0).range
            }
        }
    }
    
    func test___touch___returns_value_set_in_init() {
        for value in [false, true] {
            checkValueIsPassedViaInit(value: value) {
                digitizerFingerEvent(range: $0).range
            }
        }
    }
    
    func test___options___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerFingerEvent(options: $0).options
        }
    }
    
    private func digitizerFingerEvent(
        allocator: CFAllocator? = kCFAllocatorDefault,
        timeStamp: AbsoluteTime = AbsoluteTime(lo: 2, hi: 1),
        index: UInt32 = 0,
        identity: UInt32 = 0,
        eventMask: DigitizerEventMask = [],
        x: Double = 0,
        y: Double = 0,
        z: Double = 0,
        tipPressure: Double = 0,
        twist: Double = 0,
        range: Bool = false,
        touch: Bool = false,
        options: EventOptionBits = [])
        -> DigitizerFingerEvent
    {
        return DigitizerFingerEvent(
            allocator: allocator,
            timeStamp: timeStamp,
            index: index,
            identity: identity,
            eventMask: eventMask,
            x: x,
            y: y,
            z: z,
            tipPressure: tipPressure,
            twist: twist,
            range: range,
            touch: touch,
            options: options
        )
    }
}
