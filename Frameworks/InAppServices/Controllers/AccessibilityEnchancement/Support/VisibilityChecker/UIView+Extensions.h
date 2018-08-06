@interface UIView (GREYAdditions)

/**
 *  Restores the opacity of this view and it's super views if they were made opaque by calling
 *  -[UIView grey_recursivelyMakeOpaque]. If -[UIView grey_recursivelyMakeOpaque] was not
 *  called before, then this method will perform a no-op on each of the view's superviews.
 */
- (void)grey_restoreOpacity;

/**
 * Quick check to see if a view meets the basic criteria for visibility:
 *    1) Not hidden
 *    2) Visible with a minimum alpha
 *    3) Valid accessibility frame.
 *
 *  Also checks to if a view is not a subview of another view or window that has a
 *  translucent alpha value or is hidden.
 */
- (BOOL)grey_isVisible;

/**
 *  Makes this view and all its super view opaque. Successive calls to this method will replace
 *  the previously stored alpha value, causing any saved value to be lost.
 *
 *  @remark Each invocation will save the current alpha value which can be restored by calling
 *          -[UIView grey_restoreOpacity]
 */
- (void)grey_recursivelyMakeOpaque;

/**
 *  Makes sure that subview @c view is always on top, even if other subviews are added in front of
 *  it. Also keeps the @c view's frame fixed to the current value so parent can't change it.
 *
 *  @param view The view to keep as the top-most fixed subview.
 */
- (void)grey_keepSubviewOnTopAndFrameFixed:(UIView *)view;

@end
