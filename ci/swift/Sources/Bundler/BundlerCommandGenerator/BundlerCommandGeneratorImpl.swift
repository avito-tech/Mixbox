import Bash

public final class BundlerCommandGeneratorImpl: BundlerCommandGenerator {
    private let bashExecutor: BashExecutor
    private let gemfileLocationProvider: GemfileLocationProvider
    private var bundlerPath: String?
    
    public init(
        bashExecutor: BashExecutor,
        gemfileLocationProvider: GemfileLocationProvider)
    {
        self.bashExecutor = bashExecutor
        self.gemfileLocationProvider = gemfileLocationProvider
    }
    
    public func bundle(
        arguments: [String])
        throws
        -> [String]
    {
        let bundleArguments = [
            try getBundlerPath(),
            "exec",
            "--gemfile=\(try gemfileLocationProvider.gemfileLocation())"
        ]
        
        return bundleArguments + arguments
    }
    
    private func getBundlerPath() throws -> String {
        if let bundlerPath = bundlerPath {
            return bundlerPath
        } else {
            let bundlerVersion = "2.0.2"
            
            _ = try bashExecutor.executeOrThrow(
                command: """
                gem install bundler -v \(bundlerVersion) --force
                
                bundle install --gemfile="\(try gemfileLocationProvider.gemfileLocation())"
                """,
                stdoutDataHandler: { _ in },
                stderrDataHandler: { _ in }
            )
            
            print("Successfully installed bundler \(bundlerVersion)")
            
            return try bashExecutor.executeAndReturnTrimmedOutputOrThrow(
                command: "which bundle"
            )
        }
    }
}
