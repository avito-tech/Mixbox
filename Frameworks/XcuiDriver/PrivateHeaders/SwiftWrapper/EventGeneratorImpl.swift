import MixboxTestsFoundation
import MixboxFoundation

public final class EventGeneratorImpl: EventGenerator {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider
            = applicationProvider
    }
    
    public func pressAndDrag(from: CGPoint, to: CGPoint, duration: TimeInterval, velocity: Double) {
        let actionName = "Press \(from) for \(duration)s and drag to \(to) with velocity \(velocity)"
        self.perform(actionName: actionName) { generator, completion in
            // Interesting fact: the method returns duration of the event + 30 seconds.
            return generator.press(
                at: from,
                forDuration: duration,
                liftAt: to,
                velocity: velocity,
                orientation: Int64(UIInterfaceOrientation.portrait.rawValue), // TODO: How to use it? TODO: Test rotation.
                name: actionName,
                handler: { (_ record: XCSynthesizedEventRecord?, _ error: Error?) in
                    completion(record, error)
                }
            )
        }
    }
    
    public func tap(point: CGPoint, numberOfTaps: UInt) {
        let actionName = "Tap \(point)"
        self.perform(actionName: actionName) { generator, completion in
            return generator.tap(
                atTouchLocations: NSArray(array: [NSValue(cgPoint: point)]),
                numberOfTaps: UInt64(numberOfTaps),
                orientation: Int64(UIInterfaceOrientation.portrait.rawValue),
                handler: { (_ record: XCSynthesizedEventRecord?, _ error: Error?) in
                    completion(record, error)
                }
            )
        }
    }
    
    private typealias EventGeneratorCompletion = (_ record: XCSynthesizedEventRecord?, _ error: Error?) -> ()
    
    private func perform(
        actionName: String,
        actionClosure: @escaping (_ generator: XCEventGenerator, _ completion: @escaping EventGeneratorCompletion) -> (Double))
    {
        guard let xcEventGenerator = XCEventGenerator.shared() else {
            // TODO: Handle
            return
        }
        
        perform_v1(
            xcEventGenerator: xcEventGenerator,
            actionName: actionName,
            actionClosure: actionClosure
        )
    }
    
    // TODO: Remove, it seems that v1 works. TODO: Test on different versions of Xcode
    private func perform_v0(
        xcEventGenerator: XCEventGenerator,
        actionName: String,
        actionClosure: @escaping (_ generator: XCEventGenerator, _ completion: @escaping EventGeneratorCompletion) -> (Double))
    {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        // Without this line events were not generated in >50% cases
        applicationProvider.application._waitForQuiescence()
        
        var timeToPerformEvent: TimeInterval = 1.0
        
        _ = actionClosure(xcEventGenerator) { record, error in
            // TODO: handle error
            if let error = error {
                print("error: \(error)")
            }
            
            if let offset = record?.maximumOffset {
                timeToPerformEvent = offset + 0.0
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        Thread.sleep(forTimeInterval: timeToPerformEvent)
    }
    
    private func perform_v1(
        xcEventGenerator: XCEventGenerator,
        actionName: String,
        actionClosure: @escaping (_ generator: XCEventGenerator, _ completion: @escaping EventGeneratorCompletion) -> (Double))
    {
        applicationProvider.application._waitForQuiescence()
        
        applicationProvider.application._dispatchEvent(actionName, block: { snapshot, handler in
            return actionClosure(xcEventGenerator) { record, error in
                handler?(record, error)
            }
        })
    }
}
