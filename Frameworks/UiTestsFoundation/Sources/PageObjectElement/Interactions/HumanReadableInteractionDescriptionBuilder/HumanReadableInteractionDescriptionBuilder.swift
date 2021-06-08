import MixboxTestsFoundation
import MixboxFoundation

// It is too complex and HumanReadableInteractionDescriptionBuilderSource was never extended.
// TODO: use just String. Element name can be appended to every action.
public protocol HumanReadableInteractionDescriptionBuilder: AnyObject {
    func description(info: HumanReadableInteractionDescriptionBuilderSource) -> String
}
