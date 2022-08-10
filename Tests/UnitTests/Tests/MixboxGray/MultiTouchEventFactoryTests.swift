import MixboxGray
import MixboxIoKit
import MixboxFoundation
import XCTest

// Note: events were produced using AppForCheckingPureXctest, simulator and cliclick (brew instal cliclick)
// Note: `nativeDebugDescription` can be used to view event properties, it uses IOKit.
//
// TODO: Not checked: `Total Latency`, `SenderID`, `BuiltIn`,
//       `AttributeDataLength`, `AttributeData`, `ValueType`, `TransducerIndex`,
//       `Events`
final class MultiTouchEventFactoryTests: BaseEventTestCase {
    private lazy var time: AbsoluteTime = random()
    private let point = CGPoint(x: 123, y: 125)
    
    // swiftlint:disable:next function_body_length
    func test___aggregatingTouchEvent___produces_event_similar_to_real___for_tap_began() {
        let event = self.event(phase: .began)
        
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Timestamp:           2741653208282893
        // Total Latency:       942 us
        // [1mSenderID:            0x0ACEFADE00000003 NON KERNEL SENDER
        // [0mBuiltIn:             1
        // AttributeDataLength: 84
        // AttributeData:       02 00 00 00 44 00 00 00 c9 01 0b 67 8b 03 a9 9a ca ea 44 41 01 00 00 00 00 00 c8 43 01 00 00 00 00 00 00 00 24 00 00 00 01 00 00 00 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ee 42 00 00 1d 43 00 00 ee 42 00 00 1d 43 00 00 00 00 00 00 00 00
        // ValueType:           Absolute
        // EventType:           Digitizer
        // Flags:               0xa0015
        // DisplayIntegrated:   1
        // TransducerType:      Hand
        // TransducerIndex:     0
        // Identity:            0
        // EventMask:           2
        // Events:              Touch
        // ButtonMask:          0
        // Range:               0
        // Touch:               1
        // Pressure:            0.000000
        // AuxiliaryPressure:   0.000000
        // Twist:               0.000000
        // GenerationCount:     0
        // WillUpdateMask:      00000000
        // DidUpdateMask:       00000000
        // X:                   0.000000
        // Y:                   0.000000
        // Z:                   0.000000
        // TiltX:               0.000000
        // TiltY:               0.000000
        
        XCTAssertEqual(event.timeStamp, time)
        XCTAssertEqual(event.type, .digitizer)
        XCTAssertEqual(event.options.rawValue, 0xa0015)
        XCTAssertEqual(event.isDisplayIntegrated, true)
        XCTAssertEqual(event.transducer, .hand)
        XCTAssertEqual(event.identity, 0)
        XCTAssertEqual(event.eventMask.rawValue, 2)
        XCTAssertEqual(event.buttonMask, 0)
        XCTAssertEqual(event.range, false)
        XCTAssertEqual(event.touch, true)
        XCTAssertEqual(event.pressure, 0)
        XCTAssertEqual(event.auxiliaryPressure, 0)
        XCTAssertEqual(event.twist, 0)
        XCTAssertEqual(event.generationCount, 0)
        XCTAssertEqual(event.willUpdateMask, 0)
        XCTAssertEqual(event.didUpdateMask, 0)
        XCTAssertEqual(event.x, 0)
        XCTAssertEqual(event.y, 0)
        XCTAssertEqual(event.z, 0)
        
        // Specific:
        XCTAssertEqual(event.tiltX, 0)
        XCTAssertEqual(event.tiltY, 0)
        
        // ChildEvents:
        //     -----------------------------------------------------------------------
        //     ValueType:           Absolute
        //     EventType:           Digitizer
        //     Flags:               0xb0001
        //     DisplayIntegrated:   1
        //     TransducerType:      Finger
        //     TransducerIndex:     1
        //     Identity:            2
        //     EventMask:           3
        //     Events:              Range Touch
        //     ButtonMask:          0
        //     Range:               1
        //     Touch:               1
        //     Pressure:            0.000000
        //     AuxiliaryPressure:   0.000000
        //     Twist:               90.000000
        //     GenerationCount:     0
        //     WillUpdateMask:      00000000
        //     DidUpdateMask:       00000000
        //     X:                   119.000000
        //     Y:                   157.000000
        //     Z:                   0.000000
        //     Quality:             1.500000
        //     Density:             1.500000
        //     Irregularity:        0.000000
        //     MajorRadius:         4.599991
        //     MinorRadius:         3.799988
        //     Accuracy:            0.000000
        //     -----------------------------------------------------------------------
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        let childEvent = (event.children.mb_only as? DigitizerFingerEvent).unwrapOrFail()
        
        XCTAssertEqual(childEvent.timeStamp, time)
        XCTAssertEqual(childEvent.type, .digitizer)
        XCTAssertEqual(childEvent.options.rawValue, 0xb0001)
        XCTAssertEqual(childEvent.isDisplayIntegrated, true)
        XCTAssertEqual(childEvent.transducer, .finger)
        XCTAssertEqual(childEvent.identity, 2)
        XCTAssertEqual(childEvent.eventMask.rawValue, 3)
        XCTAssertEqual(childEvent.buttonMask, 0)
        XCTAssertEqual(childEvent.range, true)
        XCTAssertEqual(childEvent.touch, true)
        XCTAssertEqual(childEvent.pressure, 0)
        XCTAssertEqual(childEvent.auxiliaryPressure, 0)
        XCTAssertEqual(childEvent.twist, 90)
        XCTAssertEqual(childEvent.generationCount, 0)
        XCTAssertEqual(childEvent.willUpdateMask, 0)
        XCTAssertEqual(childEvent.didUpdateMask, 0)
        XCTAssertEqual(childEvent.x, Double(point.x))
        XCTAssertEqual(childEvent.y, Double(point.y))
        XCTAssertEqual(childEvent.z, 0)
        
        // Specific:
        XCTAssertEqual(childEvent.quality, 1.5)
        XCTAssertEqual(childEvent.density, 1.5)
        XCTAssertEqual(childEvent.irregularity, 0)
        XCTAssertEqual(childEvent.majorRadius, 4.599991, accuracy: 0.001)
        XCTAssertEqual(childEvent.minorRadius, 3.799988, accuracy: 0.001)
        XCTAssertEqual(childEvent.qualityRadiiAccuracy, 0)
    }
    
