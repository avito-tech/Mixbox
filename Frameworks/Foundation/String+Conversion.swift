#if MIXBOX_ENABLE_IN_APP_SERVICES

extension String {
    public func mb_toInt() -> Int? {
        return Int(self)
    }
    
    public func mb_toDouble() -> Double? {
        return Double(self)
    }
}

#endif
