extension String {
    private static let newLine = "\n"
    
    func indent(level: Int = 1, includingFirstLine: Bool = false) -> String {
        let indentation = String(repeating: " ", count: level * 4)
        
        return self
            .components(separatedBy: String.newLine)
            .enumerated()
            .map { index, line in (index == 0 && !includingFirstLine) ? line : indentation + line }
            .joined(separator: String.newLine)
    }
}
