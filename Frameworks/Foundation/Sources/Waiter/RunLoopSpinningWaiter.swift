#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Same as waiter, but guarantees spinning run loop.
// However, I can not imagine a reason to not spin run loop inside Mixbox framework,
// because most of the code can be used for GreyBox testing and tests are run in main thread,
// so they require to spin main thread to make UI work in tests.
public protocol RunLoopSpinningWaiter: Waiter {}

#endif
