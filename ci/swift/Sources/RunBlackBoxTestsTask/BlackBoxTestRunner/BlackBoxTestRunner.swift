public protocol BlackBoxTestRunner {
    func runTests(
        xctestBundle: String,
        runnerPath: String,
        appPath: String,
        additionalAppsPaths: [String])
        throws
}

// Delegation

public protocol BlackBoxTestRunnerHolder {
    var blackBoxTestRunner: BlackBoxTestRunner { get }
}

extension BlackBoxTestRunner where Self: BlackBoxTestRunnerHolder {
    public func runTests(
        xctestBundle: String,
        runnerPath: String,
        appPath: String,
        additionalAppsPaths: [String])
        throws
    {
        try blackBoxTestRunner.runTests(
            xctestBundle: xctestBundle,
            runnerPath: runnerPath,
            appPath: appPath,
            additionalAppsPaths: additionalAppsPaths
        )
    }
}
