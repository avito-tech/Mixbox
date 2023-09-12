import MixboxFoundation
import XCTest

final class String_Indentation_Tests: TestCase {
    func test___mb_indent___works_correctly___with_includingFirstLine_true() {
        XCTAssertEqual(
            """
            A
             B
                C
                     D
            """.mb_indent(includingFirstLine: true),
            """
                A
                 B
                    C
                         D
            """
        )
    }
    
    func test___mb_indent___works_correctly___with_includingFirstLine_false() {
        // This perfectly demonstrates use-case for `includingFirstLine: false`
        
        XCTAssertEqual(
            """
            {
                nested stuff: \(
                    """
                    indents {
                        are
                        expected
                        here
                    }
                    """.mb_indent(includingFirstLine: false)
                )
            }
            """,
            """
            {
                nested stuff: indents {
                    are
                    expected
                    here
                }
            }
            """
        )
    }
    
    func test___mb_indent___works_correctly___with_non_default_arguments() {
        XCTAssertEqual(
            """
            A
             B
                C
                     D
            """.mb_indent(level: 5, indentation: ".", includingFirstLine: true),
            """
            .....A
            ..... B
            .....    C
            .....         D
            """
        )
    }
    
    func test___mb_wrapAndIndent___works_correctly___for_non_empty_string() {
        XCTAssertEqual(
            """
            A
             B
                C
                     D
            """.mb_wrapAndIndent(indentation: "    ", prefix: "{", postfix: "}", ifEmpty: "{}"),
            """
            {
                A
                 B
                    C
                         D
            }
            """
        )
    }
    
    func test___mb_wrapAndIndent___works_correctly___for_empty_string() {
        XCTAssertEqual(
            """
            """.mb_wrapAndIndent(indentation: "    ", prefix: "{", postfix: "}", ifEmpty: "{}"),
            """
            {}
            """
        )
    }
}
