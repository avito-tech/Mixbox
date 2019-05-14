import MixboxFoundation

// Translated from Objective-C to Swift.
// Source: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Event/GREYSyntheticEvents.m
public final class TouchPerformerImpl: TouchPerformer {
    private let multiTouchCommandExecutor: MultiTouchCommandExecutor
    
    public init(multiTouchCommandExecutor: MultiTouchCommandExecutor) {
        self.multiTouchCommandExecutor = multiTouchCommandExecutor
    }
    
    public func touch(
        touchPaths: [[CGPoint]],
        relativeToWindow window: UIWindow,
        duration: TimeInterval,
        expendable: Bool)
        throws
    {
        guard touchPaths.count >= 1 else {
            throw ErrorString("Failed: touchPaths.count >= 1")
        }
        guard duration >= 0 else {
            throw ErrorString("Failed: duration >= 0")
        }
        
        let firstTouchPathSize = touchPaths[0].count
        
        let beginCommand = MultiTouchCommand.Begin(
            points: try objects(
                index: 0,
                arrays: touchPaths
            ),
            relativeToWindow: window,
            waitUntilAllTouchesAreDelivered: false
        )
        
        let continueCommands: [MultiTouchCommand.Continue]
        let endCommand: MultiTouchCommand.End
        
        // If the paths have a single point, then just inject an "end" event with the delay being the
        // provided duration. Otherwise, insert multiple "continue" events with delays being a fraction
        // of the duration, then inject an "end" event with no delay.
        if firstTouchPathSize == 1 {
            continueCommands = []
            endCommand = MultiTouchCommand.End(
                points: try objects(
                    index: firstTouchPathSize - 1,
                    arrays: touchPaths
                ),
                timeElapsedSinceLastTouchDelivery: duration
            )
        } else {
            // Start injecting "continue touch" events, starting from the second position on the touch
            // path as it was already injected as a "begin touch" event.
            let delayBetweenEachEvent = CFTimeInterval(duration / Double(firstTouchPathSize - 1))
            
            continueCommands = try (1..<firstTouchPathSize).map { i in
                MultiTouchCommand.Continue(
                    points: try objects(
                        index: i,
                        arrays: touchPaths
                    ),
                    timeElapsedSinceLastTouchDelivery: delayBetweenEachEvent,
                    waitUntilAllTouchesAreDelivered: false,
                    expendable: expendable
                )
            }
            
            endCommand = MultiTouchCommand.End(
                points: try objects(
                    index: firstTouchPathSize - 1,
                    arrays: touchPaths
                ),
                timeElapsedSinceLastTouchDelivery: 0
            )
        }
        
        let command = MultiTouchCommand(
            beginCommand: beginCommand,
            continueCommands: continueCommands,
            endCommand: endCommand
        )
        
        multiTouchCommandExecutor.execute(command: command)
    }
    
    private func objects<T>(index: Int, arrays: [[T]]) throws -> [T] {
        guard let firstArray = arrays.first else {
            throw ErrorString("arrayOfArrays must contain at least one element.")
        }
        
        let firstArraySize = firstArray.count
        
        guard index < firstArraySize else {
            throw ErrorString("index must be smaller than the size of the arrays.")
        }
        
        return try arrays.map { (array: [T]) throws -> T in
            guard array.count == firstArraySize else {
                throw ErrorString("All arrays must be of the same size.")
            }
            return array[index]
        }
    }
}
