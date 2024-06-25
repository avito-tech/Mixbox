import XCTest
import MixboxGenerators
import MixboxStubbing

// swiftlint:disable file_length type_body_length
final class NestedFieldsGeneratorFacadeTests: BaseGeneratorFacadeTests {
    // MARK: - int
    
    func test___generate___can_generate_nested_field___int() {
        let object = generate {
            $0.int = 1709252944933258772
        }
        XCTAssertEqual(object.int, 1709252944933258772)
    }
    
    // MARK: - string
    
    func test___generate___can_generate_nested_field___string() {
        let object = generate {
            $0.string = "6C9E96F8-06D4-4281-B8F4-C9F6B8C21AB8"
        }
        XCTAssertEqual(object.string, "6C9E96F8-06D4-4281-B8F4-C9F6B8C21AB8")
    }
    
    // MARK: - structure
    
    func test___generate___can_generate_nested_field___structure() {
        let object = generate {
            $0.structure = $0.generate {
                $0.int = 5150726101387811365
                $0.string = "BAC474A1-FBE9-4EFE-ADBF-104A1915619B"
            }
        }
        XCTAssertEqual(object.structure.int, 5150726101387811365)
        XCTAssertEqual(object.structure.string, "BAC474A1-FBE9-4EFE-ADBF-104A1915619B")
        
    }
    
    // MARK: - optionalInt
    
    func test___generate___can_generate_nested_field___optionalInt___using_nil() {
        let object = generate {
            $0.optionalInt = nil
        }
        XCTAssertNil(object.optionalInt)
    }
    
    func test___generate___can_generate_nested_field___optionalInt___using_value() {
        let value = 3860896262760597432
        let object = generate {
            $0.optionalInt = value
        }
        XCTAssertEqual(object.optionalInt, value)
    }
    
    func test___generate___can_generate_nested_field___optionalInt___using_some() {
        let object = generate {
            $0.optionalInt = $0.some()
        }
        XCTAssertNotNil(object.optionalInt)
    }
    
    // MARK: - optionalStructure
    
