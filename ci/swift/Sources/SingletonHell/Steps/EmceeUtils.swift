import Emcee
import CiFoundation

public enum EmceeTestType: String {
    case appTest
    case uiTest
}

public final class EmceeUtils {
    public static func testArgsFile(
        emcee: Emcee,
        temporaryFileProvider: TemporaryFileProvider,
        appPath: String?,
        fbsimctlUrl: String?,
        xctestBundlePath: String,
        fbxctestUrl: String,
        testDestinationConfigurationJsonPath: String,
        environmentJson: String,
        testType: EmceeTestType)
        throws
        -> String
    {
        let destinationJson = testDestinationConfigurationJsonPath
        
        let runtimeDumpJson = try emcee.dump(
            arguments: EmceeDumpCommandArguments(
                xctestBundle: xctestBundlePath,
                fbxctest: fbxctestUrl,
                testDestinations: destinationJson,
                appPath: appPath,
                fbsimctl: fbsimctlUrl
            )
        )
        
        let testArgsFile = temporaryFileProvider.temporaryFilePath()
        
        try bash(
            """
            jq -s '{
                entries: [
                    {
                        runtimeDumpJson: .[0],
                        destinationsJson: .[1][].testDestination,
                        environmentJson: .[2]
                    } |
                    {
                        testToRun: .runtimeDumpJson[] | {c: .className, m: .testMethods[]} | join("/"),
                        testDestination: {
                            deviceType: .destinationsJson.deviceType,
                            runtime: .destinationsJson.iOSVersion
                        },
                        numberOfRetries: 4,
                        environment: .environmentJson,
                        testType: "\(testType.rawValue)"
                    }
                ]
            }' "\(runtimeDumpJson)" "\(destinationJson)" "\(environmentJson)" > "\(testArgsFile)";
            """
        )
        
        return testArgsFile
    }
}
