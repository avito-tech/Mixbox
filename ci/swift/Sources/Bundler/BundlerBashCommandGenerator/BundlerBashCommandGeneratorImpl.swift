import Bash

public final class BundlerBashCommandGeneratorImpl: BundlerBashCommandGenerator {
    private let gemfileLocationProvider: GemfileLocationProvider
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    
    public init(
        gemfileLocationProvider: GemfileLocationProvider,
        bashEscapedCommandMaker: BashEscapedCommandMaker)
    {
        self.gemfileLocationProvider = gemfileLocationProvider
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
    }
    
    public func bashCommandRunningCommandBundler(
        arguments: [String])
        throws
        -> String
    {
        let bundlerVersion = "2.1.2"
        let escapedArguments = bashEscapedCommandMaker.escapedCommand(arguments: arguments)
        
        return """
        (bundler --version | grep -q "\(bundlerVersion) 1>/dev/null 2>/dev/null") || gem install bundler -v \(bundlerVersion) --force 1>/dev/null 2>/dev/null
        
        bundle install --gemfile="\(try gemfileLocationProvider.gemfileLocation())" 1>/dev/null 2>/dev/null

        "$(which bundle)" exec "--gemfile=\(try gemfileLocationProvider.gemfileLocation())" \(escapedArguments)
        """
    }
}
