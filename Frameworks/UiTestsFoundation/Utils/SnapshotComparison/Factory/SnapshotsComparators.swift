public enum SnapshotsComparatorType {
    // Per pixel comparison will fail your assertion if a single pixel is different.
    case perPixel
    
    // D-hash comparison is tolerant to small changes in UI, it reduces images to
    // 64-bit fourier-transformed hashes and compares bits.
    //
    // The `tolerance` is a maximum number of different bits.
    //
    // The math under DHASH calculation is quite mindblowing. Do not try to understand it.
    // Use `10` for screenshots. Or just pick up other value via trial & error.
    case dHash(tolerance: UInt8)
}
