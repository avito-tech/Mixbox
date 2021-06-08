// TODO: Replace with provider of real hierarchy (instead of String).
public protocol ElementHierarchyDescriptionProvider: AnyObject {
    func elementHierarchyDescription() -> String?
}
