import BuildDsl
import SingletonHell
import RunGrayBoxTestsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    let environmentProvider: EnvironmentProvider = try di.resolve()
    
    return try RunGrayBoxTestsTask(
        bashExecutor: di.resolve(),
        grayBoxTestRunner: EmceeGrayBoxTestRunner(
            emceeProvider: di.resolve(),
            temporaryFileProvider: di.resolve(),
            bashExecutor: di.resolve(),
            queueServerRunConfigurationUrl: environmentProvider.getUrlOrThrow(
                env: Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL
            ),
            testArgFileJsonGenerator: di.resolve(),
            fileDownloader: di.resolve(),
            environmentProvider: di.resolve()
        ),
        mixboxTestDestinationConfigurationsProvider: di.resolve(),
        iosProjectBuilder: di.resolve(),
        bundlerBashCommandGenerator: di.resolve(),
        bashEscapedCommandMaker: di.resolve()
    )
}
