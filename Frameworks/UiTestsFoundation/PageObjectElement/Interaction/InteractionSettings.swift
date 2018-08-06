import MixboxTestsFoundation
import MixboxFoundation

// Used for customization of actions and checks (interactions).
//
// PROPOSAL: Make interface for getting interactions without performing them.
// This can reduce boilerplate. Convenient functions for getting and performing interactions
// instantly will remain intact (in extensions), but implementation of interactions will be simpler,
// because all interactions have common parameters.

// ActionSettings and CheckSettings are separated intentionally,
// but now they are same. I don't know how it will be in the future.
public typealias ActionSettings = InteractionSettings
public typealias CheckSettings = InteractionSettings
public typealias UtilsSettings = InteractionSettings

public final class InteractionSettings {
    public let fileLineWhereExecuted: FileLine
    public let descriptionBuilder: HumanReadableInteractionDescriptionBuilder
    
    public init(
        fileLineWhereExecuted: FileLine,
        descriptionBuilder: HumanReadableInteractionDescriptionBuilder)
    {
        self.fileLineWhereExecuted = fileLineWhereExecuted
        self.descriptionBuilder = descriptionBuilder
    }
    
    // Немного экономит запись
    public convenience init(
        file: StaticString,
        line: UInt,
        description: HumanReadableInteractionDescriptionBuilder?,
        defaultDescription: @escaping HumanReadableInteractionDescriptionBuilder.BuildFunction)
    {
        self.init(
            fileLineWhereExecuted: FileLine(file: file, line: line),
            descriptionBuilder: description ?? HumanReadableInteractionDescriptionBuilder.function(defaultDescription)
        )
    }
}

// Usage:
//
//    description: .string("tap authorization button")
//    description: .function { info in "tap '\(info.elementName)'" }
//
public final class HumanReadableInteractionDescriptionBuilder {
    public typealias BuildFunction = (HumanReadableInteractionDescriptionBuilderSource) -> (String)
    
    public var buildFunction: BuildFunction
    
    public init(buildFunction: @escaping BuildFunction) {
        self.buildFunction = buildFunction
    }
    
    public static func string(_ constantString: String) -> HumanReadableInteractionDescriptionBuilder {
        return HumanReadableInteractionDescriptionBuilder(
            buildFunction: { _ in
                constantString
            }
        )
    }
    
    public static func function(_ buildFunction: @escaping BuildFunction) -> HumanReadableInteractionDescriptionBuilder {
        return HumanReadableInteractionDescriptionBuilder(
            buildFunction: buildFunction
        )
    }
 }

// Everything needed to build a perfect title for interaction.
public final class HumanReadableInteractionDescriptionBuilderSource {
    public let elementName: String
    
    public init(elementName: String) {
        self.elementName = elementName
    }
}
