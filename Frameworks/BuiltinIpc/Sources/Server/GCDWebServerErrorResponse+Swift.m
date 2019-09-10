#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "GCDWebServerErrorResponse+Swift.h"

@implementation GCDWebServerErrorResponse (Swift)

- (nullable instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text {
    return [self initWithClientError:code message:@"%@", text];
}

- (nullable instancetype)initWithServerError:(GCDWebServerServerErrorHTTPStatusCode)code text:(nonnull NSString *)text {
    return [self initWithServerError:code message:@"%@", text];
}

@end

#endif
