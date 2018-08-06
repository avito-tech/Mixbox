import MixboxUiTestsFoundation

protocol InteractionRecorder {
    func recordInteraction(description: String, interaction: () -> InteractionResult)
}
