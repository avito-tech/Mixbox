#if MIXBOX_ENABLE_IN_APP_SERVICES

extension CGPoint {
    func rounded() -> IntPoint {
        return IntPoint(
            x: Int(x.rounded()),
            y: Int(y.rounded())
        )
    }
}

#endif
