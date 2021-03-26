#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120200

#import "Xcode_10_2_Xcode_11_0_EventGeneratorObjC.h"

@import MixboxUiTestsFoundation;
@import MixboxTestsFoundation;

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
@implementation Xcode_10_2_Xcode_11_0_EventGeneratorObjC

- (void)pressAndDragFromPoint:(struct CGPoint)from
                           to:(struct CGPoint)to
                     duration:(double)pressDuration
                     velocity:(double)velocity
                cancelInertia:(BOOL)cancelInertia
                  application:(nonnull XCUIApplication *)application
{
//    NSString *actionName = [NSString stringWithFormat:@"Press %@ for %@s and drag to %@ with velocity %@",
//                            @(from),
//                            @(pressDuration),
//                            @(to),
//                            @(velocity)];
//
//    [application _dispatchEvent:actionName eventBuilder:^XCSynthesizedEventRecord *(XCElementSnapshot *snapshot){
//        // Source:
//        //
//        // float _XCUIPressHoldAndDragEvent(int arg0) {
//        //     ...
//        //     rax = [XCSynthesizedEventRecord alloc];
//        //     rcx = arg0;
//        //     r14 = [rax initWithName:@"press, hold, and drag" interfaceOrientation:rcx];
//        //     rax = [XCPointerEventPath alloc];
//        //     ...
//        //     rax = [rax initForTouchAtPoint:rdx offset:rcx];
//        //     ...
//        //     if (xmm2 > 0x0) {
//        //         ...
//        //         [rbx moveToPoint:@"press, hold, and drag" atOffset:rcx];
//        //     }
//        //     ...
//        //     [rbx moveToPoint:@"press, hold, and drag" atOffset:rcx];
//        //     ...
//        //     [rbx liftUpAtOffset:@"press, hold, and drag", rcx];
//        //     [r14 addPointerEventPath:rbx, rcx];
//        //     [rbx release];
//        //     [r14 autorelease];
//        //     return xmm0;
//        // }
//
//        XCSynthesizedEventRecord *record = [[XCSynthesizedEventRecord alloc]
//                                            initWithName:actionName
//                                            interfaceOrientation:[application interfaceOrientation]];
//
//        // NOTE: Offset means offset in time, not in space.
//        XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:from offset:0];
//
//        if (pressDuration > 0) {
//            [path moveToPoint:from atOffset:pressDuration];
//        }
//
//        if (cancelInertia) {
//            // Insert touches and the end of gestures to slow swipe.
//            // This will result in cancelling inertia of scroll view.
//            //
//            // The ideal solution is to make Swift wrapper for XCTest touches and
//            // reuse code for canceling inertia from GrayBox tests (see `cancelInertia`).
//            // If we reuse code, we will achieve same behavior in both kinds of tests and it will
//            // enable us to remove ElementSimpleGestures and implement customization of touches.
//
//            NSTimeInterval slowingDuration = 0.5;
//            int numberOfSlowingTouches = 15;
//            CGFloat slowingStartPointRatio = 0.95;
//            CGFloat slowingEndPointRatio = 1;
//
//            CGVector touchVector = CGVectorMake(to.x - from.x, to.y - from.y);
//
//            // Delta for slow touches
//            CGFloat timeDelta = slowingDuration / (NSTimeInterval)numberOfSlowingTouches;
//            CGFloat relativeCoordinateDelta = (slowingEndPointRatio - slowingStartPointRatio) / (CGFloat)numberOfSlowingTouches;
//            CGVector coordinateDelta = CGVectorMake(
//                                                    touchVector.dx * relativeCoordinateDelta,
//                                                    touchVector.dy * relativeCoordinateDelta
//                                                    );
//
//            // Initial values
//            CGPoint initialCoordinate = CGPointMake(
//                                                       from.x + touchVector.dx * slowingStartPointRatio,
//                                                       from.y + touchVector.dy * slowingStartPointRatio
//                                                     );
//            CGFloat initialOffset = pressDuration + duration(distance(from, to), velocity) * slowingStartPointRatio;
//
//            // First touch with given speed at the point where slow touches should began:
//            [path moveToPoint:initialCoordinate atOffset:initialOffset];
//
//            // Slow touches with slow speed:
//            for (int i = 1; i <= numberOfSlowingTouches; i++) {
//                CGPoint currentCoordinate = CGPointMake(
//                                                        initialCoordinate.x + coordinateDelta.dx * (CGFloat)i,
//                                                        initialCoordinate.y + coordinateDelta.dy * (CGFloat)i
//                                                        );
//
//                CGFloat offset = initialOffset + timeDelta * (NSTimeInterval)i;
//
//                [path moveToPoint:currentCoordinate atOffset:offset];
//            }
//
//        } else {
//            CGFloat finalOffset = pressDuration + duration(distance(from, to), velocity);
//
//            [path moveToPoint:to atOffset:finalOffset];
//            [path liftUpAtOffset:finalOffset];
//        }
//
//
//        [record addPointerEventPath:path];
        
//        return NULL;
//    }];
}

@end

#endif
