#if __IPHONE_OS_VERSION_MAX_ALLOWED < 120200

#import "Xcode_10_1_Xcode_10_0_EventGeneratorObjC.h"

// Xcode 10.1
#import "Xcode_10_1_XCSynthesizedEventRecord.h"
#import "Xcode_10_1_XCEventGenerator.h"
#import "Xcode_10_1_XCUIApplication.h"
#import "Xcode_10_1_XCUIElement.h"

// Xcode 10.0
#import "Xcode_10_0_XCSynthesizedEventRecord.h"
#import "Xcode_10_0_XCEventGenerator.h"
#import "Xcode_10_0_XCUIApplication.h"
#import "Xcode_10_0_XCUIElement.h"

typedef void (^EventGeneratorCompletion)(XCSynthesizedEventRecord *, NSError *);
typedef double (^ActionBlock)(XCEventGenerator *, EventGeneratorCompletion);

@implementation Xcode_10_1_Xcode_10_0_EventGeneratorObjC

- (void)pressAndDragFromPoint:(struct CGPoint)from
                           to:(struct CGPoint)to
                     duration:(double)duration
                     velocity:(double)velocity
                  application:(nonnull XCUIApplication *)application
{
    NSString *actionName = [NSString stringWithFormat:@"Press %@ for %@s and drag to %@ with velocity %@",
                            @(from),
                            @(duration),
                            @(to),
                            @(velocity)];
    
    [self performActionWithName:actionName application:application actionBlock:^double(XCEventGenerator *generator, EventGeneratorCompletion completion) {
        // Interesting fact: the method returns duration of the event + 30 seconds.
        return [generator pressAtPoint:from
                    forDuration:duration
                    liftAtPoint:to
                       velocity:velocity
                    orientation:[application interfaceOrientation]
                           name:actionName
                        handler:^(XCSynthesizedEventRecord *record, NSError *error) {
                            completion(record, error);
                        }];
    }];
}

- (void)performActionWithName:(NSString *)actionName
                  application:(XCUIApplication *)application
                  actionBlock:(ActionBlock)actionBlock
{
    [application _waitForQuiescence];
    [application _dispatchEvent:actionName block:^double(XCElementSnapshot *snapshot, XCEventGeneratorHandler handler) {
        return actionBlock([XCEventGenerator sharedGenerator], ^(XCSynthesizedEventRecord *record, NSError *error) {
            handler(record, error);
        });
    }];
}

@end

#endif
