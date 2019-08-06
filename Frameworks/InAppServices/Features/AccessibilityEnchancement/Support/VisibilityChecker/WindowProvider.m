#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "WindowProvider.h"

@implementation WindowProvider

+ (NSArray *)allWindows {
    UIApplication *sharedApp = UIApplication.sharedApplication;
    NSMutableOrderedSet *windows = [[NSMutableOrderedSet alloc] init];
    if (sharedApp.windows) {
        [windows addObjectsFromArray:sharedApp.windows];
    }
    
    if ([sharedApp.delegate respondsToSelector:@selector(window)] && sharedApp.delegate.window) {
        [windows addObject:sharedApp.delegate.window];
    }
    
    if (sharedApp.keyWindow) {
        [windows addObject:sharedApp.keyWindow];
    }
    
    // BOOL includeStatusBarWindow = NO;
    // if (includeStatusBarWindow && sharedApp.statusBarWindow) {
    //     [windows addObject:sharedApp.statusBarWindow];
    // }
    
    // After sorting, reverse the windows because they need to appear from top-most to bottom-most.
    return [[windows sortedArrayWithOptions:NSSortStable
                            usingComparator:^NSComparisonResult (id obj1, id obj2) {
                                if ([obj1 windowLevel] < [obj2 windowLevel]) {
                                    return -1;
                                } else if ([obj1 windowLevel] == [obj2 windowLevel]) {
                                    return 0;
                                } else {
                                    return 1;
                                }
                            }] reverseObjectEnumerator].allObjects;
}

@end

#endif
