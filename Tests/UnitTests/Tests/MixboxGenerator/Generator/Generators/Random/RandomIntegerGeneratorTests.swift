@testable import MixboxGenerators
import XCTest

final class RandomIntegerGeneratorTests: TestCase {
    func test___RandomIntegerGenerator___works___for_various_types() {
        check(signedType: Int64.self, unsignedType: UInt64.self)
        check(signedType: Int32.self, unsignedType: UInt32.self)
        check(signedType: Int16.self, unsignedType: UInt16.self)
        check(signedType: Int8.self, unsignedType: UInt8.self)
        check(signedType: Int.self, unsignedType: UInt.self)
    }
    
    func test___RandomIntegerGenerator___throws_proper_erros() {
        assertThrows(error: "upperBound <= lowerBound in 0..<0") {
            let generator = RandomIntegerGenerator<Int8>(
                randomNumberProvider: ConstantRandomNumberProvider(0),
                range: 0..<0
            )
            
            _ = try generator.generate()
        }
        
        assertThrows(error: "upperBound <= lowerBound in 0..<0") {
            let generator = RandomIntegerGenerator<Int8>(
                randomNumberProvider: ConstantRandomNumberProvider(0),
                range: 0..<0
            )
            
            _ = try generator.generate()
        }
    }
    
    func check<Signed, Unsigned>(signedType: Signed.Type, unsignedType: Unsigned.Type)
        where
        Signed: SignedInteger,
        Signed: FixedWidthInteger,
        Unsigned: UnsignedInteger,
        Unsigned: FixedWidthInteger
    {
        check___swapSignBit___works_properly(signedType: signedType, unsignedType: unsignedType)
        
        check_all_integers(type: signedType)
        check_all_integers(type: unsignedType)
        
        check___generate___works_properly___for_signed_integers(type: signedType)
    }
    
