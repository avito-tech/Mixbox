import BuildDsl
import SingletonHell
import Foundation

BuildDsl.main { di in
    try CheckDemoTask(
        bashExecutor: di.resolve()
    )
}

