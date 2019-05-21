import BuildDsl

BuildDsl.main { di in
    try RunBlackBoxTestsTask(
        bashExecutor: di.resolve()
    )
}

