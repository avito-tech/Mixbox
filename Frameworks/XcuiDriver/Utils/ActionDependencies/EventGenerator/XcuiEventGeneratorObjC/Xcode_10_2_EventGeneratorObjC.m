#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120200

#import "Xcode_10_2_EventGeneratorObjC.h"

#import "Xcode10_2_XCSynthesizedEventRecord.h"
#import "Xcode10_2_XCUIApplication.h"
#import "Xcode10_2_XCUIElement.h"
#import "Xcode10_2_XCPointerEventPath.h"
#import "Xcode10_2_SharedHeader.h"

static CGFloat sqr(CGFloat x) {
    return x * x;
}

static CGFloat distance(struct CGPoint a, struct CGPoint b) {
    return sqrt(sqr(a.x - b.x) + sqr(a.y - b.y));
}

static CGFloat duration(CGFloat distance,  CGFloat velocity) {
    return distance / velocity;
}

// It seems that this implementation can work in Xcode 10.1 too.
// TODO: Try to share implementations after some time in production with Xcode 10.2.
//       Note that API will still be different (there is no _dispatchEvent:eventBuilder: in Xcode 10.1),
//       but some code can be shared.
@implementation Xcode_10_2_EventGeneratorObjC

- (void)pressAndDragFromPoint:(struct CGPoint)from
                           to:(struct CGPoint)to
                     duration:(double)pressDuration
                     velocity:(double)velocity
                  application:(nonnull XCUIApplication *)application
{
    NSString *actionName = [NSString stringWithFormat:@"Press %@ for %@s and drag to %@ with velocity %@",
                            @(from),
                            @(pressDuration),
                            @(to),
                            @(velocity)];
    
    [application _dispatchEvent:actionName eventBuilder:^XCSynthesizedEventRecord *(XCElementSnapshot *snapshot){
        // Source:
        //
        // float _XCUIPressHoldAndDragEvent(int arg0) {
        //     ...
        //     rax = [XCSynthesizedEventRecord alloc];
        //     rcx = arg0;
        //     r14 = [rax initWithName:@"press, hold, and drag" interfaceOrientation:rcx];
        //     rax = [XCPointerEventPath alloc];
        //     ...
        //     rax = [rax initForTouchAtPoint:rdx offset:rcx];
        //     ...
        //     if (xmm2 > 0x0) {
        //         ...
        //         [rbx moveToPoint:@"press, hold, and drag" atOffset:rcx];
        //     }
        //     ...
        //     [rbx moveToPoint:@"press, hold, and drag" atOffset:rcx];
        //     ...
        //     [rbx liftUpAtOffset:@"press, hold, and drag", rcx];
        //     [r14 addPointerEventPath:rbx, rcx];
        //     [rbx release];
        //     [r14 autorelease];
        //     return xmm0;
        // }
        
        XCSynthesizedEventRecord *record = [[XCSynthesizedEventRecord alloc]
                                            initWithName:actionName
                                            interfaceOrientation:[application interfaceOrientation]];
        
        XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:from offset:0];
        
        if (pressDuration > 0) {
            [path moveToPoint:from atOffset:pressDuration];
        }
        
        CGFloat liftUpOffset = pressDuration + duration(distance(from, to), velocity);
        [path moveToPoint:to atOffset:liftUpOffset];
        [path liftUpAtOffset:liftUpOffset];
        
        [record addPointerEventPath:path];
        
        return record;
    }];
}

@end

#endif
