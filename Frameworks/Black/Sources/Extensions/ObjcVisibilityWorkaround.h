// When bridging Obj-C to Swift it Xcode ignores defines somehow
// so definitions are missing in public interface of module, this makes them
// visible inside current module. I mean, there are #ifdef there and no code
// is ouside #ifdef.
#import <MixboxSBTUITestTunnelCommon/MixboxSBTUITestTunnelCommon-umbrella.h>
