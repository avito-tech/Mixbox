// Translated from Objective-C to Swift.
// Source: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Event/GREYTouchInjector.m
// Note: It was heavily changed since then.
// TODO: Write to EarlGrey developers that they may fix bugs and remove error-prone code with WebView
//       by using our method (replacing magic with mixed UIKit/IOKit with pure IOKit).

import QuartzCore
import MixboxFoundation
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIoKit

// TODO: Split (e.g. queueing, using timer source for injection)
public final class TouchInjectorImpl: TouchInjector {
    
    private enum State {
        // Touch injection hasn't started yet.
        case pendingStart
        
        // Injection has started injecting touches
        case started
        
        // Touch injection has stopped. This state is reached when injector has
        // finished injecting all the queued touches.
        case stopped
    }
    
    public final class Constants {
        static var injectionFrequency: TimeInterval { 60 }
        static var timeIntervalBetweenEachTouchInjection: TimeInterval { 1 / injectionFrequency }
    }
    
    // MARK: - Dependencies
    
    private let currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    private let multiTouchEventFactory: MultiTouchEventFactory
    
    // MARK: - State
    
    private var enqueuedMultiTouchInfoList = [EnqueuedMultiTouchInfo]()
    private var timerForInjectingTouches: ScheduledZeroToleranceTimer?
    private var previousTouchDeliveryTime: CFTimeInterval = 0
    private var state: State = .pendingStart
    
    // The previously injected touch event. Used to determine whether
    // an injected touch needs to be stationary or not.
    // Touches can be "expandable", so there is no way to determine if touch is stationary
    // for an enqueued touch.
    private var previousDequeuedMultiTouchInfo: DequeuedMultiTouchInfo?
    
    public init(
        currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory,
        multiTouchEventFactory: MultiTouchEventFactory)
    {
        self.currentAbsoluteTimeProvider = currentAbsoluteTimeProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
        self.multiTouchEventFactory = multiTouchEventFactory
    }
    
    public func enqueue(enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo) {
        assertIsOnMainThread()
        enqueuedMultiTouchInfoList.append(enqueuedMultiTouchInfo)
    }
    
    public func startInjectionIfNecessary() {
        assertIsOnMainThread()
        
        switch state {
        case .pendingStart, .stopped:
            startInjecting()
        case .started:
            break
        }
    }
    
    public func waitForInjectionToFinish() {
        assertIsOnMainThread()
        
        let runLoopSpinner = runLoopSpinnerFactory.runLoopSpinner(
            timeout: TimeInterval.greatestFiniteMagnitude,
            minRunLoopDrains: 0,
            maxSleepInterval: TimeInterval.greatestFiniteMagnitude
        )
        
        _ = runLoopSpinner.spinUntil { [weak self] in
            guard let strongSelf = self else {
                return true
            }
            
            return strongSelf.state == .stopped
        }
    }
    
    private func startInjecting() {
        assertIsOnMainThread()
        
        guard state != .started else {
            return
        }
        
        state = .started
        
        if timerForInjectingTouches == nil {
            timerForInjectingTouches = ZeroToleranceTimerSchedulerImpl().schedule(
                interval: Constants.timeIntervalBetweenEachTouchInjection,
                target: ZeroToleranceTimerTarget { [weak self] in
                    self?.handleZeroToleranceTimerFired()
                }
            )
        }
    }
    
    private func handleZeroToleranceTimerFired() {
        assertIsOnMainThread()
    
        let dequeuedMultiTouchInfoOrNil = dequeueMultiTouchInfoForDeliveryWithCurrentTime(
            currentMediaTime: CACurrentMediaTime()
        )
        
        if let dequeuedMultiTouchInfo = dequeuedMultiTouchInfoOrNil {
            injectTouches(dequeuedMultiTouchInfo: dequeuedMultiTouchInfo)
        } else {
            if enqueuedMultiTouchInfoList.isEmpty {
                // Queue is empty - we are done delivering touches.
                stopTouchInjection()
            }
        }
    }
    
