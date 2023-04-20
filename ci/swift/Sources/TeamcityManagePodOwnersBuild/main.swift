import BuildDsl
import ManagePodOwnersTask
import Tasks
import DI

public final class TeamcityManagePodOwnersBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try ManagePodOwnersTask(
            cocoapodsTrunkInfo: di.resolve(),
            cocoapodsTrunkAddOwner: di.resolve(),
            cocoapodsTrunkRemoveOwner: di.resolve(),
            listOfPodspecsToPushProvider: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityManagePodOwnersBuild()
)
