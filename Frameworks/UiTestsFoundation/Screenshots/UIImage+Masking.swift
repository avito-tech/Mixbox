import UIKit

public extension UIImage {

    var statusBarFrame: CGRect {
        let systemStatusBarFrame = UIApplication.shared.statusBarFrame
       
        // Берем ширину статуc бара из картинки так как
        // в тестах UIApplication.shared.statusBarFrame
        // возвращает ширину в 320 пунктов для айфонов любой диагонали
        
        return CGRect(
            x: systemStatusBarFrame.origin.x,
            y: systemStatusBarFrame.origin.y,
            width: size.width,
            height: systemStatusBarFrame.height
        )
    }
    
    func byMaskingFrames(_ framesToMask: [CGRect]) -> UIImage {
        let imageSize = self.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(at: .zero)
        
        framesToMask.forEach { frame in
            context?.setFillColor(UIColor.white.cgColor)
            context?.addRect(frame)
            context?.drawPath(using: .fill)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
