import XCTest
import MixboxGenerator

final class GeneratorFacadeTests: BaseGeneratorTestCase {
    private let unstubbedInt = 1234567890
    private let unstubbedString = "1234567890"
    
    override func setUp() {
        super.setUp()
        
        mocks.register(type: Generator<Int>.self) { [unstubbedInt] _ in
            ConstantGenerator(unstubbedInt)
        }
        mocks.register(type: Generator<String>.self) { [unstubbedString] _ in
            ConstantGenerator(unstubbedString)
        }
        mocks.register(type: ByFieldsGenerator<TitledEntity>.self) { _ in
            ByFieldsGenerator<TitledEntity> { fields in
                TitledEntity(title: fields.title)
            }
        }
    }
    
    func test___generate___is_stateless() {
        var book: Book
            
        book = generator.generate {
            $0.id = 1
            $0.title = "Hamlet"
        }
        
        XCTAssertEqual(book.id, 1)
        XCTAssertEqual(book.title, "Hamlet")
        
        // Generation in this case should be stateless
        // Generation should give an ability to fill fields partially.
        
        book = generator.generate {
            $0.title = "War and Peace"
        }
        
        XCTAssertEqual(book.id, unstubbedInt)
        XCTAssertEqual(book.title, "War and Peace")
    }
    
    func test___generate___can_stub_nested_types() {
        let book: Book = generator.generate {
            $0.author.stub {
                $0.id = 2
                $0.name = "William Shakespeare"
            }
        }
        
        XCTAssertEqual(book.id, unstubbedInt)
        XCTAssertEqual(book.title, unstubbedString)
        XCTAssertEqual(book.author.id, 2)
        XCTAssertEqual(book.author.name, "William Shakespeare")
    }
    
    func test___generate___can_generate_non_final_classes() {
        let entity: TitledEntity = generator.generate {
            $0.title = "How to title a book for dummies."
        }
        
        XCTAssertEqual(entity.title, "How to title a book for dummies.")
    }
}

// To check how generators work with classes
private final class Book: TitledEntity, Equatable, InitializableWithFields {
    let id: Int
    let author: Author
    
    init(fields: Fields<Book>) {
        id = fields.id
        author = fields.author
        
        super.init(
            title: fields.title
        )
    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

// To check how generators work with non-final classes
private class TitledEntity {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

// To check how generators work with structs
private struct Author: Equatable, InitializableWithFields {
    let id: Int
    let name: String
    
    init(fields: Fields<Author>) {
        id = fields.id
        name = fields.name
    }
}
