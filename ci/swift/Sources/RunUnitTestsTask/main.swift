import BuildDsl

BuildDsl.main { di in
    try RunUnitTestsTask(
        bashExecutor: di.resolve()
    )
}