    // swiftlint:disable:next function_body_length
    func test___aggregatingTouchEvent___produces_event_similar_to_real___for_tap_ended() {
        let event = self.event(phase: .ended)
        
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Timestamp:           2741653222546207
        // Total Latency:       629 us
        // [1mSenderID:            0x0ACEFADE00000003 NON KERNEL SENDER
        // [0mBuiltIn:             1
        // AttributeDataLength: 84
        // AttributeData:       02 00 00 00 44 00 00 00 c9 01 0b 67 8b 03 a9 9a ca ea 44 41 00 00 00 00 00 00 c8 43 01 00 00 00 00 00 00 00 24 00 00 00 01 00 00 00 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ee 42 00 00 1d 43 00 00 ee 42 00 00 1d 43 00 00 00 00 00 00 00 00
        // ValueType:           Absolute
        // EventType:           Digitizer
        // Flags:               0x80015
        // DisplayIntegrated:   1
        // TransducerType:      Hand
        // TransducerIndex:     0
        // Identity:            0
        // EventMask:           2
        // Events:              Touch
        // ButtonMask:          0
        // Range:               0
        // Touch:               0
        // Pressure:            0.000000
        // AuxiliaryPressure:   0.000000
        // Twist:               0.000000
        // GenerationCount:     0
        // WillUpdateMask:      00000000
        // DidUpdateMask:       00000000
        // X:                   0.000000
        // Y:                   0.000000
        // Z:                   0.000000
        // TiltX:               0.000000
        // TiltY:               0.000000
        
        XCTAssertEqual(event.timeStamp, time)
        XCTAssertEqual(event.type, .digitizer)
        // TODO: Remove clamping (& 0x1F)
        XCTAssertEqual(event.options.rawValue, 0x80015)
        XCTAssertEqual(event.isDisplayIntegrated, true)
        XCTAssertEqual(event.transducer, .hand)
        XCTAssertEqual(event.identity, 0)
        XCTAssertEqual(event.eventMask.rawValue, 2)
        XCTAssertEqual(event.buttonMask, 0)
        XCTAssertEqual(event.range, false)
        XCTAssertEqual(event.touch, false)
        XCTAssertEqual(event.pressure, 0)
        XCTAssertEqual(event.auxiliaryPressure, 0)
        XCTAssertEqual(event.twist, 0)
        XCTAssertEqual(event.generationCount, 0)
        XCTAssertEqual(event.willUpdateMask, 0)
        XCTAssertEqual(event.didUpdateMask, 0)
        XCTAssertEqual(event.x, 0)
        XCTAssertEqual(event.y, 0)
        XCTAssertEqual(event.z, 0)
        
        // Specific:
        XCTAssertEqual(event.tiltX, 0)
        XCTAssertEqual(event.tiltY, 0)
        
        //
        // ChildEvents:
        //     -----------------------------------------------------------------------
        //     ValueType:           Absolute
        //     EventType:           Digitizer
        //     Flags:               0x80001
        //     DisplayIntegrated:   1
        //     TransducerType:      Finger
        //     TransducerIndex:     1
        //     Identity:            2
        //     EventMask:           3
        //     Events:              Range Touch
        //     ButtonMask:          0
        //     Range:               0
        //     Touch:               0
        //     Pressure:            0.000000
        //     AuxiliaryPressure:   0.000000
        //     Twist:               90.000000
        //     GenerationCount:     0
        //     WillUpdateMask:      00000000
        //     DidUpdateMask:       00000000
        //     X:                   119.000000
        //     Y:                   157.000000
        //     Z:                   0.000000
        //     Quality:             1.500000
        //     Density:             1.500000
        //     Irregularity:        0.000000
        //     MajorRadius:         4.599991
        //     MinorRadius:         3.799988
        //     Accuracy:            0.000000
        //     -----------------------------------------------------------------------
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        let childEvent = (event.children.mb_only as? DigitizerFingerEvent).unwrapOrFail()
        
        XCTAssertEqual(childEvent.timeStamp, time)
        XCTAssertEqual(childEvent.type, .digitizer)
        // TODO: Remove clamping (& 0x1F)
        XCTAssertEqual(childEvent.options.rawValue, 0x80001)
        XCTAssertEqual(childEvent.isDisplayIntegrated, true)
        XCTAssertEqual(childEvent.transducer, .finger)
        XCTAssertEqual(childEvent.identity, 2)
        XCTAssertEqual(childEvent.eventMask.rawValue, 3)
        XCTAssertEqual(childEvent.buttonMask, 0)
        XCTAssertEqual(childEvent.range, false)
        XCTAssertEqual(childEvent.touch, false)
        XCTAssertEqual(childEvent.pressure, 0)
        XCTAssertEqual(childEvent.auxiliaryPressure, 0)
        XCTAssertEqual(childEvent.twist, 90)
        XCTAssertEqual(childEvent.generationCount, 0)
        XCTAssertEqual(childEvent.willUpdateMask, 0)
        XCTAssertEqual(childEvent.didUpdateMask, 0)
        XCTAssertEqual(childEvent.x, Double(point.x))
        XCTAssertEqual(childEvent.y, Double(point.y))
        XCTAssertEqual(childEvent.z, 0)
        
        // Specific:
        XCTAssertEqual(childEvent.quality, 1.5)
        XCTAssertEqual(childEvent.density, 1.5)
        XCTAssertEqual(childEvent.irregularity, 0)
        XCTAssertEqual(childEvent.majorRadius, 4.599991, accuracy: 0.001)
        XCTAssertEqual(childEvent.minorRadius, 3.799988, accuracy: 0.001)
        XCTAssertEqual(childEvent.qualityRadiiAccuracy, 0)
    }
    
    private func event(phase: DequeuedMultiTouchInfo.TouchInfo.Phase) -> DigitizerEvent {
        let factory = MultiTouchEventFactoryImpl(
            aggregatingTouchEventFactory: AggregatingTouchEventFactoryImpl(),
            fingerTouchEventFactory: FingerTouchEventFactoryImpl()
        )
        return factory.multiTouchEvent(
            dequeuedMultiTouchInfo: DequeuedMultiTouchInfo(
                touchesByFinger: [
                    DequeuedMultiTouchInfo.TouchInfo(
                        point: point,
                        phase: phase
                    )
                ]
            ),
            time: time
        )
    }
}
