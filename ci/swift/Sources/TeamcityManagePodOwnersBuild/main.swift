import BuildDsl
import ManagePodOwnersTask

BuildDsl.teamcity.main { di in
    try ManagePodOwnersTask(
        cocoapodsTrunkInfo: di.resolve(),
        cocoapodsTrunkAddOwner: di.resolve(),
        cocoapodsTrunkRemoveOwner: di.resolve(),
        listOfPodspecsToPushProvider: di.resolve()
    )
}
