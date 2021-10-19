//
// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// -----
//
// Exposes interfaces, structs and methods that are otherwise private.
//
// Copypasted from: https://github.com/google/EarlGrey/blob/87ffa7ac2517cc8931e4e6ba11714961cbac6dd7/EarlGrey/Common/GREYAppleInternals.h

#import <UIKit/UIKit.h>

@interface UIWindow (AppleInternals)
- (id)firstResponder;
@end

@interface UIViewController (AppleInternals)
- (void)viewWillMoveToWindow:(id)window;
- (void)viewDidMoveToWindow:(id)window shouldAppearOrDisappear:(BOOL)arg;
@end

/**
 *  A private class that represents backboard services accelerometer.
 */
@interface BKSAccelerometer : NSObject
/**
 *  Enable or disable accelerometer events.
 */
@property(nonatomic) BOOL accelerometerEventsEnabled;
@end

/**
 *  A private class that represents motion related events. This is sent to UIApplication whenever a
 *  motion occurs.
 */
@interface UIMotionEvent : NSObject {
    // The motion accelerometer of the event.
    BKSAccelerometer *_motionAccelerometer;
}
@end

@interface UIApplication (AppleInternals)
- (BOOL)_isSpringBoardShowingAnAlert;
/**
 *  Changes the main runloop to run in the specified mode, pushing it to the top of the stack of
 *  current modes.
 */
- (void)pushRunLoopMode:(NSString *)mode;
/**
 *  Changes the main runloop to run in the specified mode, pushing it to the top of the stack of
 *  current modes.
 */
- (void)pushRunLoopMode:(NSString *)mode requester:(id)requester;
/**
 *  Pops topmost mode from the runloop mode stack.
 */
- (void)popRunLoopMode:(NSString *)mode;
/**
 *  Pops topmost mode from the runloop mode stack.
 */
- (void)popRunLoopMode:(NSString *)mode requester:(id)requester;

/**
 *  Sends a motion began event for the specified subtype.
 */
- (void)_sendMotionBegan:(UIEventSubtype)subtype;

/**
 *  Sends a motion ended event for the specified subtype.
 */
- (void)_sendMotionEnded:(UIEventSubtype)subtype;
@end

@interface UIScrollView (AppleInternals)
/**
 *  Called when user finishes scrolling the content. @c deceleration is @c YES if scrolling movement
 *  will continue, but decelerate, after user stopped dragging the content. If @c deceleration is
 *  @c NO, scrolling stops immediately.
 *
 *  @param deceleration Indicating if scrollview was experiencing deceleration.
 */
- (void)_scrollViewDidEndDraggingWithDeceleration:(BOOL)deceleration;

/**
 *  Called when user is about to begin scrolling the content.
 */
- (void)_scrollViewWillBeginDragging;

/**
 *  Called when scrolling of content has finished, if content continued scrolling with deceleration
 *  after user stopped dragging it. @c notify determines whether UIScrollViewDelegate will be
 *  notified that scrolling has finished.
 *
 *  @param notify An indicator specifiying if scrolling has finished.
 */
- (void)_stopScrollDecelerationNotify:(BOOL)notify;
@end

@interface UIDevice (AppleInternals)
- (void)setOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated;
@end

@interface UIKeyboardTaskQueue
/**
 *  Completes all pending or ongoing tasks in the task queue before returning. Must be called from
 *  the main thread.
 */
- (void)waitUntilAllTasksAreFinished;
@end

@interface UIAccessibilityTextFieldElement

/**
 *  @return The UITextField that contains the accessibility text field element.
 */
-(UITextField *)textField;

@end
