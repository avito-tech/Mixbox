import BuildDsl
import SingletonHell
import Foundation
import CheckIpcDemoTask

BuildDsl.travis.main { di in
    try CheckIpcDemoTask(
        bashExecutor: di.resolve()
    )
}

