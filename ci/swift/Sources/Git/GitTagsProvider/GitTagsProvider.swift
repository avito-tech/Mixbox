// Note: only gets tags from current repository (with MixboxCI)
public protocol GitTagsProvider {
    func gitTags() -> [GitTag]
}
