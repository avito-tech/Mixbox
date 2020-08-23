import Bash
import XCTest

public final class BashEscapedCommandMakerImplTests: XCTestCase {
    private let maker = BashEscapedCommandMakerImpl()
    
    func test___escapedCommand___puts_arguments_in_quotes() {
        XCTAssertEqual(
            maker.escapedCommand(arguments: ["/bin/bash", "-c", "ls"]),
            """
            "/bin/bash" "-c" "ls"
            """
        )
    }
    
    func test___escapedCommand___escapes_command_evaluation_characters() {
        XCTAssertEqual(
            maker.escapedCommand(arguments: [
                """
                `uuidgen`
                """
            ]),
            """
            "\\`uuidgen\\`"
            """
        )
    }
    
    func test___escapedCommand___escapes_history_expansion_evaluation_characters() {
        XCTAssertEqual(
            maker.escapedCommand(arguments: [
                """
                !
                """
            ]),
            """
            "\\!"
            """
        )
    }
    
    func test___escapedCommand___escapes_dollar_sign_for_variable_expansion() {
        XCTAssertEqual(
            maker.escapedCommand(arguments: [
                """
                $var
                """
            ]),
            """
            "\\$var"
            """
        )
    }
    
    func test___escapedCommand___escapes_quotes() {
        XCTAssertEqual(
            maker.escapedCommand(arguments: [
                """
                "string"
                """
            ]),
            """
            "\\"string\\""
            """
        )
    }
}
