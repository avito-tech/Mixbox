public protocol RepoRootProvider {
    func repoRootPath() throws -> String
}
