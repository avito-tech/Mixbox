#import <GCDWebServer/GCDWebServerErrorResponse.h>

@interface GCDWebServerErrorResponse (Swift)

- (instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text;
- (instancetype)initWithServerError:(GCDWebServerServerErrorHTTPStatusCode)code text:(nonnull NSString *)text;

@end
