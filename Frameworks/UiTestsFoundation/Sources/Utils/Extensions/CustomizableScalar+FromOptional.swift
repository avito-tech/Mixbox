import MixboxFoundation

extension CustomizableScalar {
    static func from(optional: T?) -> Self {
        if let customized = optional {
            return .customized(customized)
        } else {
            return .automatic
        }
    }
}
