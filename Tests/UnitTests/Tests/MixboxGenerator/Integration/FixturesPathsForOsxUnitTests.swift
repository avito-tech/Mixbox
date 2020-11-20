// Note: file is in OsxUnitTests target.
// It is used to debug code generation in Xcode.

import PathKit

final class FixturesPathsForOsxUnitTests {
    private init() {}
    
    static let folderPath = Path(#file) + ".."
    
    static let protocolToMock = folderPath + "ProtocolToMock.swift"
    static let objcProtocolToMock = folderPath + "ObjcProtocolToMock.swift"
    
    static var allFiles: [Path] {
        return [protocolToMock, objcProtocolToMock]
    }
}
