import MixboxGenerators

extension GeneratorFacadeTests {
    // To check how generators work with final classes
    final class FinalClass: BaseClass, Equatable, InitializableWithFields {
        let int: Int
        let string: String
        
        let structure: Structure
        let optionalInt: Int?
        let optionalStructure: Structure?
        
        let arrayOfInt: [Int]
        let arrayOfStructure: [Structure]
        let optionalArrayOfInt: [Int]?
        let optionalArrayOfStructure: [Structure]?
        
        let dictionaryPrimitiveToPrimitive: [Int: Int]
        let dictionaryPrimitiveToStructure: [Int: Structure]
        let dictionaryStructureToPrimitive: [Structure: Int]
        let dictionaryStructureToStructure: [Structure: Structure]
        let optionalDictionaryPrimitiveToPrimitive: [Int: Int]?
        let optionalDictionaryPrimitiveToStructure: [Int: Structure]?
        let optionalDictionaryStructureToPrimitive: [Structure: Int]?
        let optionalDictionaryStructureToStructure: [Structure: Structure]?
        
        // Example of an ordinary constructor.
        // Is not required in a real application for generators to work.
        // It is used in these tests.
        init(
            int: Int,
            string: String,
            structure: Structure,
            optionalInt: Int?,
            optionalStructure: Structure?,
            arrayOfInt: [Int],
            arrayOfStructure: [Structure],
            optionalArrayOfInt: [Int]?,
            optionalArrayOfStructure: [Structure]?,
            dictionaryPrimitiveToPrimitive: [Int: Int],
            dictionaryPrimitiveToStructure: [Int: Structure],
            dictionaryStructureToPrimitive: [Structure: Int],
            dictionaryStructureToStructure: [Structure: Structure],
            optionalDictionaryPrimitiveToPrimitive: [Int: Int]?,
            optionalDictionaryPrimitiveToStructure: [Int: Structure]?,
            optionalDictionaryStructureToPrimitive: [Structure: Int]?,
            optionalDictionaryStructureToStructure: [Structure: Structure]?,
            baseClassField: Int)
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
        
        // `InitializableWithFields`
        init(fields: Fields<FinalClass>) throws {
            int = try fields.int.get()
            string = try fields.string.get()
            structure = try fields.structure.get()
            optionalInt = try fields.optionalInt.get()
            optionalStructure = try fields.optionalStructure.get()
            arrayOfInt = try fields.arrayOfInt.get()
            arrayOfStructure = try fields.arrayOfStructure.get()
            optionalArrayOfInt = try fields.optionalArrayOfInt.get()
            optionalArrayOfStructure = try fields.optionalArrayOfStructure.get()
            dictionaryPrimitiveToPrimitive = try fields.dictionaryPrimitiveToPrimitive.get()
            dictionaryPrimitiveToStructure = try fields.dictionaryPrimitiveToStructure.get()
            dictionaryStructureToPrimitive = try fields.dictionaryStructureToPrimitive.get()
            dictionaryStructureToStructure = try fields.dictionaryStructureToStructure.get()
            optionalDictionaryPrimitiveToPrimitive = try fields.optionalDictionaryPrimitiveToPrimitive.get()
            optionalDictionaryPrimitiveToStructure = try fields.optionalDictionaryPrimitiveToStructure.get()
            optionalDictionaryStructureToPrimitive = try fields.optionalDictionaryStructureToPrimitive.get()
            optionalDictionaryStructureToStructure = try fields.optionalDictionaryStructureToStructure.get()
            
            try super.init(fields: fields)
        }
        
        static func ==(lhs: FinalClass, rhs: FinalClass) -> Bool {
            return lhs.int == rhs.int
                && lhs.string == rhs.string
                && lhs.structure == rhs.structure
                && lhs.optionalInt == rhs.optionalInt
                && lhs.optionalStructure == rhs.optionalStructure
                && lhs.arrayOfInt == rhs.arrayOfInt
                && lhs.arrayOfStructure == rhs.arrayOfStructure
                && lhs.optionalArrayOfInt == rhs.optionalArrayOfInt
                && lhs.optionalArrayOfStructure == rhs.optionalArrayOfStructure
                && lhs.dictionaryPrimitiveToPrimitive == rhs.dictionaryPrimitiveToPrimitive
                && lhs.dictionaryPrimitiveToStructure == rhs.dictionaryPrimitiveToStructure
                && lhs.dictionaryStructureToPrimitive == rhs.dictionaryStructureToPrimitive
                && lhs.dictionaryStructureToStructure == rhs.dictionaryStructureToStructure
                && lhs.optionalDictionaryPrimitiveToPrimitive == rhs.optionalDictionaryPrimitiveToPrimitive
                && lhs.optionalDictionaryPrimitiveToStructure == rhs.optionalDictionaryPrimitiveToStructure
                && lhs.optionalDictionaryStructureToPrimitive == rhs.optionalDictionaryStructureToPrimitive
                && lhs.optionalDictionaryStructureToStructure == rhs.optionalDictionaryStructureToStructure
                && lhs.baseClassField == rhs.baseClassField
        }
    }

    // To check how generators work with non-final classes
    class BaseClass: RepresentableByFields {
        let baseClassField: Int
        
        // Example of an ordinary constructor.
        // Is not required in a real application for generators to work.
        // It is used in these tests.
        init(baseClassField: Int) {
            self.baseClassField = baseClassField
        }
        
        // Constructor to reuse in classes that are `InitializableWithFields`.
        init<T: BaseClass>(fields: Fields<T>) throws {
            baseClassField = try fields.baseClassField.get()
        }
    }

    // To check how generators work with structs
    struct Structure: Hashable, InitializableWithFields {
        let int: Int
        let string: String
        
        // Example of an ordinary constructor.
        // Is not required in a real application for generators to work.
        // It is used in these tests.
        init(
            int: Int,
            string: String)
        {
            self.int = int
            self.string = string
        }
        
        // `InitializableWithFields`
        init(fields: Fields<Structure>) throws {
            int = try fields.int.get()
            string = try fields.string.get()
        }
    }
}
