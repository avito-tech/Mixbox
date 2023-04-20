import DI
import TeamcityDi

open class BaseTeamcityBuild: BuildDiFactory {
    public init() {
    }
    
    open func di() -> DependencyInjection {
        return DiMaker<TeamcityBuildDependencies>.makeDi()
    }
}
