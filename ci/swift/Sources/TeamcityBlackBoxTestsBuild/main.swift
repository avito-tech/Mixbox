import BuildDsl
import SingletonHell
import Foundation
import RunBlackBoxTestsTask

BuildDsl.teamcity.main { di in
    try RunBlackBoxTestsTask(
        bashExecutor: di.resolve(),
        blackBoxTestRunner: EmceeBlackBoxTestRunner(
            emceeProvider: di.resolve(),
            temporaryFileProvider: di.resolve(),
            bashExecutor: di.resolve(),
            queueServerRunConfigurationUrl: try Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL.getOrThrow(),
            sharedQueueDeploymentDestinationsUrl: try Env.MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL.getOrThrow(),
            workerDeploymentDestinationsUrl: try  Env.MIXBOX_CI_EMCEE_WORKER_DEPLOYMENT_DESTINATIONS_URL.getOrThrow()
        )
    )
}

