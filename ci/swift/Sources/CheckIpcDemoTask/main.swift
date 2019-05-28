import BuildDsl
import SingletonHell
import Foundation

BuildDsl.main { di in
    try CheckIpcDemoTask(
        bashExecutor: di.resolve()
    )
}

