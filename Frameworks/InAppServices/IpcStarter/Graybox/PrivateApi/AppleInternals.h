#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

/**
 *  Used for enabling accessibility on simulator and device.
 */
@interface AXBackBoardServer

/**
 *  Returns backboard server instance.
 */
+ (id)server;

/**
 *  Sets preference with @c key to @c value and raises @c notification.
 */
- (void)setAccessibilityPreferenceAsMobile:(CFStringRef)key
                                     value:(CFBooleanRef)value
                              notification:(CFStringRef)notification;

@end

/**
 *  Used for enabling accessibility on device.
 */
@interface XCAXClient_iOS

/**
 *  Singleton shared instance when initialized will try to background the current process.
 */
+ (id)sharedClient;

/**
 *  Programatically enable accessibility on both simulator and device.
 *  Blocks until accessibility is fully loaded.
 *
 *  @return ignored.
 */
- (bool)_loadAccessibility:(void **)unused;

@end

#endif
