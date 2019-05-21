import Bash

public final class BashCocoapodsFactory: CocoapodsFactory {
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func cocoapods(projectDirectory: String) -> Cocoapods {
        return BashCocoapods(
            bashExecutor: bashExecutor,
            projectDirectory: projectDirectory
        )
    }
}
