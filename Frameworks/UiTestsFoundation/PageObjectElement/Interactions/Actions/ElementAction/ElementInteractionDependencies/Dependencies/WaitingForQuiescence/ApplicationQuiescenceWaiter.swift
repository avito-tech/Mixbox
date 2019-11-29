// Waits until application stops changing UI, useful for performing actions with UI.
// Also spins runloop, so UI will be responsive during the waiting, it is required to finish animations, etc.
public protocol ApplicationQuiescenceWaiter {
    func waitForQuiescence<T>(body: () throws -> T) throws -> T
}
