public enum SnapshotsComparatorType {
    // Per pixel comparison will fail your assertion if a single pixel is different.
    case perPixel
    
    // Hash comparison is tolerant to small changes in UI, it reduces images to
    // 64-bit fourier-transformed hashes and compares bits.
    //
    // The `tolerance` is a maximum number of different bits.
    //
    // The math under hash calculation is quite mindblowing. Do not try to understand it.
    // Use `.dHash(10)` for screenshots. Or just pick up other value via trial & error.
    //
    // Edit: try `pHash`, it wasn't tested much, but it's better.
    case aHash(tolerance: UInt8)
    case dHash(tolerance: UInt8)
    case pHash(tolerance: UInt8)
}
