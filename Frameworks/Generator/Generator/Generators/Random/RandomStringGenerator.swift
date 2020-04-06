public final class RandomStringGenerator: Generator<String> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            let characters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

            var string = ""
            let maxLength = 20
            let length = Int(truncatingIfNeeded: randomNumberProvider.nextRandomNumber() % UInt64(Int.max)) % maxLength
            for _ in 0..<length {
                let randomInt = Int(truncatingIfNeeded: randomNumberProvider.nextRandomNumber() % UInt64(Int.max))
                string.append(characters[randomInt % characters.count])
            }

            return string
        }
    }
}
