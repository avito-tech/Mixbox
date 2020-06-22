import MixboxUiTestsFoundation
import Foundation
import UIKit

public final class MultiTouchCommandExecutorImpl: MultiTouchCommandExecutor {
    private let touchInjectorFactory: TouchInjectorFactory
    
    public init(
        touchInjectorFactory: TouchInjectorFactory)
    {
        self.touchInjectorFactory = touchInjectorFactory
    }
    
    public func execute(command: MultiTouchCommand) {
        let touchInjector = touchInjectorFactory.touchInjector()
        
        beginTouches(
            pointsByFinger: command.beginCommand.pointsByFinger,
            touchInjector: touchInjector
        )
        
        command.continueCommands.forEach { command in
            continueTouches(
                touchInjector: touchInjector,
                pointsByFinger: command.pointsByFinger,
                timeElapsedSinceLastTouchDelivery: command.timeElapsedSinceLastTouchDelivery,
                isExpendable: command.isExpendable
            )
        }
        
        endTouches(
            touchInjector: touchInjector,
            pointsByFinger: command.endCommand.pointsByFinger,
            timeElapsedSinceLastTouchDelivery: command.endCommand.timeElapsedSinceLastTouchDelivery
        )
    }
    
    private func beginTouches(
        pointsByFinger: [CGPoint],
        touchInjector: TouchInjector)
    {
        touchInjector.enqueue(
            enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo(
                touchesByFinger: pointsByFinger.map { point in
                    EnqueuedMultiTouchInfo.TouchInfo(
                        point: point,
                        phase: .began
                    )
                },
                deliveryTimeDeltaSinceLastTouch: 0,
                isExpendable: false
            )
        )
    }

    private func continueTouches(
        touchInjector: TouchInjector,
        pointsByFinger: [CGPoint],
        timeElapsedSinceLastTouchDelivery: TimeInterval,
        isExpendable: Bool)
    {
        touchInjector.enqueue(
            enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo(
                touchesByFinger: pointsByFinger.map { point in
                    EnqueuedMultiTouchInfo.TouchInfo(
                        point: point,
                        phase: .moved
                    )
                },
                deliveryTimeDeltaSinceLastTouch: timeElapsedSinceLastTouchDelivery,
                isExpendable: isExpendable
            )
        )
    }
    
    private func endTouches(
        touchInjector: TouchInjector,
        pointsByFinger: [CGPoint],
        timeElapsedSinceLastTouchDelivery: TimeInterval)
    {
        touchInjector.enqueue(
            enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo(
                touchesByFinger: pointsByFinger.map { point in
                    EnqueuedMultiTouchInfo.TouchInfo(
                        point: point,
                        phase: .ended
                    )
                },
                deliveryTimeDeltaSinceLastTouch: timeElapsedSinceLastTouchDelivery,
                isExpendable: false
            )
        )
        
        touchInjector.startInjectionIfNecessary()
        touchInjector.waitForInjectionToFinish()
    }
}
