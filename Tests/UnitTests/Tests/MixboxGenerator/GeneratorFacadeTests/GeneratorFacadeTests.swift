import XCTest
import MixboxGenerator

final class GeneratorFacadeTests: BaseGeneratorTestCase {
    func test() {
        let unstubbedInt = 1234567890
        let unstubbedString = "1234567890"
        
        mocks.register(type: Generator<Int>.self) { _ in
            ConstantGenerator(unstubbedInt)
        }
        mocks.register(type: Generator<String>.self) { _ in
            ConstantGenerator(unstubbedString)
        }
        
        var book: Book
            
        book = generator.generate {
            $0.id = 1
            $0.title = "Hamlet"
            $0.author.stub {
                $0.id = 2
                $0.name = "William Shakespeare"
            }
        }
        
        XCTAssertEqual(book.id, 1)
        XCTAssertEqual(book.title, "Hamlet")
        XCTAssertEqual(book.author.id, 2)
        XCTAssertEqual(book.author.name, "William Shakespeare")
        
        // Generation in this case should be stateless
        // Generation should give an ability to fill fields partially.
        
        book = generator.generate {
            $0.id = 3
            $0.title = "War and Peace"
        }
        
        XCTAssertEqual(book.id, 3)
        XCTAssertEqual(book.title, "War and Peace")
        XCTAssertEqual(book.author.id, unstubbedInt)
        XCTAssertEqual(book.author.name, unstubbedString)
    }
}

private final class Book: InitializableWithFields {
    let id: Int
    let title: String
    let author: Author
    
    init(fields: Fields<Book>) {
        id = fields.id
        title = fields.title
        author = fields.author
    }
}

private final class Author: InitializableWithFields {
    let id: Int
    let name: String
    
    init(fields: Fields<Author>) {
        id = fields.id
        name = fields.name
    }
}
