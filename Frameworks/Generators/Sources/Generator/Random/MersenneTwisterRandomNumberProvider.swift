#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

// A very popular algorithm of generating random numbers.
// See: https://en.wikipedia.org/wiki/Mersenne_Twister
//
public final class MersenneTwisterRandomNumberProvider: RandomNumberProvider {
    private let w: OverflowingUInt64 = 64
    private let n = 312
    private let m = 156
    private let r: OverflowingUInt64 = 31
    private let a: OverflowingUInt64 = 0xB5026F5AA96619E9
    private let u: OverflowingUInt64 = 29
    private let d: OverflowingUInt64 = 0x5555555555555555
    private let s: OverflowingUInt64 = 17
    private let b: OverflowingUInt64 = 0x71D67FFFEDA60000
    private let t: OverflowingUInt64 = 37
    private let c: OverflowingUInt64 = 0xFFF7EEE000000000
    private let l: OverflowingUInt64 = 43
    private let f: OverflowingUInt64 = 6364136223846793005
    
    private let lower_mask: OverflowingUInt64 = 0x7FFFFFFF
    private let upper_mask: OverflowingUInt64 = ~0x7FFFFFFF
    
    private var MT = [OverflowingUInt64]()
    private var index: Int
    
    public init(seed: UInt64) {
        index = n
        
        MT.reserveCapacity(n)
        MT.append(OverflowingUInt64(seed))
        
        for i in 1..<n {
            let value = (f * (MT[i - 1] ^ (MT[i - 1] >> (w - 2))) + OverflowingUInt64(i))
            MT.append(value)
        }
    }
    
    public func nextRandomNumber() -> UInt64 {
        if index >= n {
            twist()
        }
        
        var y: OverflowingUInt64 = MT[index]
        y = y ^ ((y >> u) & d)
        y = y ^ ((y << s) & b)
        y = y ^ ((y << t) & c)
        y = y ^ (y >> l)
        
        index += 1
        
        return y.value
    }
    
    private func twist() {
        for i in 0..<n {
            let x: OverflowingUInt64 = (MT[i] & upper_mask) + (MT[(i + 1) % n] & lower_mask)
            var xA: OverflowingUInt64 = x >> 1
            
            if x % 2 != 0 {
                xA = xA ^ a
            }
            
            MT[i] = MT[(i + m) % n] ^ xA
        }
        
        index = 0
    }
}

#endif
