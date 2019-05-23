public protocol GrayBoxTestRunner {
    func runTests(
        xctestBundle: String,
        appPath: String)
        throws
}
