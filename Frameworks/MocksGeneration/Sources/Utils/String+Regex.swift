import Foundation

extension String {
    func replace(
        regex: NSRegularExpression,
        template: String)
        -> String
    {
        return regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: (self as NSString).length),
            withTemplate: template
        )
    }
}
