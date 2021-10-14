//
//  OSAHashTests.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 11/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSImageHashingBaseTest.h"

@interface OSAHashTests : OSImageHashingBaseTest

@end

@implementation OSAHashTests

- (void)testAHashOnEqualImages
{
    [self assertHashDistanceEqual:@"blur_architecture1.bmp"
                rightHandImageName:@"blur_architecture1.bmp"
        withImageHashingProviderId:OSImageHashingProviderAHash];
}

- (void)testAHashOnSimilarImages
{
    [self assertHashImagesSimilar:@"blur_architecture1.bmp"
                rightHandImageName:@"compr_architecture1.jpg"
        withImageHashingProviderId:OSImageHashingProviderAHash];
}

- (void)testDataHashingWithMalformedInput
{
    NSData *data = [NSMutableData dataWithLength:1024 * 1024];
    OSHashType result = [self.aHash hashImageData:data];
    XCTAssertEqual(OSHashTypeError, result);
}

- (void)testAHashValuesRegression
{
    [self assertHashOfImageWithName:@"blur_architecture1.bmp"
                          isEqualTo:-8608191228601917537
                        forProvider:OSImageHashingProviderAHash];
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"15"]) {
        [self assertHashOfImageWithName:@"compr_architecture1.jpg"
                              isEqualTo:-8608191228601919553
                            forProvider:OSImageHashingProviderAHash];
    } else {
        [self assertHashOfImageWithName:@"compr_architecture1.jpg"
                              isEqualTo:-8608472703578630209
                            forProvider:OSImageHashingProviderAHash];
    }
    [self assertHashOfImageWithName:@"blur_bamarket115.bmp"
                          isEqualTo:-16954737706286081
                        forProvider:OSImageHashingProviderAHash];
}

@end
