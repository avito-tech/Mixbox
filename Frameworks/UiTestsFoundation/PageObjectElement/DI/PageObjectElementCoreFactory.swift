// `PageObjectElementCoreFactory` used to provide same interface for making page objects
// regardless of used testing technology (blackbox testing or gray box testing).
//
// Implementations are very different, but all interfaces defined in this framework
// should be independent of testing technology.
//
// See: `PageObjectElementCore`

public protocol PageObjectElementCoreFactory: class {
    func pageObjectElementCore(
        settings: ElementSettings)
        -> PageObjectElementCore
}
