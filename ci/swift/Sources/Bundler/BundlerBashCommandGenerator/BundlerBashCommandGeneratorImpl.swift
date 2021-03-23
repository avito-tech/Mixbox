import Bash

public final class BundlerBashCommandGeneratorImpl: BundlerBashCommandGenerator {
    public enum BundlerToUse {
        case install(version: String)
        case useSystem
    }
    
    private let gemfileLocationProvider: GemfileLocationProvider
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    private let bundlerToUse: BundlerToUse
    
    public init(
        gemfileLocationProvider: GemfileLocationProvider,
        bashEscapedCommandMaker: BashEscapedCommandMaker,
        bundlerToUse: BundlerToUse)
    {
        self.gemfileLocationProvider = gemfileLocationProvider
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
        self.bundlerToUse = bundlerToUse
    }
    
    public func bashCommandRunningCommandBundler(
        arguments: [String])
        throws
        -> String
    {
        var commands = [String]()
        
        switch bundlerToUse {
        case .install(let bundlerVersion):
            commands.append(installBundlerCommand(bundlerVersion: bundlerVersion))
        case .useSystem:
            break
        }
        
        let gemfileLocation = try gemfileLocationProvider.gemfileLocation()
        
        commands.append(installDependenciesCommand(gemfileLocation: gemfileLocation))
        commands.append(execCommand(gemfileLocation: gemfileLocation, arguments: arguments))
        
        return commands.joined(separator: "\n\n")
    }
    
    private func installBundlerCommand(bundlerVersion: String) -> String {
        """
        (bundler --version | grep -q "\(bundlerVersion)" 1>/dev/null 2>/dev/null) \
            || gem install bundler -v \(bundlerVersion) --force 1>/dev/null 2>/dev/null
        """
    }
    
    private func installDependenciesCommand(gemfileLocation: String) -> String {
        """
        bundle install --gemfile="\(gemfileLocation)" 1>/dev/null 2>/dev/null
        """
    }
    
    private func execCommand(gemfileLocation: String, arguments: [String]) -> String {
        let escapedArguments = bashEscapedCommandMaker.escapedCommand(arguments: arguments)
        
        return """
        bundle exec "--gemfile=\(gemfileLocation)" \(escapedArguments)
        """
    }
}
