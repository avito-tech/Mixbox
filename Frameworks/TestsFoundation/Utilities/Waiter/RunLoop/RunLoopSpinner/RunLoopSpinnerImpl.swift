public final class RunLoopSpinnerImpl: RunLoopSpinner {
    private var spinning: Bool
    
    private let timeout: TimeInterval
    
    // The minimum number of times that the run loop should be drained in the active mode before
    // checking the stop condition.
    private let minRunLoopDrains: Int
    
    // The maximum time in seconds that the current thread will be allowed to sleep while running in
    // the active mode that we started spinning.
    // Not allowing the run loop to sleep can be useful for some test scenarios but causes the
    // thread to use significantly more CPU.
    private let maxSleepInterval: TimeInterval
    
    // This block is invoked in the active run loop mode if the stop condition evaluates to YES.
    private let conditionMetHandler: () -> ()
    
    private let runLoopModesStackProvider: RunLoopModesStackProvider
    
    public init(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval,
        runLoopModesStackProvider: RunLoopModesStackProvider,
        conditionMetHandler: @escaping () -> ())
    {
        self.timeout = timeout
        self.minRunLoopDrains = minRunLoopDrains
        self.maxSleepInterval = maxSleepInterval
        self.conditionMetHandler = conditionMetHandler
        self.runLoopModesStackProvider = runLoopModesStackProvider
        self.spinning = false
    }
    
    // TODO: Is it possible to get rid of `@escaping` attribute?
    public func spinUntil(
        stopCondition: @escaping () -> Bool)
        -> SpinUntilResult
    {
        // TODO: Compile-time check + remove state
        assert(!spinning, "Should not spin the same run loop spinner instance concurrently.")
        
        spinning = true
        let timeoutTime: CFTimeInterval = CACurrentMediaTime() + timeout
        drainRunLoopInActiveMode(exitDrainCount: minRunLoopDrains)
        
        var stopConditionWasCalledAtLeastOnce = false
        
        let overridenStopCondition: () -> Bool = {
            let result = stopCondition()
            stopConditionWasCalledAtLeastOnce = true
            return result
        }
        
        var stopConditionMet = checkCondition(inActiveMode: overridenStopCondition)
        var remainingTime = seconds(untilTime: timeoutTime)
        
        while (!stopConditionMet && remainingTime > 0) || !stopConditionWasCalledAtLeastOnce {
            autoreleasepool {
                stopConditionMet = drainRunLoop(
                    inActiveModeAndCheckCondition: overridenStopCondition,
                    forTime: remainingTime
                )
                remainingTime = seconds(untilTime: timeoutTime)
            }
        }
        
        spinning = false
        
        return stopConditionMet
            ? .stopConditionMet
            : .timedOut
    }
    
    private func drainRunLoopInActiveMode(exitDrainCount: Int) {
        if exitDrainCount == 0 {
            return
        }
        
        var drainCount = 0
        
        let drainCountingBlock = {
            drainCount += 1
            if drainCount >= exitDrainCount {
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        
        let wakeUpBlock = {
            // Never let the run loop sleep while we are draining it for the minimum drains.
            CFRunLoopWakeUp(CFRunLoopGetCurrent())
        }
        
        while drainCount < exitDrainCount {
            autoreleasepool {
                let activeMode = activeRunLoopMode()
                let drainCountingObserver = setupObserver(
                    inMode: activeMode,
                    withBeforeSourcesBlock: drainCountingBlock,
                    beforeWaitingBlock: wakeUpBlock
                )
                
                let result: CFRunLoopRunResult = CFRunLoopRunInMode(
                    activeMode,
                    Double.greatestFiniteMagnitude,
                    false
                )
                if result == .finished {
                    // Running a run loop mode will finish if that mode has no sources or timers. In that case,
                    // the observer callbacks will not get called, so we need to increment the drain count here.
                    drainCount += 1
                }
                teardownObserver(drainCountingObserver, inMode: activeMode)
            }
        }
    }
    
    private func checkCondition(inActiveMode stopConditionBlock: @escaping () -> Bool) -> Bool {
        var conditionMet = false
        weak var weakSelf = self
        
        let activeMode = activeRunLoopMode()
        let block = {
            guard let strongSelf = weakSelf else  {
                assertionFailure("The spinner should not have been deallocated.")
                return
            }
            
            if stopConditionBlock() {
                strongSelf.conditionMetHandler()
                conditionMet = true
            }
        }
        
        CFRunLoopPerformBlock(
            CFRunLoopGetCurrent(),
            activeMode as CFTypeRef?,
            block
        )
        
        // Handles at most one souce in the active mode. All enqueued blocks are serviced before any
        // sources are serviced.
        CFRunLoopRunInMode(activeMode, 0, true)
        
        return conditionMet
    }
    
    /**
     *  @param time The point in time to measure against.
     *
     *  @return The time in seconds from now until @c time.
     */
    private func seconds(untilTime time: CFTimeInterval) -> CFTimeInterval {
        return time - CACurrentMediaTime()
    }
    
    /**
     *  @return The active mode for the current runloop.
     */
    private func activeRunLoopMode() -> CFRunLoopMode {
        if let activeRunLoopMode = runLoopModesStackProvider.activeRunLoopMode {
            return activeRunLoopMode
        } else {
            // If UIKit does not have any modes on its run loop stack, then consider the default
            // run loop mode as the active mode. We do not use the current run loop mode because if this
            // spinner is nested within another spinner, we could get stuck spinning the run loop in a
            // mode that was active but shouldn't be anymore.
            // TODO: Do better than just always using the default run loop mode.
            return CFRunLoopMode(rawValue: RunLoop.Mode.default.rawValue as CFString)
        }
    }

    private func setupObserver(
        inMode mode: CFRunLoopMode,
        withBeforeSourcesBlock beforeSourcesBlock: @escaping () -> Void,
        beforeWaitingBlock: @escaping () -> Void)
        -> CFRunLoopObserver?
    {
        var numNestedRunLoopModes = 0
        
        let observerBlock: ((_ observer: CFRunLoopObserver?, _ activity: CFRunLoopActivity) -> Void)? = { observer, activity in
            if activity.rawValue & CFRunLoopActivity.entry.rawValue != 0 {
                // When entering a run loop in @c mode, increment the nesting count.
                numNestedRunLoopModes += 1
            } else if activity.rawValue & CFRunLoopActivity.exit.rawValue != 0 {
                // When exiting a run loop in @c mode, decrement the nesting count.
                numNestedRunLoopModes -= 1
            } else if activity.rawValue & CFRunLoopActivity.beforeSources.rawValue != 0 {
                // When this observer was created, the nesting count was 0. When we started running the
                // run loop in @c mode, the run loop entered @c mode and incremented the nesting count. So
                // now, the "unnested" nesting count is 1.
                if numNestedRunLoopModes == 1 {
                    beforeSourcesBlock()
                }
            } else if activity.rawValue & CFRunLoopActivity.beforeWaiting.rawValue != 0 {
                if numNestedRunLoopModes == 1 {
                    beforeWaitingBlock()
                }
            } else {
                assertionFailure("Should not get here. Observer is not registered for any other options.")
            }
            assert(numNestedRunLoopModes >= 0, "The nesting count for |mode| should never be less than zero.")
        }
        
        let observerFlags = CFRunLoopActivity.entry.rawValue
            | CFRunLoopActivity.exit.rawValue
            | CFRunLoopActivity.beforeSources.rawValue
            | CFRunLoopActivity.beforeWaiting.rawValue
        
        // Order = LONG_MAX so it is serviced last after all other higher priority observers.
        // Let the other observers do their job before querying for idleness.
        let observer = CFRunLoopObserverCreateWithHandler(nil, observerFlags, true, LONG_MAX, observerBlock)
        
        CFRunLoopAddObserver(
            CFRunLoopGetCurrent(),
            observer,
            mode
        )
        
        return observer
    }
    
    /**
     *  Remove @c observer from @c mode and then release it.
     *
     *  @param observer The observer to be removed and released.
     *  @param mode     The mode from which the observer should be removed.
     */
    private func teardownObserver(_ observer: CFRunLoopObserver?, inMode mode: CFRunLoopMode) {
        CFRunLoopRemoveObserver(
            CFRunLoopGetCurrent(),
            observer,
            mode
        )
    }
    
    /**
     *  Remove @c timer from @c mode and then release it.
     *
     *  @param timer The time to be removed and released.
     *  @param mode  The mode from which the timer should be removed.
     */
    private func teardownTimer(_ timer: CFRunLoopTimer?, inMode mode: CFRunLoopMode) {
        CFRunLoopRemoveTimer(
            CFRunLoopGetCurrent(),
            timer,
            mode
        )
    }
    
    private func drainRunLoop(
        inActiveModeAndCheckCondition stopConditionBlock: @escaping () -> Bool,
        forTime time: CFTimeInterval)
        -> Bool
    {
        let activeMode = activeRunLoopMode()
        let wakeUpTimer = setupWakeUpTimer(inMode: activeMode)
        var conditionMet = false
        
        let beforeSourcesConditionCheckBlock = { [weak self] in
            guard let strongSelf = self else {
                assertionFailure("The spinner should not have been deallocated.")
                return
            }
            
            if stopConditionBlock() {
                strongSelf.conditionMetHandler()
                conditionMet = true
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        
        let beforeWaitingConditionCheckBlock = { [weak self] in
            guard let strongSelf = self else {
                assertionFailure("The spinner should not have been deallocated.")
                return
            }
            
            if strongSelf.maxSleepInterval == 0 {
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            }
            
            // This observer callback is not guaranteed to be called, but we must also check if we should
            // stop the run loop here because we do not want the run loop to go to sleep if we should stop
            // the run loop. A source handled in the last drain may have satisfied the stop condition.
            //
            // Do not check _stopConditionBlock if _stopConditionMet is already true. This will occur if we
            // stopped the run loop in the BeforeSources handler. In this case, we do not want to check the
            // stop condition again.
            if !conditionMet && stopConditionBlock() {
                strongSelf.conditionMetHandler()
                conditionMet = true
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        let conditionCheckingObserver = setupObserver(
            inMode: activeMode,
            withBeforeSourcesBlock: beforeSourcesConditionCheckBlock,
            beforeWaitingBlock: beforeWaitingConditionCheckBlock
        )
        
        let result: CFRunLoopRunResult = CFRunLoopRunInMode(
            activeMode,
            time,
            false
        )
        
        // Running a run loop mode will finish if that mode has no sources or timers. In that case,
        // the observer callbacks will not get called, so we need to check the condition here.
        if result == .finished {
            assert(
                !conditionMet,
                "If the running the active mode returned finished, the condition should not have been met."
            )
            conditionMet = checkCondition(inActiveMode: stopConditionBlock)
        }
        
        teardownObserver(conditionCheckingObserver, inMode: activeMode)
        teardownTimer(wakeUpTimer, inMode: activeMode)
        
        return conditionMet
    }
    
    private func setupWakeUpTimer(inMode mode: CFRunLoopMode) -> CFRunLoopTimer? {
        let noopTimerHandler: (CFRunLoopTimer?) -> () = { _ in }
        
        if maxSleepInterval > 0 {
            let timer = CFRunLoopTimerCreateWithHandler(
                kCFAllocatorDefault,
                CFAbsoluteTimeGetCurrent() + maxSleepInterval,
                maxSleepInterval,
                0,
                0,
                noopTimerHandler
            )
            
            CFRunLoopAddTimer(
                CFRunLoopGetCurrent(),
                timer,
                mode
            )
            
            return timer
        } else {
            return nil
        }
    }

}
