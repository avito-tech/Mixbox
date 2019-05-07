final class FileForStacktraceTestsWithFixedNameAndLineNumbers {
    func func_line2() { func_line3() }
    func func_line3() { func_line4() }
    func func_line4() { func_line5() }
    func func_line5() { func_line6() }
    func func_line6() { func_line7() }
    func func_line7() { func_line8() }
    func func_line8() { func_line9() }
    func func_line9() { func_line10() }
    func func_line10() { closure() }
    
    private let closure: () -> ()
    init(closure: @escaping () -> ()) {
        self.closure = closure
    }
}
