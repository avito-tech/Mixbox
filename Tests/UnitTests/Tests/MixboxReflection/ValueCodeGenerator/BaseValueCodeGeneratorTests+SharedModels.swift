extension BaseValueCodeGeneratorTests {
    struct Struct: Hashable {
        let int: Int
        let string: String
    }

    class ClassWithManyFieldsBaseClass {
        let baseClassField: Int
        
        init(baseClassField: Int) {
            self.baseClassField = baseClassField
        }
    }

    final class ClassWithManyFields: ClassWithManyFieldsBaseClass {
        let int: Int
        let string: String
        
        let structure: Struct
        let optionalInt: Int?
        let optionalStructure: Struct?
        
        let arrayOfInt: [Int]
        let arrayOfStructure: [Struct]
        let optionalArrayOfInt: [Int]?
        let optionalArrayOfStructure: [Struct]?
        
        let dictionaryPrimitiveToPrimitive: [Int: Int]
        let dictionaryPrimitiveToStructure: [Int: Struct]
        let dictionaryStructureToPrimitive: [Struct: Int]
        let dictionaryStructureToStructure: [Struct: Struct]
        let optionalDictionaryPrimitiveToPrimitive: [Int: Int]?
        let optionalDictionaryPrimitiveToStructure: [Int: Struct]?
        let optionalDictionaryStructureToPrimitive: [Struct: Int]?
        let optionalDictionaryStructureToStructure: [Struct: Struct]?
        
        init(
            baseClassField: Int,
            int: Int,
            string: String,
            structure: Struct,
            optionalInt: Int?,
            optionalStructure: Struct?,
            arrayOfInt: [Int],
            arrayOfStructure: [Struct],
            optionalArrayOfInt: [Int]?,
            optionalArrayOfStructure: [Struct]?,
            dictionaryPrimitiveToPrimitive: [Int: Int],
            dictionaryPrimitiveToStructure: [Int: Struct],
            dictionaryStructureToPrimitive: [Struct: Int],
            dictionaryStructureToStructure: [Struct: Struct],
            optionalDictionaryPrimitiveToPrimitive: [Int: Int]?,
            optionalDictionaryPrimitiveToStructure: [Int: Struct]?,
            optionalDictionaryStructureToPrimitive: [Struct: Int]?,
            optionalDictionaryStructureToStructure: [Struct: Struct]?)
        {
            self.int = int
            self.string = string
            self.structure = structure
            self.optionalInt = optionalInt
            self.optionalStructure = optionalStructure
            self.arrayOfInt = arrayOfInt
            self.arrayOfStructure = arrayOfStructure
            self.optionalArrayOfInt = optionalArrayOfInt
            self.optionalArrayOfStructure = optionalArrayOfStructure
            self.dictionaryPrimitiveToPrimitive = dictionaryPrimitiveToPrimitive
            self.dictionaryPrimitiveToStructure = dictionaryPrimitiveToStructure
            self.dictionaryStructureToPrimitive = dictionaryStructureToPrimitive
            self.dictionaryStructureToStructure = dictionaryStructureToStructure
            self.optionalDictionaryPrimitiveToPrimitive = optionalDictionaryPrimitiveToPrimitive
            self.optionalDictionaryPrimitiveToStructure = optionalDictionaryPrimitiveToStructure
            self.optionalDictionaryStructureToPrimitive = optionalDictionaryStructureToPrimitive
            self.optionalDictionaryStructureToStructure = optionalDictionaryStructureToStructure
            
            super.init(baseClassField: baseClassField)
        }
    }

    enum Enum: CustomStringConvertible, CustomDebugStringConvertible {
        case no_associated_value
        case associated_value_without_label(Int)
        case associated_value_with_label(label: Int)
        case multiple_associated_values(Int, label: String, struct: Struct)
        
        var description: String {
            "it should not be used by MixboxReflection"
        }
        
        var debugDescription: String {
            "it should not be used by MixboxReflection"
        }
    }
}
