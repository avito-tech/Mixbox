#if MIXBOX_ENABLE_IN_APP_SERVICES

struct IntSize {
    var width: Int
    var height: Int
    
    var area: Int {
        return width * height
    }
}

#endif
