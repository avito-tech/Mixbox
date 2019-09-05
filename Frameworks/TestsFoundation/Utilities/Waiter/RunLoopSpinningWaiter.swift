// Same as waiter, but guarantees spinning run loop.
// However, I can not imagine a reason to not spin run loop inside Mixbox framework,
// because most of the code can be used for GreyBox testing and tests are run in main thread,
// so they require to spin main thread to make UI work in tests.
public protocol RunLoopSpinningWaiter: Waiter {}
