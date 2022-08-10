import MixboxFoundation
import MixboxIoKit
import XCTest
import MixboxGray

final class DigitizerEventTests: BaseEventTestCase {
    func test___type___returns_correct_type() {
        XCTAssertEqual(digitizerEvent().type, EventType.digitizer)
    }
    
    func test___timeStamp___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(timeStamp: $0).timeStamp
        }
    }
    
    func test___transducer___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(transducer: $0).transducer
        }
    }
    
    func test___index___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(index: $0).index
        }
    }
    
    func test___identifier___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(identity: $0).identity
        }
    }
    
    func test___eventMask___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(eventMask: $0).eventMask
        }
    }
    
    func test___buttonMask___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(buttonMask: $0).buttonMask
        }
    }
    
    func test___x___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(x: $0).x
        }
    }
    
    func test___y___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(y: $0).y
        }
    }
    
    func test___z___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(z: $0).z
        }
    }
    
    func test___tipPressure___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(tipPressure: $0).pressure
        }
    }
    
    func test___twist___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(twist: $0).twist
        }
    }
    
    func test___range___returns_value_set_in_init() {
        for value in [false, true] {
            checkValueIsPassedViaInit(value: value) {
                digitizerEvent(range: $0).range
            }
        }
    }
    
    func test___touch___returns_value_set_in_init() {
        for value in [false, true] {
            checkValueIsPassedViaInit(value: value) {
                digitizerEvent(touch: $0).touch
            }
        }
    }
    
    func test___options___returns_value_set_in_init() {
        checkValueIsPassedViaInit(value: random()) {
            digitizerEvent(options: $0).options
        }
    }
    
    private func digitizerEvent(
        allocator: CFAllocator? = kCFAllocatorDefault,
        timeStamp: AbsoluteTime = AbsoluteTime(lo: 2, hi: 1),
        transducer: DigitizerTransducerType = .unknown(0),
        index: UInt32 = 0,
        identity: UInt32 = 0,
        eventMask: DigitizerEventMask = [],
        buttonMask: ButtonMask = 0,
        x: Double = 0,
        y: Double = 0,
        z: Double = 0,
        tipPressure: Double = 0,
        twist: Double = 0,
        range: Bool = false,
        touch: Bool = false,
        options: EventOptionBits = [])
        -> DigitizerEvent
    {
        return DigitizerEvent(
            allocator: allocator,
            timeStamp: timeStamp,
            transducer: transducer,
            index: index,
            identity: identity,
            eventMask: eventMask,
            buttonMask: buttonMask,
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
