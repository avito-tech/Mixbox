// Translated from Objective-C to Swift.
// Source: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Event/GREYTouchInjector.m

import QuartzCore
import MixboxFoundation
import MixboxUiTestsFoundation
import MixboxTestsFoundation

// TODO: Split. swiftlint:disable type_body_length file_length
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
        static let injectionFrequency: TimeInterval = 60
        
        /**
         *  Maximum time to wait for UIWebView delegates to get called after the
         *  last touch (i.e. @c isLastTouch is @c YES).
         */
        static let maxIntervalForWebViewResponse: TimeInterval = 2
        
        /**
         *  The time interval in seconds between each touch injection.
         */
        static let injectionInterval: TimeInterval = 1 / injectionFrequency
    }
    
    // MARK: - Constants
    
    // Window to which touches will be delivered.
    private let window: UIWindow
    
    // MARK: - Variables
    
    // List of objects that aid in creation of UITouches.
    private var enqueuedTouchInfoList = [TouchInfo]()
    
    // A timer used for injecting touches.
    private var timer: ScheduledZeroToleranceTimer?
    
    // Touch objects created to start the touch sequence for every
    // touch points. It stores one UITouch object for each finger
    // in a touch event.
    private var ongoingTouches: [UITouch] = []
    
    // Time at which previous touch event was delivered.
    private var previousTouchDeliveryTime: CFTimeInterval = 0
    
    // Current state of the injector.
    private var state: State = .pendingStart
    
    // The previously injected touch event. Used to determine
    // whether an injected touch needs to be stationary or not.
    // May be nil.
    private var previousTouchInfo: TouchInfo?
    
    private let currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(
        window: UIWindow,
        currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory)
    {
        self.window = window
        self.currentAbsoluteTimeProvider = currentAbsoluteTimeProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    public func enqueueForDelivery(touchInfo: TouchInfo) {
        assertIsOnMainThread()
        enqueuedTouchInfoList.append(touchInfo)
    }
    
    public func waitUntilAllTouchesAreDeliveredUsingInjector() {
        assertIsOnMainThread()
        
        // Start if necessary.
        switch state {
        case .pendingStart, .stopped:
            startInjecting()
        case .started:
            break
        }
        
        // Now wait for it to finish.
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
        
        if timer == nil {
            timer = ZeroToleranceTimerSchedulerImpl().schedule(
                interval: Constants.injectionInterval,
                target: ZeroToleranceTimerTarget { [weak self] in
                    self?.handleZeroToleranceTimerFired()
                }
            )
        }
    }
    
    private func handleZeroToleranceTimerFired() {
        assertIsOnMainThread()
    
        let touchInfoOrNil = dequeueTouchInfoForDeliveryWithCurrentTime(
            currentMediaTime: CACurrentMediaTime()
        )
        
        if let touchInfo = touchInfoOrNil {
            if ongoingTouches.isEmpty {
                extractAndChangeTouchToStartPhase(touchInfo: touchInfo)
            } else if touchInfo.phase == .ended {
                changeTouchToEndPhase(touchInfo: touchInfo)
            } else {
                changeTouchToMovePhase(touchInfo: touchInfo)
            }
            
            injectTouches(touchInfo: touchInfo)
        } else {
            if enqueuedTouchInfoList.isEmpty {
                // Queue is empty - we are done delivering touches.
                stopTouchInjection()
            }
        }
    }
    
    private func dequeueTouchInfoForDeliveryWithCurrentTime(
        currentMediaTime: TimeInterval)
        -> TouchInfo?
    {
        guard !enqueuedTouchInfoList.isEmpty else {
            return nil
        }
        
        // Count the number of stale touches.
        var staleTouches = 0
        var simulatedPreviousDeliveryTime = previousTouchDeliveryTime
        for touchInfo in enqueuedTouchInfoList {
            simulatedPreviousDeliveryTime += touchInfo.deliveryTimeDeltaSinceLastTouch
            if touchInfo.expendable && simulatedPreviousDeliveryTime < currentMediaTime {
                staleTouches += 1
            } else {
                break
            }
        }
        
        // Remove all but the last stale touch if any.
        let touchesToRemove: Int = (staleTouches > 1) ? (staleTouches - 1) : 0
        if let subRange = Range(NSRange(location: 0, length: touchesToRemove)) { enqueuedTouchInfoList.removeSubrange(subRange) }
        
        guard let dequeuedTouchInfo = enqueuedTouchInfoList.first else {
            // TODO: Check this. This branch was not in EarlGrey.
            return nil
        }
        
        let expectedTouchDeliveryTime = dequeuedTouchInfo.deliveryTimeDeltaSinceLastTouch + previousTouchDeliveryTime
        if expectedTouchDeliveryTime > currentMediaTime {
            // This touch is scheduled to be delivered in the future.
            return nil
        } else {
            enqueuedTouchInfoList.remove(at: 0)
            return dequeuedTouchInfo
        }
    }
    
    private func stopTouchInjection() {
        state = .stopped
        timer?.invalidate()
        timer = nil
        enqueuedTouchInfoList = []
    }
    
    private func extractAndChangeTouchToStartPhase(touchInfo: TouchInfo) {
        ongoingTouches.append(
            contentsOf: touchInfo.points.map { point in
                let touch = uiTouch(
                    point: point,
                    relativeToWindow: window
                )
                touch.setPhase(UITouch.Phase.began)
                return touch
            }
        )
    }
    
    private func changeTouchToEndPhase(touchInfo: TouchInfo) {
        guard let previousTouchInfo = previousTouchInfo else {
            // TODO: Rewrite the code so it will never happen.
            // It can be completely removed with proper interfaces.
            // Because this function is called only if there are begin/moved events.
            assertionFailure("previousTouchInfo is nil, which is unexpected")
            return
        }
        
        for i in 0..<touchInfo.points.count {
            let touch = uiTouchForFinger(index: i)
            let touchPoint: CGPoint = previousTouchInfo.points[i]
            touch._setLocation(inWindow: touchPoint, resetPrevious: false)
            touch.setPhase(UITouch.Phase.ended)
        }
    }
    
    private func changeTouchToMovePhase(touchInfo: TouchInfo) {
        guard let previousTouchInfo = previousTouchInfo else {
            // TODO: Rewrite the code so it will never happen.
            // It can be completely removed with proper interfaces.
            // Because this function is called only if there are begin events.
            assertionFailure("previousTouchInfo is nil, which is unexpected")
            return
        }
        
        touchInfo.points.enumerated().forEach { i, touchPoint in
            let touch = uiTouchForFinger(index: i)
            touch._setLocation(inWindow: touchPoint, resetPrevious: false)
            let previousTouchPoint: CGPoint = previousTouchInfo.points[i]
            if previousTouchPoint.equalTo(touchPoint) {
                touch.setPhase(UITouch.Phase.stationary)
            } else {
                touch.setPhase(UITouch.Phase.moved)
            }
        }
    }
    
    // TODO: Fix linting
    // swiftlint:disable:next function_body_length
    private func injectTouches(touchInfo: TouchInfo) {
        guard let event: UITouchesEvent = UIApplication.shared._touchesEvent() else {
            assertionFailure("UIApplication.shared._touchesEvent() is nil")
            return
        }
        
        // Clean up before injecting touches.
        event._clearTouches()
        
        let currentAbsoluteTime = currentAbsoluteTimeProvider.currentAbsoluteTime
        
        // See commented out usage of `currentTouchView` in this file below
        // var currentTouchView: UIView? = ongoingTouches.first?.view
        
        // TODO: Check `hidEvents` are not released before `finally` closure ends
        // TODO: Remove modification of state from map.
        let hidEvents: [IOHIDEventRef] = ongoingTouches.enumerated().map { index, currentTouch in
            currentTouch.setTimestamp(ProcessInfo.processInfo.systemUptime)
            
            let eventMask: IOHIDDigitizerEventMask
                
            switch currentTouch.phase {
            case .moved:
                eventMask = kIOHIDDigitizerEventPosition
            default:
                eventMask = IOHIDDigitizerEventMask(
                    rawValue: kIOHIDDigitizerEventRange.rawValue | kIOHIDDigitizerEventTouch.rawValue
                )
            }
            
            let touchLocation: CGPoint = currentTouch.location(in: currentTouch.window)
            
            // Both range and touch are set to 0 if phase is UITouchPhaseEnded, 1 otherwise.
            let isRangeAndTouch: Bool = currentTouch.phase != .ended
            let hidEvent = createDigitizerFingerEvent(
                allocator: kCFAllocatorDefault,
                timeStamp: currentAbsoluteTime,
                index: 0,
                identity: 2,
                eventMask: eventMask,
                x: IOHIDFloat(touchLocation.x),
                y: IOHIDFloat(touchLocation.y),
                z: 0,
                tipPressure: 0,
                twist: 0,
                range: isRangeAndTouch,
                touch: isRangeAndTouch,
                options: 0
            )
            
            // TODO: Why it is needed?
            if currentTouch.responds(to: #selector(UITouch._setHidEvent(_:))) {
                currentTouch._setHidEvent(hidEvent)
            }
            
            return hidEvent
        }
        
        ongoingTouches.forEach { currentTouch in
            event._add(currentTouch, forDelayedDelivery: false)
        }
        
        event._setHIDEvent(hidEvents[0])
        
        // iOS adds an autorelease pool around every event-based interaction.
        // We should mimic that if we want to relinquish bits in a timely manner.
        
        autoreleasepool {
            previousTouchDeliveryTime = CACurrentMediaTime()
            previousTouchInfo = touchInfo
            
            let touchViewContainsWKWebView = false
            
            ObjectiveCExceptionCatcher.catch(
                try: { () -> () in
                    UIApplication.shared.sendEvent(event)
                    
                    // TODO: Implement this magic with WebView
                    /*
                    if let currentTouchView = currentTouchView {
                        // If a WKWebView is being tapped, don't call [event _clearTouches], as this causes long
                        // presses to fail. For this case, the child of |currentTouchView| is a WKCompositingView.
                        
                        if let firstChild = currentTouchView.subviews.first,
                            let wkCompositingViewClass = NSClassFromString("WKCompositingView")
                        {
                            if firstChild.isKind(of: wkCompositingViewClass) {
                                touchViewContainsWKWebView = true
                            }
                        }
                        
                        if touchInfo.phase == .ended {
                            var touchWebView: UIWebView? = nil
                            if (currentTouchView is UIWebView) {
                                touchWebView = currentTouchView as? UIWebView
                            } else {
                                let webViewContainers = currentTouchView.grey_containersAssignable(fromClass: UIWebView.self)
                                if webViewContainers.count > 0 {
                                    touchWebView = webViewContainers.first as? UIWebView
                                }
                            }
                            touchWebView?.grey_pendingInteraction(
                                forTime: Constants.maxIntervalForWebViewResponse
                            )
                        }
                    }
                    */
                }, catch: { (exception: NSException) -> () in
                    stopTouchInjection()
                    exception.raise() // TODO: Fail test instead of raising Objective-C exception
                }, finally: {
                    // Clear all touches so that it is not leaked, except for WKWebViews, where these calls
                    // can prevent the app tracker from becoming idle.
                    if !touchViewContainsWKWebView {
                        event._clearTouches()
                    }
                    
                    // TODO: Check that there is no leaks. Original code:
                    // // We need to release the event manually, otherwise it will leak.
                    // for hidEventValue in hidEvents {
                    //     let hidEvent = hidEventValue.pointerValue as? IOHIDEventRef
                    // }
                    
                    if touchInfo.phase == .ended {
                        ongoingTouches = []
                    }
                }
            )
        }
    }

    // Helper method to return UITouch object at @c index from the @c ongoingTouches array.
    // TODO: Remove. Maybe replace with proper interface that emphasizes the "finger" thing.
    //       E.g. name the struct some "multitouch" thing
    private func uiTouchForFinger(index: Int) -> UITouch {
        return ongoingTouches[index] // TODO: Fix possible crash (e.g. with compile-time check)
    }
    
    private func uiTouch(
        point: CGPoint,
        relativeToWindow window: UIWindow)
        -> UITouch
    {
        let pointAfterRemovingFractionalPixels = self.pointAfterRemovingFractionalPixels(
            cgPointInPoints: point
        )
        
        let touch = UITouch()
        
        touch.setTapCount(1)
        touch.setIsTap(true)
        touch.setPhase(.began)
        touch.setWindow(window)
        touch._setLocation(inWindow: pointAfterRemovingFractionalPixels, resetPrevious: true)
        touch.setView(window.hitTest(pointAfterRemovingFractionalPixels, with: nil))
        touch._setIsFirstTouch(forView: true)
        touch.setTimestamp(ProcessInfo.processInfo.systemUptime)
        
        return touch
    }

    // TODO: Remove? Understand, add docs and write tests?
    // The logic is very complex, there is no real examples of how it works and why it is needed.
    // Also the logic seems like reinvented round() function.
    // TODO: Try to remove or simplify after Gray Box tests will be implemented.
    private func pointAfterRemovingFractionalPixels(cgPointInPoints: CGPoint) -> CGPoint {
        return CGPoint(
            x: floatAfterRemovingFractionalPixels(floatInPoints: cgPointInPoints.x),
            y: floatAfterRemovingFractionalPixels(floatInPoints: cgPointInPoints.y)
        )
    }
    
    /**
     *  @todo Update this for touch events on iPhone 6 Plus where it does not produce the intended
     *        result because the touch grid is the same as the native screen resolution of 1080x1920,
     *        while UI rendering is done at 1242x2208, and downsampled to 1080x1920.
     */
    private func floatAfterRemovingFractionalPixels(floatInPoints: CGFloat) -> CGFloat {
        let pointToPixelScale = Double(UIScreen.main.scale)
        
        // Fractional pixel values aren't useful and often arise due to floating point calculation
        // overflow (i.e. mantissa can only hold so many digits).
        var wholePixel: Double = 0
        var fractionPixel = modf(Double(floatInPoints) * pointToPixelScale, &wholePixel)
        if fractionPixel.isLessOrGreater(than: 0) {
            switch fractionPixel.sign {
            case .minus:
                fractionPixel = fractionPixel < -0.5 ? -1.0 : 0
            case .plus:
                fractionPixel = fractionPixel > 0.5 ? 1 : 0
            }
        }
        wholePixel = (wholePixel + fractionPixel) / pointToPixelScale
        return CGFloat(wholePixel)
    }
    
    // swiftlint:disable:next function_parameter_count
    private func createDigitizerFingerEvent(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        index: UInt32,
        identity: UInt32,
        eventMask: IOHIDDigitizerEventMask,
        x: IOHIDFloat,
        y: IOHIDFloat,
        z: IOHIDFloat,
        tipPressure: IOHIDFloat,
        twist: IOHIDFloat,
        range: Bool,
        touch: Bool,
        options: IOOptionBits)
        -> IOHIDEventRef
    {
        return IOHIDEventCreateDigitizerFingerEvent(
            allocator,
            timeStamp.cAbsoluteTime,
            index,
            identity,
            eventMask,
            x,
            y,
            z,
            tipPressure,
            twist,
            range,
            touch,
            options
        )
    }
}

private extension Double {
    // Works (I hope) as described here:
    // https://en.cppreference.com/w/cpp/numeric/math/islessgreater
    // > Determines if the floating point number x is less than or greater than the floating-point number y, without setting floating-point exceptions.
    // TODO: Test according to specification
    func isLessOrGreater(than other: Double) -> Bool {
        return self.isLess(than: other) || other.isLess(than: self)
    }
}
