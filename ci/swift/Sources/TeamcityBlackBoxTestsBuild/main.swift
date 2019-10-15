import BuildDsl
import SingletonHell
import RunBlackBoxTestsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    let environmentProvider: EnvironmentProvider = try di.resolve()

    return try RunBlackBoxTestsTask(
        bashExecutor: di.resolve(),
        blackBoxTestRunner: EmceeBlackBoxTestRunner(
            emceeProvider: di.resolve(),
            temporaryFileProvider: di.resolve(),
            bashExecutor: di.resolve(),
            queueServerRunConfigurationUrl: environmentProvider.getUrlOrThrow(
                env: Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL
            ),
            sharedQueueDeploymentDestinationsUrl: environmentProvider.getUrlOrThrow(
                env: Env.MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL
            ),
            testArgFileJsonGenerator: di.resolve(),
            fileDownloader: di.resolve(),
            environmentProvider: di.resolve()
        ),
        mixboxTestDestinationConfigurationsProvider: di.resolve(),
        iosProjectBuilder: di.resolve(),
        bundlerCommandGenerator: di.resolve()
    )
}
