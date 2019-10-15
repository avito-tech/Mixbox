public protocol CocoapodsFactory {
    func cocoapods(projectDirectory: String) throws -> Cocoapods
}
