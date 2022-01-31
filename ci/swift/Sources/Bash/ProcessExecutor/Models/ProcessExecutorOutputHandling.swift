import Foundation

public final class ProcessExecutorOutputHandling {
    public let stdoutDataHandler: (Data) -> ()
    public let stderrDataHandler: (Data) -> ()
    
    public init(
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ()
    ) {
        self.stdoutDataHandler = stdoutDataHandler
        self.stderrDataHandler = stderrDataHandler
    }
    
    public static var ignore: ProcessExecutorOutputHandling {
        ProcessExecutorOutputHandling(
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
    }
    
    public static var bypass: ProcessExecutorOutputHandling {
        ProcessExecutorOutputHandling(
            stdoutDataHandler: { data in
                FileHandle.standardOutput.write(data)
            },
            stderrDataHandler: { data in
                FileHandle.standardError.write(data)
            }
        )
    }
}
