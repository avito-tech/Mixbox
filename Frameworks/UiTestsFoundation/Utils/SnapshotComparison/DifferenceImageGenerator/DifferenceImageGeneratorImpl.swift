public final class DifferenceImageGeneratorImpl: DifferenceImageGenerator {
    public init() {
    }
    
    public func differenceImage(actualImage: UIImage, expectedImage: UIImage) -> UIImage? {
        let imageRect = CGRect(
            x: 0,
            y: 0,
            width: max(actualImage.size.width, expectedImage.size.width),
            height: max(actualImage.size.height, expectedImage.size.height)
        )
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, true, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        actualImage.draw(in: imageRect)
        
        context.setAlpha(0.5)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        expectedImage.draw(in: imageRect)
        
        context.setBlendMode(.difference)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(imageRect)
        
        context.endTransparencyLayer()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
