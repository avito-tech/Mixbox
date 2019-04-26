import MixboxUiTestsFoundation

public final class MultiTouchCommandExecutorImpl: MultiTouchCommandExecutor {
    private let touchInjectorFactory: TouchInjectorFactory
    
    public init(
        touchInjectorFactory: TouchInjectorFactory)
    {
        self.touchInjectorFactory = touchInjectorFactory
    }
    
    public func execute(command: MultiTouchCommand) {
        let touchInjector =  touchInjectorFactory.touchInjector(
            window: command.beginCommand.relativeToWindow
        )
        
        beginTouches(
            points: command.beginCommand.points,
            touchInjector: touchInjector,
            waitUntilAllTouchesAreDelivered: command.beginCommand.waitUntilAllTouchesAreDelivered
        )
        
        command.continueCommands.forEach { command in
            continueTouches(
                touchInjector: touchInjector,
                points: command.points,
                timeElapsedSinceLastTouchDelivery: command.timeElapsedSinceLastTouchDelivery,
                waitUntilAllTouchesAreDelivered: command.waitUntilAllTouchesAreDelivered,
                expendable: command.expendable
            )
        }
        
        endTouches(
            touchInjector: touchInjector,
            points: command.endCommand.points,
            timeElapsedSinceLastTouchDelivery: command.endCommand.timeElapsedSinceLastTouchDelivery
        )
    }
    
    private func beginTouches(
        points: [CGPoint],
        touchInjector: TouchInjector,
        waitUntilAllTouchesAreDelivered: Bool)
    {
        enqueue(
            touchInjector: touchInjector,
            touchInfo: TouchInfo(
                points: points,
                phase: .began,
                deliveryTimeDeltaSinceLastTouch: 0,
                expendable: false
            ),
            waitUntilAllTouchesAreDelivered: waitUntilAllTouchesAreDelivered
        )
    }

    private func continueTouches(
        touchInjector: TouchInjector,
        points: [CGPoint],
        timeElapsedSinceLastTouchDelivery: TimeInterval,
        waitUntilAllTouchesAreDelivered: Bool,
        expendable: Bool)
    {
        enqueue(
            touchInjector: touchInjector,
            touchInfo: TouchInfo(
                points: points,
                phase: .moved,
                deliveryTimeDeltaSinceLastTouch: timeElapsedSinceLastTouchDelivery,
                expendable: expendable
            ),
            waitUntilAllTouchesAreDelivered: waitUntilAllTouchesAreDelivered
        )
    }
    
    private func endTouches(
        touchInjector: TouchInjector,
        points: [CGPoint],
        timeElapsedSinceLastTouchDelivery: TimeInterval)
    {
        enqueue(
            touchInjector: touchInjector,
            touchInfo: TouchInfo(
                points: points,
                phase: .ended,
                deliveryTimeDeltaSinceLastTouch: timeElapsedSinceLastTouchDelivery,
                expendable: false
            ),
            waitUntilAllTouchesAreDelivered: true
        )
    }
    
    private func enqueue(
        touchInjector: TouchInjector,
        touchInfo: TouchInfo,
        waitUntilAllTouchesAreDelivered: Bool)
    {
        touchInjector.enqueueForDelivery(touchInfo: touchInfo)
        
        if waitUntilAllTouchesAreDelivered {
            touchInjector.waitUntilAllTouchesAreDeliveredUsingInjector()
        }
    }
}
