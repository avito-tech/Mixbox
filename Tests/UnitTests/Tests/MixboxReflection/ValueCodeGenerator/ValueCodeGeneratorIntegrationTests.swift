import XCTest
import MixboxReflection

final class ValueCodeGeneratorIntegrationTests: BaseValueCodeGeneratorTests {
    // swiftlint:disable:next function_body_length
    func test___generateCode___generates_code() {
        check(
            ClassWithManyFields(
                baseClassField: 40,
                int: 0,
                string: "1",
                structure: Struct(
                    int: 2,
                    string: "3"
                ),
                optionalInt: 4,
                optionalStructure: Struct(
                    int: 5,
                    string: "6"
                ),
                arrayOfInt: [
                    7,
                    8
                ],
                arrayOfStructure: [
                    Struct(
                        int: 9,
                        string: "10"
                    ),
                    Struct(
                        int: 11,
                        string: "12"
                    )
                ],
                optionalArrayOfInt: [
                    13
                ],
                optionalArrayOfStructure: [
                    Struct(
                        int: 14,
                        string: "15"
                    )
                ],
                dictionaryPrimitiveToPrimitive: [
                    16: 17
                ],
                dictionaryPrimitiveToStructure: [
                    18: Struct(
                        int: 19,
                        string: "20"
                    )
                ],
                dictionaryStructureToPrimitive: [
                    Struct(
                        int: 21,
                        string: "22"
                    ): 23
                ],
                dictionaryStructureToStructure: [
                    Struct(
                        int: 24,
                        string: "25"
                    ): Struct(
                        int: 26,
                        string: "27"
                    )
                ],
                optionalDictionaryPrimitiveToPrimitive: [
                    28: 29
                ],
                optionalDictionaryPrimitiveToStructure: [
                    30: Struct(
                        int: 31,
                        string: "32"
                    )
                ],
                optionalDictionaryStructureToPrimitive: [
                    Struct(
                        int: 33,
                        string: "34"
                    ): 35
                ],
                optionalDictionaryStructureToStructure: [
                    Struct(
                        int: 36,
                        string: "37"
                    ): Struct(
                        int: 38,
                        string: "39"
                    )
                ]
            ),
            """
            ClassWithManyFields(
                baseClassField: 40,
                int: 0,
                string: "1",
                structure: Struct(
                    int: 2,
                    string: "3"
                ),
                optionalInt: 4,
                optionalStructure: Struct(
                    int: 5,
                    string: "6"
                ),
                arrayOfInt: [
                    7,
                    8
                ],
                arrayOfStructure: [
                    Struct(
                        int: 9,
                        string: "10"
                    ),
                    Struct(
                        int: 11,
                        string: "12"
                    )
                ],
                optionalArrayOfInt: [
                    13
                ],
                optionalArrayOfStructure: [
                    Struct(
                        int: 14,
                        string: "15"
                    )
                ],
                dictionaryPrimitiveToPrimitive: [
                    16: 17
                ],
                dictionaryPrimitiveToStructure: [
                    18: Struct(
                        int: 19,
                        string: "20"
                    )
                ],
                dictionaryStructureToPrimitive: [
                    Struct(
                        int: 21,
                        string: "22"
                    ): 23
                ],
                dictionaryStructureToStructure: [
                    Struct(
                        int: 24,
                        string: "25"
                    ): Struct(
                        int: 26,
                        string: "27"
                    )
                ],
                optionalDictionaryPrimitiveToPrimitive: [
                    28: 29
                ],
                optionalDictionaryPrimitiveToStructure: [
                    30: Struct(
                        int: 31,
                        string: "32"
                    )
                ],
                optionalDictionaryStructureToPrimitive: [
                    Struct(
                        int: 33,
                        string: "34"
                    ): 35
                ],
                optionalDictionaryStructureToStructure: [
                    Struct(
                        int: 36,
                        string: "37"
                    ): Struct(
                        int: 38,
                        string: "39"
                    )
                ]
            )
            """
        )
    }
}
