import DI
import TravisDi

open class BaseTravisBuild: BuildDiFactory {
    public init() {
    }
    
    open func di() -> DependencyInjection {
        return DiMaker<TravisBuildDependencies>.makeDi()
    }
}
