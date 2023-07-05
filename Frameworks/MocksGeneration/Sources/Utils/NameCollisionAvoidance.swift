public final class NameCollisionAvoidance {
    public static func typeNameAvoidingCollisons(
        desiredName: String,
        takenNames: Set<String>)
        throws
        -> String
    {
        return try typeNameAvoidingCollisons(
            desiredName: desiredName,
            takenNames: takenNames,
            attempt: 0
        )
    }
    
    private static func typeNameAvoidingCollisons(
        desiredName: String,
        takenNames: Set<String>,
        attempt: Int)
        throws
        -> String
    {
        let maxAttempts = 100
        
        if attempt > maxAttempts {
            throw ErrorString("Unable to avoid name collision after \(attempt) attempts")
        }
        
        if takenNames.contains(desiredName) {
            return try typeNameAvoidingCollisons(
                desiredName: desiredName + determinsticRandomStrings[attempt % determinsticRandomStrings.count],
                takenNames: takenNames,
                attempt: attempt + 1
            )
        } else {
            return desiredName
        }
    }
    
    private static var determinsticRandomStrings: [String] {
        [
            "apggwNGy1a",
            "WcY2UCRXln",
            "vJbFri7odJ",
            "hgKBtZm3ha",
            "TGKuoqfXS5",
            "8r9FS3bi5B",
            "mHcek7gVNv",
            "tS8pdaJ0Rk",
            "uwyWmDEyYP",
            "VckWL54R2n"
        ]
    }
}
