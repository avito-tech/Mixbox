import BuildDsl
import SingletonHell
import RunBlackBoxTestsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try RunBlackBoxTestsTask(
        bashExecutor: di.resolve(),
        blackBoxTestRunner: EmceeBlackBoxTestRunner(
            emceeProvider: di.resolve(),
            temporaryFileProvider: di.resolve(),
            bashExecutor: di.resolve(),
            queueServerRunConfigurationUrl: URL.from(
                string: Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL.getOrThrow()
            ),
            sharedQueueDeploymentDestinationsUrl: URL.from(
                string: Env.MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL.getOrThrow()
            ),
            testArgFileJsonGenerator: di.resolve(),
            fileDownloader: di.resolve()
        ),
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProviderImpl(
            decodableFromJsonFileLoader: di.resolve(),
            destinationFileBaseName: Env.MIXBOX_CI_DESTINATION.getOrThrow(),
            repoRootProvider: di.resolve()
        )
    )
}
