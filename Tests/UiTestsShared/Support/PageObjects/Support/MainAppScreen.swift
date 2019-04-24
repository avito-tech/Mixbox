final class MainAppScreen<T: BasePageObjectWithDefaultInitializer> {
    let real: T // real hierarchy
    let xcui: T // xcui hierarchy
    
    var everyHierarchy: [T] {
        return [real, xcui]
    }
    
    func forEveryHierarchy(body: (T) -> ()) {
        everyHierarchy.forEach(body)
    }
    
    init(real: T, xcui: T) {
        self.real = real
        self.xcui = real
    }
}
