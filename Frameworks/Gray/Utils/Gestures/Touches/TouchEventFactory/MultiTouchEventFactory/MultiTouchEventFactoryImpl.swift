import MixboxFoundation
import MixboxInAppServices
import MixboxIoKit

public final class MultiTouchEventFactoryImpl: MultiTouchEventFactory {
    private let aggregatingTouchEventFactory: AggregatingTouchEventFactory
    private let fingerTouchEventFactory: FingerTouchEventFactory
    
    public init(
        aggregatingTouchEventFactory: AggregatingTouchEventFactory,
        fingerTouchEventFactory: FingerTouchEventFactory)
    {
        self.aggregatingTouchEventFactory = aggregatingTouchEventFactory
        self.fingerTouchEventFactory = fingerTouchEventFactory
    }
    
    public func multiTouchEvent(dequeuedMultiTouchInfo: DequeuedMultiTouchInfo, time: AbsoluteTime) -> Event {
        let aggregatingEvent = aggregatingTouchEventFactory.aggregatingTouchEvent(
            dequeuedMultiTouchInfo: dequeuedMultiTouchInfo,
            time: time
        )
        
        let fingerEvents = fingerTouchEventFactory.fingerEvents(
            dequeuedMultiTouchInfo: dequeuedMultiTouchInfo,
            time: time
        )
        
        fingerEvents.forEach { nestedEvent in
            aggregatingEvent.append(event: nestedEvent, options: [])
        }
        
        return aggregatingEvent
    }
}
