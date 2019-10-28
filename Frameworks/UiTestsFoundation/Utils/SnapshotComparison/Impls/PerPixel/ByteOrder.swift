import MixboxFoundation

public enum ByteOrder {
    case littleEndian
    case bigEndian
    
    public static func host() throws -> ByteOrder {
        let byteOrder = CFByteOrderGetCurrent()
        switch byteOrder {
        case Int(CFByteOrderLittleEndian.rawValue):
            return .littleEndian
        case Int(CFByteOrderBigEndian.rawValue):
            return .bigEndian
        default:
            throw ErrorString("Unknown byte order returned by CFByteOrderGetCurrent(): \(byteOrder)")
        }
    }
}
