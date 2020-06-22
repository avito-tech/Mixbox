// See: https://github.com/apple/swift-corelibs-foundation/blob/master/Foundation/Thread.swift
// Note that Thread has no option to return array of both symbol (String) and address (UInt64)
import MixboxTestsFoundation_objc

public final class StackTraceProviderImpl: StackTraceProvider {
    public init() {
    }
    
    public func stackTrace() -> [StackTraceEntry] {
        // Same as swift/stdlib/public/runtime/Errors.cpp backtrace
        let maxSupportedStackDepth = 128
    
        let backtraceAddresses = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: maxSupportedStackDepth)
        defer {
            backtraceAddresses.deallocate()
        }
    
        let backtraceAddressesCount = backtrace(backtraceAddresses, Int32(maxSupportedStackDepth))
        let storedBacktraceAddressesCount = max(0, min(Int(backtraceAddressesCount), maxSupportedStackDepth))
        
        let addressesBufferPointer = UnsafeBufferPointer(start: backtraceAddresses, count: storedBacktraceAddressesCount)

        var entries: [StackTraceEntry] = []
        guard let symbols = backtrace_symbols(backtraceAddresses, Int32(storedBacktraceAddressesCount)) else {
            return addressesBufferPointer.map {
                StackTraceEntry(
                    symbol: nil,
                    address: UInt64(UInt(bitPattern: $0))
                )
            }
        }
        
        defer {
            free(symbols)
        }
        
        let symbolsBufferPointer = UnsafeBufferPointer(start: symbols, count: storedBacktraceAddressesCount)
            
        return zip(addressesBufferPointer, symbolsBufferPointer).map { zipped in
            let (address, symbol) = zipped
            
            return StackTraceEntry(
                symbol: symbol.flatMap { String(cString: $0) },
                address: UInt64(UInt(bitPattern: address))
            )
        }
    }
}
