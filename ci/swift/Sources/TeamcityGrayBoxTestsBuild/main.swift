import BuildDsl
import SingletonHell
import RunGrayBoxTestsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try RunGrayBoxTestsTask(
        testsTaskRunner: di.resolve()
    )
}
