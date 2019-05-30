import MixboxUiTestsFoundation

protocol InteractionRecorder: class {
    func recordInteraction(description: String, interaction: () -> InteractionResult)
}
