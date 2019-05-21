// Takes full responsibility of executing CI task. Can exit process.
public protocol LocalTaskExecutor {
    func execute(localTask: LocalTask) -> Never
}
