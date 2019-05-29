import BuildDsl
import SingletonHell
import Foundation
import CheckDemoTask

BuildDsl.travis.main { di in
    try CheckDemoTask(
        bashExecutor: di.resolve()
    )
}

