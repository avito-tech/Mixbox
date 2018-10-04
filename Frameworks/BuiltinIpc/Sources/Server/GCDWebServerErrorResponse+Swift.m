#import "GCDWebServerErrorResponse+Swift.h"

@implementation GCDWebServerErrorResponse (Swift)

- (instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text {
    return [self initWithClientError:code message:@"%@", text];
}

- (instancetype)initWithServerError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text {
    return [self initWithServerError:code message:@"%@", text];
}

@end
