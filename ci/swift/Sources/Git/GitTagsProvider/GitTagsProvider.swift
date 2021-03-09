public protocol GitTagsProvider {
    func gitTags(repoRoot: String) throws -> [GitTag]
}
