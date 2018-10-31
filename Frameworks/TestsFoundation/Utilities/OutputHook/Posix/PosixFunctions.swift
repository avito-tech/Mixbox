//
// Functions can throw PosixFunctionError
//
final class PosixFunctions {
    func openPipe() throws -> (readEnd: Int32, writeEnd: Int32) {
        var pipe: [Int32] = [0, 0]
        
        // Open the pipes.
        try callPosixFunction(name: "pipe()", allowPositiveResult: false) {
            Darwin.pipe(&pipe)
        }
        
        return (readEnd: pipe[0], writeEnd: pipe[1])
    }
    
    func dup2(oldFileDescriptor: Int32, newFileDescriptor: Int32) throws {
        try callPosixFunction(name: "dup2()", allowPositiveResult: true) {
            Darwin.dup2(oldFileDescriptor, newFileDescriptor)
        }
    }
    func dup(fileDescriptor: Int32) throws -> Int32 {
        return try callPosixFunction(name: "dup()", allowPositiveResult: true) {
            Darwin.dup(fileDescriptor)
        }
    }
    
    func close(fileDescriptor: Int32) throws {
        try callPosixFunction(name: "close()", allowPositiveResult: false) {
            Darwin.close(fileDescriptor)
        }
    }
    
    func read(fileDescriptor: Int32, buffer: inout [UInt8], count: Int) throws -> Int {
        return try callPosixFunction(name: "read()", allowPositiveResult: true) {
            Darwin.read(fileDescriptor, &buffer, count)
        }
    }
    
    @discardableResult
    private func callPosixFunction(
        name: String,
        allowPositiveResult: Bool,
        closure: () -> Int32)
        throws -> Int32
    {
        let result = try callPosixFunction(
            name: name,
            allowPositiveResult: allowPositiveResult,
            closure: {
                Int(closure())
            }
        )
        
        return Int32(result)
    }
    
    @discardableResult
    private func callPosixFunction(
        name: String,
        allowPositiveResult: Bool,
        closure: () -> Int)
        throws -> Int
    {
        let result = closure()
        
        switch result {
        case -1:
            throw PosixFunctionError(
                functionName: name,
                result: result,
                errno: errno
            )
        case 0:
            break
        default:
            if !allowPositiveResult {
                throw PosixFunctionError(
                    functionName: name,
                    result: result,
                    errno: nil
                )
            }
        }
        
        return result
    }
}
