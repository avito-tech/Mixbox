import MixboxGenerators
import MixboxDi
import MixboxDipDi
import MixboxTestsFoundation
import Dip
import XCTest

class DynamicLookupGeneratorTests: BaseGeneratorTestCase {
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
            let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
            
            di.register(type: Generator<Int>.self) { _ in
                ConstantGenerator(42)
            }
            
            let byFieldsGeneratorResolver = ByFieldsGeneratorResolverImpl(
                dependencyResolver: di
            )
            
            let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
                anyGenerator: AnyGeneratorImpl(
                    dependencyResolver: di,
                    byFieldsGeneratorResolver: byFieldsGeneratorResolver
                ),
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
            
            let generator: Generator<T> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
            
            XCTAssertEqual(
                try generator.generate().value,
                42
            )
        } catch {
            XCTFail("\(error)")
        }
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
    
    static func byFieldsGenerator() -> ByFieldsGenerator<GeneratableByFieldsClass> {
        return ByFieldsGenerator { fields in
            Self(value: fields.value)
        }
    }
}
