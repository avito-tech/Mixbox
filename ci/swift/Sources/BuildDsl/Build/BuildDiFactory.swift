import DI

public protocol BuildDiFactory {
    func di() -> DependencyInjection
}
