import Bash

public final class BundlerCommandGeneratorImpl: BundlerCommandGenerator {
    private let bashExecutor: BashExecutor
    private let gemfileLocationProvider: GemfileLocationProvider
    private var bundlerIsInstalled = false
    
    public init(
        bashExecutor: BashExecutor,
        gemfileLocationProvider: GemfileLocationProvider)
    {
        self.bashExecutor = bashExecutor
        self.gemfileLocationProvider = gemfileLocationProvider
    }
    
    public func bundlerCommand(
        command: String)
        throws
        -> String
    {
        try installBundlerIfNeeded()
        
        return """
        bundle exec --gemfile="\(try gemfileLocationProvider.gemfileLocation())" \(command)
        """
    }
    
    private func installBundlerIfNeeded() throws {
        if !bundlerIsInstalled {
            try installBundler()
            bundlerIsInstalled = true
        }
    }
    
    private func installBundler() throws {
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
    }
}
