final class FailsHereFunctionProvider {
    var file: String?
    var line: Int?
    
    func here(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
}
