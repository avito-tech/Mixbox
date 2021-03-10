import MixboxFoundation

public protocol PageObjectElementInteractionPerformer: ElementInteractionPerformer {
    func with(
        settings: ElementSettings)
        -> PageObjectElementInteractionPerformer
}
