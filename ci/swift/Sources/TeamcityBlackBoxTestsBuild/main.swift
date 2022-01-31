import BuildDsl
import SingletonHell
import RunBlackBoxTestsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try RunBlackBoxTestsTask(
        testsTaskRunner: di.resolve()
    )
}
