import MixboxFoundation

public protocol PageObjectElementInteractionPerformer: class, ElementInteractionPerformer {
    func with(
        settings: ElementSettings)
        -> PageObjectElementInteractionPerformer
}
