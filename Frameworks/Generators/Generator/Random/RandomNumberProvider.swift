#if MIXBOX_ENABLE_IN_APP_SERVICES

// Same as Swift's RandomNumberGenerator, but requires you to implement its methods
// instead of crashing with EXC_BAD_ACCESS if methods are not implemented.
//
// Example of issue:
//
// final class ClassWithTypo: RandomNumberGenerator {
//     func nExT() -> UInt64 { return 1 }
// }
// var numberGenerator: RandomNumberGenerator = ClassWithTypo()
// print(numberGenerator.next()) // Thread 1: EXC_BAD_ACCESS (code=2, address=0x7ffeebe4bff8)
//
// Also `nextRandomNumber` is more verbose and more unique than `next`.
//
public protocol RandomNumberProvider {
    func nextRandomNumber() -> UInt64
}

#endif
