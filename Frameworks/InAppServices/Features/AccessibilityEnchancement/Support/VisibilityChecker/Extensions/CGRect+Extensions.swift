#if MIXBOX_ENABLE_IN_APP_SERVICES

extension CGRect {
    func mb_pointToPixel() -> CGRect {
        return mb_scaleAndTranslate(amount: UIScreen.main.scale)
    }
    
    func mb_pixelToPoint() -> CGRect {
        return mb_scaleAndTranslate(amount: 1 / UIScreen.main.scale)
    }
    
    func mb_scaleAndTranslate(amount: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x * amount,
            y: origin.y * amount,
            width: size.width * amount,
            height: size.height * amount
        )
    }
    
    func mb_integralInside() -> CGRect {
        var rectInPixels = self
        
        let newIntegralX = rectInPixels.minX.mb_ceil()
        
        // Adjust horizontal pixel boundary alignment.
        let newIntegralWidth = rectInPixels.maxX - newIntegralX
        
        rectInPixels.size.width = newIntegralWidth > 1.0
            ? newIntegralWidth.mb_floor()
            : (rectInPixels.size.width - 0.5).mb_ceil()   // rounded up when it's <1 and >0.5 per iOS
        
        rectInPixels.origin.x = newIntegralX
        
        // Adjust vertical pixel boundary alignment.
        let newIntegralY = rectInPixels.minY.mb_ceil()
        let newIntegralHeight = rectInPixels.maxY - newIntegralY
        
        rectInPixels.size.height = newIntegralHeight > 1.0
            ? newIntegralHeight.mb_floor()
            : (rectInPixels.size.height - 0.5).mb_ceil()  // rounded up when it's <1 and >=0.5 per iOS
        
        rectInPixels.origin.y = newIntegralY
        
        return rectInPixels
    }
    
    func rounded() -> IntRect {
        return IntRect(
            origin: origin.rounded(),
            size: size.rounded()
        )
    }
}

#endif
