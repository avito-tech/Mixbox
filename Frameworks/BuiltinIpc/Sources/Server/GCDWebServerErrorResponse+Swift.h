#if defined(MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC) && defined(MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC)
#error "BuiltinIpc is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC))
// The compilation is disabled
#else

#import <GCDWebServer/GCDWebServerErrorResponse.h>

@interface GCDWebServerErrorResponse (Swift)

- (nullable instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text;
- (nullable instancetype)initWithServerError:(GCDWebServerServerErrorHTTPStatusCode)code text:(nonnull NSString *)text;

@end

#endif
