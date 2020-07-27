#if MIXBOX_ENABLE_IN_APP_SERVICES

extension CGSize {
    func rounded() -> IntSize {
        return IntSize(
            width: Int(width.rounded()),
            height: Int(height.rounded())
        )
    }
}

#endif
