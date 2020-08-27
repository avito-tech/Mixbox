import UIKit

public final class IpcColor: Codable {
    // Values are in range 0...1
    public let alpha: CGFloat
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    
    public init(
        alpha: CGFloat,
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat)
    {
        self.alpha = alpha
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(
        alpha: CGFloat,
        white: CGFloat)
    {
        self.alpha = alpha
        self.red = white
        self.green = white
        self.blue = white
    }
    
    public var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static var red = IpcColor(alpha: 1, red: 1, green: 0, blue: 0)
    public static var green = IpcColor(alpha: 1, red: 0, green: 1, blue: 0)
    public static var blue = IpcColor(alpha: 1, red: 0, green: 0, blue: 1)
    
    public static var white = IpcColor(alpha: 1, white: 1)
    public static var gray = IpcColor(alpha: 1, white: 0.5)
    public static var black = IpcColor(alpha: 1, white: 0)
}