    func test___generate___can_generate_nested_field___optionalStructure___using_nil() {
        let object = generate {
            $0.optionalStructure = nil
        }
        XCTAssertNil(object.optionalStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalStructure___using_value() {
        let value = Structure(
            int: 8717380343463557880,
            string: "31D6FC51-C07B-47AE-BA58-E665C91DC942"
        )
        let object = generate {
            $0.optionalStructure = value
        }
        XCTAssertEqual(object.optionalStructure, value)
    }
    
    func test___generate___can_generate_nested_field___optionalStructure___using_some___without_fields() {
        let object = generate {
            $0.optionalStructure = $0.some()
        }
        XCTAssertNotNil(object.optionalStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalStructure___using_some___with_fields() {
        let object = generate {
            $0.optionalStructure = $0.some {
                $0.int = -8055011567462439968
            }
        }
        XCTAssertEqual(object.optionalStructure?.int, -8055011567462439968)
    }
    
    // MARK: - arrayOfInt
    
    func test___generate___can_generate_nested_field___arrayOfInt___using_value() {
        let value = [3186134037649207676]
        
        let object = generate {
            $0.arrayOfInt = value
        }
        
        XCTAssertEqual(object.arrayOfInt, value)
    }
    
    func test___generate___can_generate_nested_field___arrayOfInt___using_count() {
        let object = generate {
            $0.arrayOfInt = $0.array(count: 95)
        }
        XCTAssertEqual(object.arrayOfInt.count, 95)
    }
    
    func test___generate___can_generate_nested_field___arrayOfInt___using_generate() {
        setRandom(311227243, 2084072209)
        
        let object = generate {
            $0.arrayOfInt = [
                $0.generate(),
                $0.generate()
            ]
        }
        
        XCTAssertEqual(object.arrayOfInt, [311227243, 2084072209])
    }
    
    // MARK: - arrayOfStructure
    
    func test___generate___can_generate_nested_field___arrayOfStructure___using_count___without_fields() {
        let object = generate {
            $0.arrayOfStructure = $0.array(count: 26)
        }
        XCTAssertEqual(object.arrayOfStructure.count, 26)
    }
    
    func test___generate___can_generate_nested_field___arrayOfStructure___using_count___with_fields() {
        let object = generate {
            $0.arrayOfStructure = $0.array(count: 3) {
                $0.int = $0.index()
            }
        }
        
        XCTAssertEqual(
            object.arrayOfStructure.map { $0.int },
            [0, 1, 2]
        )
    }
    
    // MARK: - optionalArrayOfInt
    
    func test___generate___can_generate_nested_field___optionalArrayOfInt___using_nil() {
        let object = generate {
            $0.optionalArrayOfInt = nil
        }
        XCTAssertNil(object.optionalArrayOfInt)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfInt___using_value() {
        let value = [3860896262760597432]
        
        let object = generate {
            $0.optionalArrayOfInt = value
        }
        
        XCTAssertEqual(object.optionalArrayOfInt, value)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfInt___using_some() {
        let object = generate {
            $0.optionalArrayOfInt = $0.some()
        }
        XCTAssertNotNil(object.optionalArrayOfInt)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfInt___using_count() {
        let object = generate {
            $0.optionalArrayOfInt = $0.array(count: 60)
        }
        XCTAssertEqual(object.optionalArrayOfInt?.count, 60)
    }
    
    // MARK: - optionalArrayOfStructure
    
    func test___generate___can_generate_nested_field___optionalArrayOfStructure___using_nil() {
        let object = generate {
            $0.optionalArrayOfStructure = nil
        }
        XCTAssertNil(object.optionalArrayOfStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfStructure___using_value() {
        let value = [Structure(
            int: 8717380343463557880,
            string: "31D6FC51-C07B-47AE-BA58-E665C91DC942"
        )]
        
        let object = generate {
            $0.optionalArrayOfStructure = value
        }
        
        XCTAssertEqual(object.optionalArrayOfStructure, value)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfStructure___using_some() {
        let object = generate {
            $0.optionalArrayOfStructure = $0.some()
        }
        XCTAssertNotNil(object.optionalArrayOfStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfStructure___using_count___without_fields() {
        let object = generate {
            $0.optionalArrayOfStructure = $0.array(count: 60)
        }
        XCTAssertEqual(object.optionalArrayOfStructure?.count, 60)
    }
    
    func test___generate___can_generate_nested_field___optionalArrayOfStructure___using_count___with_fields() {
        let object = generate {
            $0.optionalArrayOfStructure = $0.array(count: 3) {
                $0.int = $0.index()
            }
        }
        
        XCTAssertEqual(
            object.optionalArrayOfStructure.map { $0.map { $0.int } },
            [0, 1, 2]
        )
    }
    
    // MARK: - dictionaryPrimitiveToPrimitive
    
    func test___generate___can_generate_nested_field___dictionaryPrimitiveToPrimitive___using_value() {
        let value = [-3271807552552331452: 3940922342215810070]
        let object = generate {
            $0.dictionaryPrimitiveToPrimitive = value
        }
        
        XCTAssertEqual(object.dictionaryPrimitiveToPrimitive, value)
    }
    
    func test___generate___can_generate_nested_field___dictionaryPrimitiveToPrimitive___using_count() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryPrimitiveToPrimitive = $0.dictionary(count: 1)
        }
        
        XCTAssertEqual(object.dictionaryPrimitiveToPrimitive, [859497956: 2146517969])
    }
    
    // MARK: - dictionaryPrimitiveToStructure
    
    func test___generate___can_generate_nested_field___dictionaryPrimitiveToStructure___using_value() {
        let value = [
            -3271807552552331452: Structure(
                int: 8717380343463557880,
                string: "31D6FC51-C07B-47AE-BA58-E665C91DC942"
            )
        ]
        
        let object = generate {
            $0.dictionaryPrimitiveToStructure = value
        }
        
        XCTAssertEqual(object.dictionaryPrimitiveToStructure, value)
    }
    
    func test___generate___can_generate_nested_field___dictionaryPrimitiveToStructure___using_count___without_fields() {
        stubDefaultConstants()
        
        let object = generate {
            $0.dictionaryPrimitiveToStructure = $0.dictionary(count: 1)
        }
        
        XCTAssertEqual(
            object.dictionaryPrimitiveToStructure,
            [
                generatedByDefault(): Structure(
                    int: generatedByDefault(),
                    string: generatedByDefault()
                )
            ]
        )
    }
    
    func test___generate___can_generate_nested_field___dictionaryPrimitiveToStructure___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryPrimitiveToStructure = $0.dictionary(count: 1) {
                $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
            }
        }
        
        XCTAssertEqual(
            object.dictionaryPrimitiveToStructure,
            [
                859497956: Structure(
                    int: 2146517969,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                )
            ]
        )
    }
    
    // MARK: - dictionaryStructureToPrimitive
    
    func test___generate___can_generate_nested_field___dictionaryStructureToPrimitive___using_value() {
        let value = [
            Structure(
                int: 8717380343463557880,
                string: "31D6FC51-C07B-47AE-BA58-E665C91DC942"
            ) : -3271807552552331452
        ]
        
        let object = generate {
            $0.dictionaryStructureToPrimitive = value
        }
        
        XCTAssertEqual(object.dictionaryStructureToPrimitive, value)
    }
    
    func test___generate___can_generate_nested_field___dictionaryStructureToPrimitive___using_count___without_fields() {
        stubDefaultConstants()
        
        let object = generate {
            $0.dictionaryStructureToPrimitive = $0.dictionary(count: 1)
        }
        
        XCTAssertEqual(object.dictionaryStructureToPrimitive, [generatedByDefault(): generatedByDefault()])
    }
    
    func test___generate___can_generate_nested_field___dictionaryStructureToPrimitive___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryStructureToPrimitive = $0.dictionary(count: 1) {
                $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
            }
        }
        
        XCTAssertEqual(
            object.dictionaryStructureToPrimitive,
            [
                Structure(
                    int: 859497956,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                ) : 2146517969
            ]
        )
    }
    
    // MARK: - dictionaryStructureToStructure
    
    func test___generate___can_generate_nested_field___dictionaryStructureToStructure___using_value() {
        let value = [
            Structure(
                int: 8717380343463557880,
                string: "31D6FC51-C07B-47AE-BA58-E665C91DC942"
            ) : Structure(
                int: -3271807552552331452,
                string: "E08D5121-598B-4304-A6BF-C355D43E6704"
            )
        ]
        
        let object = generate {
            $0.dictionaryStructureToStructure = value
        }
        
        XCTAssertEqual(object.dictionaryStructureToStructure, value)
    }
    
    func test___generate___can_generate_nested_field___dictionaryStructureToStructure___using_count___without_fields() {
        stubDefaultConstants()
        
        let object = generate {
            $0.dictionaryStructureToStructure = $0.dictionary(count: 1)
        }
        
        XCTAssertEqual(
            object.dictionaryStructureToStructure,
            [generatedByDefault(): generatedByDefault()]
        )
    }
    
    func test___generate___can_generate_nested_field___dictionaryStructureToStructure___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryStructureToStructure = $0.dictionary(
                count: 1,
                keys: {
                    $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                },
                values: {
                    $0.string = "9FCC79F0-D57B-4946-B3CE-DDABF7EAEAE0"
                }
            )
        }
        
        XCTAssertEqual(
            object.dictionaryStructureToStructure,
            [
                Structure(
                    int: 859497956,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                ) : Structure(
                    int: 2146517969,
                    string: "9FCC79F0-D57B-4946-B3CE-DDABF7EAEAE0"
                )
            ]
        )
    }
    
    // MARK: - optionalDictionaryPrimitiveToPrimitive
    
    func test___generate___can_generate_nested_field___optionalDictionaryPrimitiveToPrimitive___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryPrimitiveToPrimitive = $0.dictionary(count: 1)
        }
        
        XCTAssertEqual(object.dictionaryPrimitiveToPrimitive, [859497956: 2146517969])
    }
    
    // MARK: - optionalDictionaryPrimitiveToStructure
    
    func test___generate___can_generate_nested_field___optionalDictionaryPrimitiveToStructure___using_nil() {
        let object = generate {
            $0.optionalDictionaryPrimitiveToStructure = nil
        }
        XCTAssertNil(object.optionalDictionaryPrimitiveToStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalDictionaryPrimitiveToStructure___using_value() {
        let value = [3860896262760597432: Structure(
            int: 2146517969,
            string: "9FCC79F0-D57B-4946-B3CE-DDABF7EAEAE0"
        )]
        
        let object = generate {
            $0.optionalDictionaryPrimitiveToStructure = value
        }
        
        XCTAssertEqual(object.optionalDictionaryPrimitiveToStructure, value)
    }
    
    func test___generate___can_generate_nested_field___optionalDictionaryPrimitiveToStructure___using_some() {
        let object = generate {
            $0.optionalDictionaryPrimitiveToStructure = $0.some()
        }
        XCTAssertNotNil(object.optionalDictionaryPrimitiveToStructure)
    }
    
    func test___generate___can_generate_nested_field___optionalDictionaryPrimitiveToStructure___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.optionalDictionaryPrimitiveToStructure = $0.dictionary(count: 1) {
                $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
            }
        }
        
        XCTAssertEqual(
            object.optionalDictionaryPrimitiveToStructure,
            [
                859497956: Structure(
                    int: 2146517969,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                )
            ]
        )
    }
    
    // MARK: - optionalDictionaryStructureToPrimitive
    
    func test___generate___can_generate_nested_field___optionalDictionaryStructureToPrimitive___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryStructureToPrimitive = $0.dictionary(count: 1) {
                $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
            }
        }
        
        XCTAssertEqual(
            object.dictionaryStructureToPrimitive,
            [
                Structure(
                    int: 859497956,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                ) : 2146517969
            ]
        )
    }
    