    func check_all_integers<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        check___generate___works_properly___for_simple_cases(type: type)
        check___generate___works_properly___for_zero_range(type: type)
        check___generate___works_properly___for_almost_maximal_range(type: type)
        check___generate___works_properly___for_maximal_range(type: type)
    }
    
    func check___generate___works_properly___for_simple_cases<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        assert(
            type: type,
            randomNumber: 0,
            range: 0..<100,
            leadsTo: 0
        )
        assert(
            type: type,
            randomNumber: 130,
            range: 0..<100,
            leadsTo: 30
        )
        assert(
            type: type,
            randomNumber: UInt64.max / 2,
            range: 0..<64,
            leadsTo: 63
        )
    }
    
    func check___generate___works_properly___for_zero_range<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        assert(
            type: type,
            randomNumber: 0,
            range: 0..<1,
            leadsTo: 0
        )
        assert(
            type: type,
            randomNumber: 42,
            range: 0..<1,
            leadsTo: 0
        )
        assert(
            type: type,
            randomNumber: UInt64.max,
            range: 0..<1,
            leadsTo: 0
        )
    }

    func check___generate___works_properly___for_almost_maximal_range<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        // Examples for hypothetical Int3 type (for simplicity):
        //
        // Index             :  0  1  2  3  4  5  6  7
        // UInt3.max         :                       7
        // UInt3.max/2       :           3
        //
        // Int3              : -4 -3 -2 -1 +0 +1 +2 +3
        // Int.min..<Int.max : \__________________/
        //
        // For example, if `randomNumber` is 0, and range is -4..<+2 then value -4 (aka Int3.min) from index 0 will be returned.
        // This is an example for the following check:
        assert(
            type: type,
            randomNumber: 0,
            range: T.min..<T.max,
            leadsTo: T.min
        )
        // Other checks:
        assert(
            type: type,
            randomNumber: UInt64.max, // Will overlap range by 1
            range: T.min..<T.max,
            leadsTo: T.min
        )
        assert(
            type: type,
            randomNumber: UInt64.max - 1, // The last index in range
            range: T.min..<T.max,
            leadsTo: T.max - 1 // The last value in range
        )
        
        if T.isSigned {
            assert(
                type: type,
                randomNumber: UInt64.max / 2, // See table from example
                range: T.min..<T.max,
                leadsTo: T(-1)
            )
        }
    }
    
    func check___generate___works_properly___for_maximal_range<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        assert(
            type: type,
            randomNumber: 0,
            range: T.min...T.max,
            leadsTo: T(truncatingIfNeeded: 0)
        )
        assert(
            type: type,
            randomNumber: UInt64.max,
            range: T.min...T.max,
            leadsTo: T(truncatingIfNeeded: UInt64.max)
        )
        assert(
            type: type,
            randomNumber: UInt64.max / 2,
            range: T.min...T.max,
            leadsTo: T(truncatingIfNeeded: UInt64.max / 2)
        )
        assert(
            type: type,
            randomNumber: 0,
            range: T.min...T.max,
            leadsTo: T(truncatingIfNeeded: 0)
        )
    }
    
    func check___generate___works_properly___for_signed_integers<T>(type: T.Type = T.self) where T: FixedWidthInteger, T: SignedInteger {
        // === SIMPLE NEGATIVE RANGES ===
        
        assert(
            type: type,
            randomNumber: 0,
            range: -1..<T.max,
            leadsTo: -1
        )
        assert(
            type: type,
            randomNumber: 1,
            range: -1..<T.max,
            leadsTo: 0
        )
        assert(
            type: type,
            randomNumber: 0,
            range: -10 ..< -9,
            leadsTo: -10
        )
    }
    
    func check___swapSignBit___works_properly<Signed, Unsigned>(signedType: Signed.Type, unsignedType: Unsigned.Type)
        where
        Signed: SignedInteger,
        Signed: FixedWidthInteger,
        Unsigned: UnsignedInteger,
        Unsigned: FixedWidthInteger
    {
        XCTAssertEqual(
            Signed(-1).swapSignBit(),
            UInt64(Unsigned.max / 2),
            "Types: \(Signed.self), \(Unsigned.self)"
        )
        
        check___swapSignBit___works_properly(type: signedType)
        check___swapSignBit___works_properly___for_signed_integers(type: signedType)
        
        check___swapSignBit___works_properly(type: unsignedType)
    }
    
    func check___swapSignBit___works_properly<T>(type: T.Type = T.self) where T: FixedWidthInteger {
        XCTAssertEqual(
            T.min.swapSignBit(),
            0,
            "Type: \(T.self)"
        )
        XCTAssertEqual(
            T.min.doubleSwapSignBit(),
            T.min,
            "Type: \(T.self)"
        )
    }
    
    func check___swapSignBit___works_properly___for_signed_integers<T>(type: T.Type = T.self) where T: FixedWidthInteger, T: SignedInteger {
        XCTAssertEqual(
            T(-1).doubleSwapSignBit(),
            T(-1),
            "Type: \(T.self)"
        )
    }
    
    private func assert<T: FixedWidthInteger>(
        type: T.Type,
        randomNumber: UInt64,
        range: Range<T>,
        leadsTo expectedResult: T,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assert(
            type: type,
            randomNumber: randomNumber,
            generator: RandomIntegerGenerator<T>(
                randomNumberProvider: ConstantRandomNumberProvider(randomNumber),
                range: range
            ),
            rangeDescription: "\(range)",
            expectedResult: expectedResult,
            file: file,
            line: line
        )
    }
    
    private func assert<T: FixedWidthInteger>(
        type: T.Type,
        randomNumber: UInt64,
        range: ClosedRange<T>,
        leadsTo expectedResult: T,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assert(
            type: type,
            randomNumber: randomNumber,
            generator: RandomIntegerGenerator<T>(
                randomNumberProvider: ConstantRandomNumberProvider(randomNumber),
                сlosedRange: range
            ),
            rangeDescription: "\(range)",
            expectedResult: expectedResult,
            file: file,
            line: line
        )
    }
    
    private func assert<T: FixedWidthInteger>(
        type: T.Type,
        randomNumber: UInt64,
        generator: RandomIntegerGenerator<T>,
        rangeDescription: String,
        expectedResult: T,
        file: StaticString,
        line: UInt)
    {
        do {
            XCTAssertEqual(
                try generator.generate(),
                expectedResult,
                "Type: \(T.self). Range: \(rangeDescription)",
                file: file,
                line: line
            )
        }
    }
}

extension FixedWidthInteger {
    fileprivate func swapSignBit() -> UInt64 {
        return self.bits().swapSignBit(asRepresentationOfType: Self.self)
    }
    
    fileprivate func doubleSwapSignBit() -> Self {
        let doubleSwapped = UInt64(truncatingIfNeeded: self)
            .swapSignBit(asRepresentationOfType: Self.self)
            .swapSignBit(asRepresentationOfType: Self.self)
        
        return Self(truncatingIfNeeded: doubleSwapped)
    }
}
