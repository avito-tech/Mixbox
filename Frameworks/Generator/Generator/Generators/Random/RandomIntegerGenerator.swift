import MixboxFoundation

public final class RandomIntegerGenerator<T: FixedWidthInteger>: Generator<T> {
    public init(randomNumberProvider: RandomNumberProvider, сlosedRange: ClosedRange<T> = T.min...T.max) {
        if сlosedRange == T.min...T.max {
            super.init {
                T(
                    truncatingIfNeeded: randomNumberProvider.nextRandomNumber()
                )
            }
        } else if сlosedRange.upperBound < сlosedRange.lowerBound {
            super.init {
                throw ErrorString("upperBound < lowerBound in \(сlosedRange)")
            }
        } else {
            super.init {
                try RandomIntegerGenerator.generateAssumingSpecialCasesWereChecked(
                    randomNumberProvider: randomNumberProvider,
                    сlosedRange: сlosedRange
                )
            }
        }
    }
    
    public init(randomNumberProvider: RandomNumberProvider, range: Range<T>) {
        if range.upperBound <= range.lowerBound {
            super.init {
                throw ErrorString("upperBound <= lowerBound in \(range)")
            }
        } else {
            super.init {
                try RandomIntegerGenerator.generateAssumingSpecialCasesWereChecked(
                    randomNumberProvider: randomNumberProvider,
                    сlosedRange: try ClosedRange(
                        lowerBound: range.lowerBound,
                        upperBound: range.upperBound - 1
                    )
                )
            }
        }
    }
    
    private static func generateAssumingSpecialCasesWereChecked(
        randomNumberProvider: RandomNumberProvider,
        сlosedRange: ClosedRange<T>)
        throws
        -> T
    {
        let randomNumber = randomNumberProvider.nextRandomNumber()

        // Example for 3bit numbers:
        //
        //          0  1  2  3  4  5  6  7
        // Int3  : -4 -3 -2 -1 +0 +1 +2 +3
        // UInt3 : +4 +5 +6 +7 +0 +1 +2 +3
        //
        // This means that UInt3(7) has same binary representation as Int3(-1)
        //
        // We want to convert -1..<+2 range not to +7..<+2 but to 3..<6, clamp random number and then
        // convert it back to signed type (we don't want lower bound to be higher than upper).
        //
        let unsignedRange: ClosedRange<UInt64> = try сlosedRange.swapSignBit()
        
        let clampedNumber = randomNumber % (1 + unsignedRange.upperBound - unsignedRange.lowerBound) + unsignedRange.lowerBound
        
        let resultBits: UInt64 = clampedNumber.swapSignBit(asRepresentationOfType: T.self)
        
        return T(truncatingIfNeeded: resultBits)
    }
}

extension ClosedRange where Bound: FixedWidthInteger {
    fileprivate func swapSignBit() throws -> ClosedRange<UInt64> {
        return try ClosedRange<UInt64>(
            lowerBound: lowerBound.bits().swapSignBit(asRepresentationOfType: Bound.self),
            upperBound: upperBound.bits().swapSignBit(asRepresentationOfType: Bound.self)
        )
    }
    
    init(lowerBound: Bound, upperBound: Bound) throws {
        if lowerBound > upperBound {
            throw ErrorString("Internal error: lowerBound > upperBound (\(lowerBound) > \(upperBound))")
        }
        
        self.init(uncheckedBounds: (
            lower: lowerBound,
            upper: upperBound
        ))
    }
}

extension FixedWidthInteger {
    static func topBit() -> UInt64 {
        let topBitIndex = UInt64(MemoryLayout<Self>.size * 8 - 1) // E.g. 63 for Int64
        return 1 << topBitIndex
    }
    
    static func allBits() -> UInt64 {
        let nextAfterTopBitIndex = UInt64(MemoryLayout<Self>.size * 8) // E.g. 8 for Int8
        
        if nextAfterTopBitIndex >= 64 {
            return UInt64.max
        } else {
            return (1 << nextAfterTopBitIndex) - 1
        }
    }
    
    // Difference from UInt64(truncatingIfNeeded:):
    //
    // Int8(-1)   is 0b11111111
    // Int8(-128) is 0b10000000
    // Int8(1)    is 0b10000001
    //
    // UInt64(truncatingIfNeeded: Int8(-1))   is 0b11111111111111111111111111111111
    // UInt64(truncatingIfNeeded: Int8(-128)) is 0b11111111111111111111111110000000
    // UInt64(truncatingIfNeeded: Int8(1))    is 0b00000000000000000000000010000001
    //
    // Int8(-1).bits()                        is 0b11111111
    // Int8(-128).bits()                      is 0b10000000
    // Int8(1).bits()                         is 0b10000001
    //
    func bits() -> UInt64 {
        return UInt64(truncatingIfNeeded: self) & Self.allBits()
    }
}

extension UInt64 {
    func swapSignBit<T: FixedWidthInteger>(asRepresentationOfType type: T.Type) -> UInt64 {
        if T.isSigned {
            return self ^ T.topBit()
        } else {
            return self
        }
    }
}
