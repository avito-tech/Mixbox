import MixboxTestsFoundation

final class EventGenerator {
    static let instance = EventGenerator()
    
    private init() {
    }
    
    func swipe(from: CGPoint, to: CGPoint) {
        self.perform { generator, completion in
            // Interesting fact: the method returns duration of the event + 30 seconds.
            _ = generator.press(
                at: from,
                forDuration: 0,
                liftAt: to,
                velocity: 1000,
                orientation: Int64(UIInterfaceOrientation.portrait.rawValue), // TODO: How to use it? TODO: Test rotation.
                name: "swipe",
                handler: { (_ record: XCSynthesizedEventRecord?, _ error: Error?) in
                    completion(record, error)
                }
            )
        }
    }
    
    private typealias EventGeneratorCompletion = (_ record: XCSynthesizedEventRecord?, _ error: Error?) -> ()
    
    private func perform(closure: @escaping (_ generator: XCEventGenerator, _ completion: @escaping EventGeneratorCompletion) -> ()) {
        guard let xcEventGenerator = XCEventGenerator.shared() else {
            // TODO: Handle
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        // Without this line events were not generated in >50% cases
        XCUIApplication()._waitForQuiescence()
        
        var timeToPerformEvent: TimeInterval = 1.0
        
        closure(xcEventGenerator) { record, error in
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
}
