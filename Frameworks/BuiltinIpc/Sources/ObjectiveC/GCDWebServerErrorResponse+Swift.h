#if SWIFT_PACKAGE
@import GCDWebServer;
#elif
#import <GCDWebServer/GCDWebServerErrorResponse.h>
#endif
@interface GCDWebServerErrorResponse (Swift)

- (nullable instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text;
- (nullable instancetype)initWithServerError:(GCDWebServerServerErrorHTTPStatusCode)code text:(nonnull NSString *)text;

@end


