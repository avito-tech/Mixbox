#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public final class RandomStringGenerator: Generator<String> {
    public init(
        randomNumberProvider: RandomNumberProvider,
        lengthGenerator: Generator<Int>)
    {
        super.init {
            let characters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

            let length = try lengthGenerator.generate()
            var string = ""
            string.reserveCapacity(length)
            
            for _ in 0..<length {
                let characterId = Int(truncatingIfNeeded: randomNumberProvider.nextRandomNumber() % UInt64(characters.count))
                string.append(characters[characterId])
            }

            return string
        }
    }
}

#endif
