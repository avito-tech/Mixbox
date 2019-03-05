import MixboxTestsFoundation
import MixboxFoundation

// Настройки взаимодействия (действия, проверки) с примененными настройками элемента.
// Настройки элемента менее приоритетны. На 27.02.2018 они не пересекались, но могут пересекаться в будущем.
public final class ResolvedInteractionSettings {
    public let interactionSettings: InteractionSettings
    public let elementSettings: ElementSettings
    public let pollingConfiguration: PollingConfiguration // TODO: Remove from here!
    
    public var elementName: String {
        return elementSettings.name
    }
    
    public var shouldAutoScroll: Bool {
        return elementSettings.searchMode == .scrollUntilFound
    }
    
    public var fileLineWhereExecuted: FileLine {
        return interactionSettings.fileLineWhereExecuted
    }
    
    public var interactionName: String {
        return interactionSettings.descriptionBuilder.buildFunction(
            HumanReadableInteractionDescriptionBuilderSource(
                elementName: elementSettings.name
            )
        )
    }
    
    public init(
        interactionSettings: InteractionSettings,
        elementSettings: ElementSettings,
        pollingConfiguration: PollingConfiguration)
    {
        self.interactionSettings = interactionSettings
        self.elementSettings = elementSettings
        self.pollingConfiguration = pollingConfiguration
    }
}
