import MixboxArtifacts

public protocol InteractionResultMaker {
    func decorateFailure(
        interactionFailure: InteractionFailure)
        -> InteractionResult
}

extension InteractionResultMaker {
    public func failure(
        message: String,
        attachments: [Artifact] = [])
        -> InteractionResult
    {
        return decorateFailure(
            interactionFailure: InteractionFailure(
                message: message,
                attachments: attachments,
                nestedFailures: []
            )
        )
    }
}
