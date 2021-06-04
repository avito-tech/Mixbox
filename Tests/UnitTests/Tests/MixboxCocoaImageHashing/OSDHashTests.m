//
//  OSDHashTests.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSImageHashingBaseTest.h"

@interface OSDHashTests : OSImageHashingBaseTest

@end

@implementation OSDHashTests

- (void)testDHashOnEqualImages
{
    [self assertHashDistanceEqual:@"blur_architecture1.bmp"
                rightHandImageName:@"blur_architecture1.bmp"
        withImageHashingProviderId:OSImageHashingProviderDHash];
}

- (void)testDHashOnSimilarImages
{
    [self assertHashImagesSimilar:@"blur_architecture1.bmp"
                rightHandImageName:@"compr_architecture1.jpg"
        withImageHashingProviderId:OSImageHashingProviderDHash];
}

- (void)testDHashOnDifferingImages
{
    [self assertHashImagesNotSimilar:@"blur_architecture1.bmp"
                  rightHandImageName:@"blur_bamarket115.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
}

- (void)testDHashOnDifferingImagesRegression
{
    [self assertHashImagesNotSimilar:@"blur_Tower-Bridge-at-night--London--England_web.bmp"
                  rightHandImageName:@"blur_architecture1.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
    [self assertHashImagesNotSimilar:@"blur_Hhirst_BGE.bmp"
                  rightHandImageName:@"blur_latrobe.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
    [self assertHashImagesNotSimilar:@"blur_Tower-Bridge-at-night--London--England_web.bmp"
                  rightHandImageName:@"blur_targetjasperjohns.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
    [self assertHashImagesNotSimilar:@"blur_damien_hirst_does_fashion_week.bmp"
                  rightHandImageName:@"blur_johns_portrait_380x311.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
    [self assertHashImagesNotSimilar:@"blur_dhirst_a3b9ddea.bmp"
                  rightHandImageName:@"blur_latrobe.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
    [self assertHashImagesNotSimilar:@"blur_diamondskull.bmp"
                  rightHandImageName:@"blur_targetjasperjohns.bmp"
          withImageHashingProviderId:OSImageHashingProviderDHash];
}

- (void)testPerformanceDHash
{
    NSData *imageData = [self loadImageAsData:@"blur_architecture1.bmp"];
    [self measureBlock:^{
      for (int i = 0; i < 256; i++) {
          [self.dHash hashImageData:imageData];
      }
    }];
}

- (void)testDHashMultithreadedHashingPerformance
{
    const NSUInteger iterations = 1024 * 8;
    unsigned long long filesize = [@"blur_architecture1.bmp" fileSizeOfElementInBundle:[self bundle]];
    NSData *imageData = [self loadImageAsData:@"blur_architecture1.bmp"];
    NSDate *t0 = [NSDate date];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.maxConcurrentOperationCount = (NSInteger)[[NSProcessInfo processInfo] processorCount] * 2;
    for (NSUInteger i = 0; i < iterations; i++) {
        [operationQueue addOperationWithBlock:^{
          [self.dHash hashImageData:imageData];
        }];
    }
    [operationQueue waitUntilAllOperationsAreFinished];
    NSDate *t1 = [NSDate date];
    NSTimeInterval executionTime = [t1 timeIntervalSinceDate:t0];
    unsigned long long hashedMBs = filesize * iterations / 1024 / 1024;
    double hashMBsPerS = hashedMBs / executionTime;
    NSLog(@"Hashing %@ MB/s", @(hashMBsPerS));
}

- (void)testPerformanceDHashDistancePerformance
{
    const NSUInteger iterations = 1024 * 128;
    NSData *leftHandImage = [self loadImageAsData:@"blur_architecture1.bmp"];
    NSData *rightHandImage = [self loadImageAsData:@"blur_bamarket115.bmp"];
    OSHashType leftHandResult = [self.dHash hashImageData:leftHandImage];
    OSHashType rightHandResult = [self.dHash hashImageData:rightHandImage];
    NSDate *t0 = [NSDate date];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.maxConcurrentOperationCount = (NSInteger)[[NSProcessInfo processInfo] processorCount] * 2;
    for (NSUInteger i = 0; i < iterations; i++) {
        [operationQueue addOperationWithBlock:^{
          [self.dHash hashDistance:leftHandResult
                                to:rightHandResult];
        }];
    }
    [operationQueue waitUntilAllOperationsAreFinished];
    NSDate *t1 = [NSDate date];
    NSTimeInterval executionTime = [t1 timeIntervalSinceDate:t0];
    double checksPerS = iterations / executionTime;
    NSLog(@"Calculating %@ checks/s", @(checksPerS));
}

- (void)testDataHashingWithMalformedInput
{
    NSData *data = [NSMutableData dataWithLength:1024 * 1024];
    OSHashType result = [self.dHash hashImageData:data];
    XCTAssertEqual(OSHashTypeError, result);
}

- (void)testDHashValuesRegression
{
    [self assertHashOfImageWithName:@"blur_architecture1.bmp"
                          isEqualTo:8878387448951351155
                        forProvider:OSImageHashingProviderDHash];
    [self assertHashOfImageWithName:@"compr_architecture1.jpg"
                          isEqualTo:8878387448951351155
                        forProvider:OSImageHashingProviderDHash];
    [self assertHashOfImageWithName:@"blur_bamarket115.bmp"
                          isEqualTo:434042140785579798
                        forProvider:OSImageHashingProviderDHash];
}

@end
