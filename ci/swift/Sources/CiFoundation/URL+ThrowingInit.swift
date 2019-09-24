import Foundation

extension URL {
    public static func from(
        string: String,
        file: StaticString = #file,
        line: UInt = #line)
        throws
        -> URL
    {
        guard let url = URL(string: string) else {
            throw ErrorString("Failed to init URL with string '\(string)', \(file):\(line)")
        }
        
        return url
    }
}
