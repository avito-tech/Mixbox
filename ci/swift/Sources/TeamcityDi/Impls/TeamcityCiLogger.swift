import CiFoundation

public final class TeamcityCiLogger: CiLogger {
    public init() {}
    
    public func logBlock(
        name: String,
        body: () throws -> ()
    ) rethrows {
        output(
            string: "##teamcity[blockOpened name='\(name)']"
        )
        
        try body()
        
        output(
            string: "##teamcity[blockClosed name='\(name)']"
        )
    }
    
    public func log(
        string: @autoclosure () -> String
    ) {
        output(string: string())
    }
    
    private func output(string: String) {
        print(string)
    }
}
