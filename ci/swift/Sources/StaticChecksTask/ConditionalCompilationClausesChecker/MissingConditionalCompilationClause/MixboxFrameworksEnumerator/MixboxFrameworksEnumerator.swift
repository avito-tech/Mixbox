public protocol MixboxFrameworksEnumerator {
    func enumerateFrameworks(
        handler: (_ frameworkDirectory: String, _ frameworkName: String) throws -> ())
        throws
}
