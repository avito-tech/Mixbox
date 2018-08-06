import Foundation

#if TEST
    private var configureAsFakeCellKey = "A15CFCCB-3F84-42B5-8AAD-4E797ACAEA9A"
    
    extension UICollectionViewCell {
        // This will be called from the code that controls fake cells and that is responsible
        // for making offscreen cells visible in AX hierarchy.
        //
        // The cells in AX hiererchy should be as if they are not offscreen, so
        // they must have content as if they were displayed. So you need to
        // set this closure wherever you want (probably at the place it is created).
        //
        // The closure should setup the cell as if it is real cell in the app.
        //
        public var configureAsFakeCell: (() -> ())? {
            get {
                return objc_getAssociatedObject(self, &configureAsFakeCellKey) as? (() -> ())
            }
            set {
                objc_setAssociatedObject(
                    self,
                    &configureAsFakeCellKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
#endif
