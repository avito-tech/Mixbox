public protocol GitTagsProvider {
    func gitTags() throws -> [GitTag]
}
