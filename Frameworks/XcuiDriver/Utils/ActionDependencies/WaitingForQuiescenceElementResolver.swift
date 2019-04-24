import MixboxUiTestsFoundation

public final class WaitingForQuiescenceElementResolver: ElementResolver {
    private let elementResolver: ElementResolver
    private let applicationProvider: ApplicationProvider
    
    public init(
        elementResolver: ElementResolver,
        applicationProvider: ApplicationProvider)
    {
        self.elementResolver = elementResolver
        self.applicationProvider = applicationProvider
    }
    
    public func resolveElement() -> ResolvedElementQuery {
        // The following line is crucial. Without it snapshots can be reloaded
        // during the animation, and taps will miss their targets.
        //
        // NOTE: It only produced bugs with "com.apple.springboard" app,
        // maybe with other third-party apps too. Maybe I am wrong and it is also
        // helpful for the main app. Otherwise we should move _waitForQuiescence to
        // the place where it is needed, because it is quite slow.
        //
        // TODO: Write tests to check that?
        //
        // UPD: The logic moved from ScrollingContext to share ScrollingContext
        // in GrayBox/BlackBox tests. This is kind of a kludge by itself (not mentioning
        // that the following line is also a kludge).
        applicationProvider.application._waitForQuiescence()
        
        return elementResolver.resolveElement()
    }
}
