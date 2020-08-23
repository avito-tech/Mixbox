import BuildDsl
import SingletonHell
import ReleaseToCocoapodsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try ReleaseToCocoapodsTask(
        bashExecutor: di.resolve()
    )
}
