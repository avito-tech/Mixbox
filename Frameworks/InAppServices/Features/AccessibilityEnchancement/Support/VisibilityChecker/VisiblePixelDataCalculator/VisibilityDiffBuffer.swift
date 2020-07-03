#if MIXBOX_ENABLE_IN_APP_SERVICES

//  Data structure that holds a buffer representing the visible pixels of a visibility check diff.
public struct VisibilityDiffBuffer {
    public private(set) var data: UnsafeArray<Bool>
    public let width: Int
    public let height: Int
    
    public init(data: UnsafeArray<Bool>, width: Int, height: Int) {
        self.data = data
        self.width = width
        self.height = height
    }
    
    public static func createUninitialized(width: Int, height: Int) -> Self {
        return Self(
            data: UnsafeArray<Bool>(count: width * height),
            width: width,
            height: height
        )
    }
    
    public mutating func setVisibility(
        x: Int,
        y: Int,
        value: Bool)
    {
        if x >= width || y >= height {
            print("Warning: trying to access a point outside the diff buffer: \(x), \(y)")
            return
        }
        
        data[y * width + x] = value
    }
    
    public func isVisible(
        x: Int,
        y: Int)
        -> Bool
    {
        if x >= width || y >= height {
            print("Warning: trying to access a point outside the diff buffer: \(x), \(y)")
            return false
        }
        
        return data[y * width + x]
    }
}

#endif
