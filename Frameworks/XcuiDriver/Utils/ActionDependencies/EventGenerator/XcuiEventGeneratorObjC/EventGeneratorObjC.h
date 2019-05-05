#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@protocol EventGeneratorObjC <NSObject>

- (void)pressAndDragFromPoint:(struct CGPoint)from
                           to:(struct CGPoint)to
                     duration:(double)duration
                     velocity:(double)velocity
                  application:(nonnull XCUIApplication *)application;

@end