    // MARK: - optionalDictionaryStructureToStructure
    
    func test___generate___can_generate_nested_field___optionalDictionaryStructureToStructure___using_count___with_fields() {
        setRandom(859497956, 2146517969)
        
        let object = generate {
            $0.dictionaryStructureToStructure = $0.dictionary(
                count: 1,
                keys: {
                    $0.string = "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                },
                values: {
                    $0.string = "9FCC79F0-D57B-4946-B3CE-DDABF7EAEAE0"
                }
            )
        }
        
        XCTAssertEqual(
            object.dictionaryStructureToStructure,
            [
                Structure(
                    int: 859497956,
                    string: "4E1AA0B8-50D8-43D2-9A89-CE265419900F"
                ) : Structure(
                    int: 2146517969,
                    string: "9FCC79F0-D57B-4946-B3CE-DDABF7EAEAE0"
                )
            ]
        )
    }
    
    // MARK: - Logic
    
    func test___stubbing_dictionary___fail_tests___if_count_exceeds_possible_cases() {
        struct Key: InitializableWithFields, Hashable, CustomStringConvertible {
            let string: String
            
            init(fields: Fields<Key>) throws {
                string = try fields.string.get()
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(string)
            }
            
            var description: String {
                return string
            }
        }
        
        struct Model: InitializableWithFields {
            let dictionary: [Key: String]
            
            init(fields: Fields<Model>) throws {
                dictionary = try fields.dictionary.get()
            }
        }
        
        assertFails(
            description:
            """
            Failed to generate Dictionary<Key, String> of 1000 elements. Tried to generate unique keys 2000 times, got 1 unique values: [constant]. Try to reduce count. For example, there are only 2 unique values for type `Bool`.
            """,
            body: {
                _ = generator.generate(type: Model.self) {
                    $0.fields.dictionary = $0.dictionary(count: 1000) {
                        $0.string = "constant"
                    }
                }
            }
        )
    }
    
    // MARK: - Private
    
    private func generate(
        configure: @escaping (TestFailingDynamicLookupConfigurator<FinalClass>) -> ())
        -> FinalClass
    {
        return generator.generate(configure: configure)
    }
}
// swiftlint:enable type_body_length
