import Bash
import Bundler

public final class CocoapodsFactoryImpl: CocoapodsFactory {
    private let bashExecutor: BashExecutor
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.bundlerCommandGenerator = bundlerCommandGenerator
    }
    
    public func cocoapods(projectDirectory: String) throws -> Cocoapods {
        return CocoapodsImpl(
            bashExecutor: bashExecutor,
            projectDirectory: projectDirectory,
            bundlerCommandGenerator: bundlerCommandGenerator
        )
    }
}
