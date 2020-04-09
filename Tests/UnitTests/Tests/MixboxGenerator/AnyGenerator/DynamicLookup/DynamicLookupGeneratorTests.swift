import MixboxGenerator
import MixboxDi
import MixboxTestsFoundation
import Dip
import XCTest

class DynamicLookupGeneratorTests: TestCase {
    private let di = makeDi()
    
    func test___generator___can_generate_class___based_on_InitializableWithFields() {
        check___generator___can_generate(class: InitializableWithFieldsClass.self)
    }
    
    func test___generator___can_generate_class___based_on_GeneratableByFields() {
        check___generator___can_generate(class: GeneratableByFieldsClass.self)
    }
    
    private func check___generator___can_generate<T>(class: T.Type = T.self)
        where
        T: ValueHolder,
        T: GeneratableByFields
    {
        do {
            di.register(type: Generator<Int>.self) { _ in
                ConstantGenerator(42)
            }
            
            let generator = DynamicLookupGenerator<T>(
                dependencies: try DynamicLookupGeneratorDependencies(dependencyResolver: di)
            )
            
            XCTAssertEqual(
                try generator.generate().value,
                42
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private static func makeDi() -> DependencyInjection {
        let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
        
        di.register(type: AnyGenerator.self) { dependencyResolver in
            AnyGeneratorImpl(dependencyResolver: dependencyResolver)
        }
        di.register(type: Generator<Bool>.self) { di in
            try RandomBoolGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Float>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<CGFloat>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Double>.self) { di in
            try RandomFloatGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<Int>.self) { di in
            try RandomIntegerGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: Generator<String>.self) { di in
            try RandomStringGenerator(randomNumberProvider: di.resolve())
        }
        di.register(type: RandomNumberProvider.self) { _ in
            MersenneTwisterRandomNumberProvider(seed: 0)
        }
        
        return di
    }
}

private protocol ValueHolder {
    var value: Int { get }
}

private final class InitializableWithFieldsClass: InitializableWithFields, ValueHolder {
    let value: Int
    
    init(fields: Fields<InitializableWithFieldsClass>) {
        value = fields.value
    }
}

private final class GeneratableByFieldsClass: GeneratableByFields, ValueHolder {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    static func generate(fields: Fields<GeneratableByFieldsClass>) -> Self {
        return Self(value: fields.value)
    }
}
