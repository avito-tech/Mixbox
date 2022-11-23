#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (ObjCInterfacesForFakeCells)

- (BOOL)_isHiddenForReuse;
- (BOOL)_setHiddenForReuse:(BOOL)isHiddenForReuse;

@end

@interface UICollectionView (ObjCInterfacesForFakeCells)

- (void)_reuseCell:(UICollectionViewCell *)cell;

@end

#endif
