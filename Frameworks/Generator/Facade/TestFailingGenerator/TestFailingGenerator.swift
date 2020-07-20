// Allows you to not bother with expection handling in tests.
// `generate` will either return value or test will be failed.
public protocol TestFailingGenerator {
    func generate<T>() -> T
}
