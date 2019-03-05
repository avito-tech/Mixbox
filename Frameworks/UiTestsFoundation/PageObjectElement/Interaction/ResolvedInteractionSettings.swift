import MixboxTestsFoundation
import MixboxFoundation

// Настройки взаимодействия (действия, проверки) с примененными настройками элемента.
// Настройки элемента менее приоритетны (замещаются настройками взаимодействия).
// На 05.03.2019 они не пересекались, но могут пересекаться в будущем и нужно учесь описанные выше приоритеты.
public final class ResolvedInteractionSettings {
    public let interactionSettings: InteractionSettings
    public let elementSettings: ElementSettings
    
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
        elementSettings: ElementSettings)
    {
        self.interactionSettings = interactionSettings
        self.elementSettings = elementSettings
    }
}