    private func dequeueMultiTouchInfoForDeliveryWithCurrentTime(
        currentMediaTime: TimeInterval)
        -> DequeuedMultiTouchInfo?
    {
        guard !enqueuedMultiTouchInfoList.isEmpty else {
            return nil
        }
        
        // Count the number of stale touches.
        var staleTouches = 0
        var simulatedPreviousDeliveryTime = previousTouchDeliveryTime
        for enqueuedMultiTouchInfo in enqueuedMultiTouchInfoList {
            simulatedPreviousDeliveryTime += enqueuedMultiTouchInfo.deliveryTimeDeltaSinceLastTouch
            if enqueuedMultiTouchInfo.isExpendable && simulatedPreviousDeliveryTime < currentMediaTime {
                staleTouches += 1
            } else {
                break
            }
        }
        
        // Remove all but the last stale touch if any.
        let touchesToRemove: Int = (staleTouches > 1) ? (staleTouches - 1) : 0
        if let subRange = Range(NSRange(location: 0, length: touchesToRemove)) { enqueuedMultiTouchInfoList.removeSubrange(subRange) }
        
        guard let multiTouchInfoToDequeue = enqueuedMultiTouchInfoList.first else {
            // TODO: Check this. This branch was not in EarlGrey.
            return nil
        }
        
        let expectedTouchDeliveryTime = multiTouchInfoToDequeue.deliveryTimeDeltaSinceLastTouch + previousTouchDeliveryTime
        if expectedTouchDeliveryTime > currentMediaTime {
            // This touch is scheduled to be delivered in the future.
            return nil
        } else {
            enqueuedMultiTouchInfoList.remove(at: 0)
            return convertToDequeuedMultiTouchInfo(enqueuedMultiTouchInfo: multiTouchInfoToDequeue)
        }
    }
    
    private func convertToDequeuedMultiTouchInfo(
        enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo)
        -> DequeuedMultiTouchInfo
    {
        return DequeuedMultiTouchInfo(
            touchesByFinger: enqueuedMultiTouchInfo.touchesByFinger.enumerated().map { fingerIndex, touchInfo in
                DequeuedMultiTouchInfo.TouchInfo(
                    point: touchInfo.point,
                    phase: dequeuedTouchPhaseBasedOnState(
                        enqueuedMultiTouchInfo: enqueuedMultiTouchInfo,
                        fingerIndex: fingerIndex
                    )
                )
            }
        )
    }
    
    private func dequeuedTouchPhaseBasedOnState(
        enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo,
        fingerIndex: Int)
        -> DequeuedMultiTouchInfo.TouchInfo.Phase
    {
        let enqueuedTouch = enqueuedMultiTouchInfo.touchesByFinger[fingerIndex]
        
        switch enqueuedTouch.phase {
        case .began:
            return .began
        case .moved:
            if let previousDequeuedMultiTouchInfo = previousDequeuedMultiTouchInfo {
                if previousDequeuedMultiTouchInfo.touchesByFinger[fingerIndex].point == enqueuedTouch.point {
                    return .stationary
                } else {
                    return .moved
                }
            } else {
                return .moved
            }
        case .ended:
            return .ended
        }
    }
    
    private func stopTouchInjection() {
        state = .stopped
        timerForInjectingTouches?.invalidate()
        timerForInjectingTouches = nil
        enqueuedMultiTouchInfoList = []
    }
    
    private func injectTouches(dequeuedMultiTouchInfo: DequeuedMultiTouchInfo) {
        // iOS adds an autorelease pool around every event-based interaction.
        // We should mimic that if we want to relinquish bits in a timely manner.
        autoreleasepool {
            previousTouchDeliveryTime = CACurrentMediaTime()
            previousDequeuedMultiTouchInfo = dequeuedMultiTouchInfo
            
            ObjectiveCExceptionCatcher.catch(
                try: { () -> () in
                    let currentAbsoluteTime = currentAbsoluteTimeProvider.currentAbsoluteTime()
                    let event = multiTouchEventFactory.multiTouchEvent(
                        dequeuedMultiTouchInfo: dequeuedMultiTouchInfo,
                        time: currentAbsoluteTime
                    )
                    // TODO: Inject this
                    MBIohidEventSender().send(event.iohidEventRef, application: UIApplication.shared)
                }, catch: { (exception: NSException) -> () in
                    stopTouchInjection()
                    exception.raise() // TODO: Fail test instead of raising Objective-C exception
                }
            )
        }
    }
}
