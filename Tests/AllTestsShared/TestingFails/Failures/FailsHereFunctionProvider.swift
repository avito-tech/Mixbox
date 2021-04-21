final class FailsHereFunctionProvider {
    var file: String?
    var line: UInt?
    
    func here(file: String = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line
    }
    
    func onNextLine(file: String = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line + 1
    }
}
