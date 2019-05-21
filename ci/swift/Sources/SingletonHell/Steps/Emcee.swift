import Foundation
import CiFoundation

// Translated from `emcee.sh`
// TODO: Rewrite.
public final class Emcee {
    private static var __MIXBOX_CI_EMCEE_PATH: String?
    
    public static func installEmceeWithDependencies() throws {
        __MIXBOX_CI_EMCEE_PATH = try EmceeInstaller.installEmceeWithDependencies()
    }
    
    private static func emcee(args: [String]) throws {
        guard let emceePath = __MIXBOX_CI_EMCEE_PATH else {
            throw ErrorString("Failed to run Emcee. __MIXBOX_CI_EMCEE_PATH is nil.")
        }
        
        guard FileManager.default.isExecutableFile(atPath: emceePath) else {
            throw ErrorString("Failed to run Emcee. File is not executable at path: \(emceePath)")
        }
        
        let argsString = args.map { "\"\($0)\"" }.joined(separator: " ")
        try bash(
            """
            "\(emceePath)" \(argsString)
            """
        )
    }
    
    public static func testUsingEmcee(
        appName: String,
        testsTarget: String,
        additionalApp: String)
        throws
    {
        let runnerAppName = "\(testsTarget)-Runner.app"
        let derivedDataPath = Variables.derivedDataPath()
        
        try mkdirp(Env.MIXBOX_CI_REPORTS_PATH.getOrThrow())
    
        print("Running tests")
    
        // cd "$MIXBOX_CI_SCRIPT_DIRECTORY"
    
        let destinationFile = try DestinationUtils.destinationFile()
        
        let products = "\(derivedDataPath)/Build/Products/Debug-iphonesimulator"
        
        let xctestBundle = "\(products)/\(testsTarget)-Runner.app/PlugIns/\(testsTarget).xctest"
        let runnerPath = "\(products)/\(runnerAppName)"
        let appPath = "\(products)/\(appName)"
        let additionalAppPath = "\(products)/\(additionalApp)"
        let emceeAction: String
        var emceeArgs: [String]
        
        if isDistRun() {
            emceeAction = "runTestsOnRemoteQueue"
    
            emceeArgs = [
                // Simple args
                "--priority", "500",
                "--run-id", uuidgen(),
    
                // Configs
                "--destinations", try RemoteFiles.download(
                    url: Env.MIXBOX_CI_EMCEE_WORKER_DEPLOYMENT_DESTINATIONS_URL.getOrThrow()
                ),
                "--test-arg-file", try testArgsFile(xctestBundle: xctestBundle),
                "--queue-server-destination", try RemoteFiles.download(
                    url: Env.MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL.getOrThrow()
                ),
                "--queue-server-run-configuration-location", try Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL.getOrThrow(),
                
                // Code being tested
                "--runner", try RemoteFiles.upload_hashed_zipped_for_emcee(file: runnerPath),
                "--app", try RemoteFiles.upload_hashed_zipped_for_emcee(file: appPath),
                "--additional-app", try RemoteFiles.upload_hashed_zipped_for_emcee(file: additionalAppPath),
                "--xctest-bundle", try RemoteFiles.upload_hashed_zipped_for_emcee(file: xctestBundle)
            ] as [String]
        } else {
            emceeAction = "runTests"
    
            emceeArgs = [
                // Simple args
                "--number-of-simulators", "2",
                "--schedule-strategy", "progressive",
                "--temp-folder", derivedDataPath,
                "--environment", try environment(),
                "--number-of-retries", "3",
                "--single-test-timeout", "1200",
                "--fbxctest-bundle-ready-timeout", "600",
                "--fbxctest-crash-check-timeout", "600",
                "--fbxctest-fast-timeout", "600",
                "--fbxctest-regular-timeout", "600",
                "--fbxctest-silence-timeout", "600",
                "--fbxctest-slow-timeout", "1200",
                
                // Dependencies
                "--fbsimctl", try Env.MIXBOX_CI_EMCEE_FBSIMCTL_URL.getOrThrow(),
                
                // Code being tested
                "--runner", runnerPath,
                "--app", appPath,
                "--xctest-bundle", xctestBundle
            ]
        }
        
        let reportsPath = try Env.MIXBOX_CI_REPORTS_PATH.getOrThrow()
    
        // Common
        emceeArgs.append(
            contentsOf: [
                "--fbxctest", try Env.MIXBOX_CI_EMCEE_FBXCTEST_URL.getOrThrow(),
                "--junit", "\(reportsPath)/junit.xml",
                "--trace", "\(reportsPath)/trace.combined.json",
                "--test-destinations", destinationFile
            ]
        )
    
        try emcee(args: [emceeAction] + emceeArgs)
    }
    
    private static func isDistRun() -> Bool {
        return Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL.get() != nil
            && Env.MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL.get() != nil
            && Env.MIXBOX_CI_EMCEE_WORKER_DEPLOYMENT_DESTINATIONS_URL.get() != nil
    }
    
    private static func testArgsFile(xctestBundle: String) throws -> String {
        let derivedDataPath = Variables.derivedDataPath()
        let runtimeDump = "\(derivedDataPath)/runtime_dump.json"
        let destinationFile = try DestinationUtils.destinationFile()
    
        try emcee(
            args: [
                "dump",
                "--test-destinations", destinationFile,
                "--fbxctest", try Env.MIXBOX_CI_EMCEE_FBXCTEST_URL.getOrThrow(),
                "--xctest-bundle", xctestBundle,
                "--output", runtimeDump
            ]
        )
    
        let testArgsFile = "\(derivedDataPath)/test_args_file.json"
    
        try bash(
            """
            jq -s '{
                entries: [
                    {
                        runtimeDumpJson: .[0],
                        destinationsJson: .[1][].testDestination,
                        environment: .[2]
                    } |
                    {
                        testToRun: .runtimeDumpJson[] | {c: .className, m: .testMethods[]} | join("/"),
                        testDestination: {
                            deviceType: .destinationsJson.deviceType,
                            runtime: .destinationsJson.iOSVersion
                        },
                        numberOfRetries: 4,
                        environment: .environment
                    }
                ]
            }' "\(runtimeDump)" "\(destinationFile)" "\(environment())" > "\(testArgsFile)";
            """
        )
    
        return testArgsFile
    }

    private static func environment() throws -> String {
        let derivedDataPath = Variables.derivedDataPath()
        let sourceEnvironment = "\(try repoRoot())/ci/builds/emcee/environment.json"
        let environment = "\(derivedDataPath)/environment.json"
        
        if let reportsDirectory = Env.MIXBOX_CI_ALLURE_REPORTS_DIRECTORY.get(), !isDistRun() {
            try? rmrf(reportsDirectory)
            try mkdirp(reportsDirectory)
            
            try bash(
                """
                cat "\(sourceEnvironment)" | jq '. + {
                    "MIXBOX_CI_ALLURE_REPORTS_DIRECTORY": "\(reportsDirectory)"
                }' > "\(environment)"
                """
            )
        } else {
            try bash(
                """
                cp "\(sourceEnvironment)" "\(environment)" > /dev/null
                """
            )
        }
        
        return environment
    }

    public static func generateReports() throws {
        if let reportsDirectory = Env.MIXBOX_CI_ALLURE_REPORTS_DIRECTORY.get() {
            try bash(
                """
                which allure || brew install allure
                
                results="\(reportsDirectory)/results"
                report="\(reportsDirectory)/report"
                
                allure generate "$results" -o "$report"
                
                rm -rf "\(reportsDirectory)/results"
                """
            )
        }
    }

}
