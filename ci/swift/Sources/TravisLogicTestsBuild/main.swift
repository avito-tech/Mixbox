import BuildDsl
import RunUnitTestsTask

BuildDsl.travis.main { di in
    try RunUnitTestsTask(
        testsTaskRunner: di.resolve()
    )
}
