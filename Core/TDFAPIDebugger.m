//
//  TDFAPIDebugger.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/2.
//
//

#import "TDFAPIDebugger.h"

@interface TDFAPIDebugger ()

@property (nonatomic, strong) NSSet *debuggingErrorCodeSet;

@end

@implementation TDFAPIDebugger

- (BOOL)debuggingWithError:(NSError *)error asyncData:(void (^)(id))asyncData {
    if (![self.debuggingErrorCodeSet containsObject:@(error.code)]) return NO;
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(fakeJson)]) return NO;
    NSTimeInterval consuming = (100 + (arc4random() % 100))/100.f;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(consuming * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !asyncData ? : asyncData([self.dataSource fakeJson]);
        });
    });
    return YES;
}

#pragma mark - URLDomainErrorCSet -
- (NSSet *)debuggingErrorCodeSet {
    if (!_debuggingErrorCodeSet) {
        _debuggingErrorCodeSet = [NSSet setWithArray:@[
                                                       @(NSURLErrorBadURL),
                                                       @(NSURLErrorUnsupportedURL),
                                                       @(NSURLErrorCannotFindHost),
                                                       @(NSURLErrorCannotConnectToHost),
                                                       @(NSURLErrorNetworkConnectionLost),
                                                       @(NSURLErrorNotConnectedToInternet),
                                                       @(NSURLErrorBadServerResponse),
                                                       @(NSURLErrorDNSLookupFailed),
                                                       @(NSURLErrorTimedOut),
                                                       @(NSURLErrorCannotDecodeRawData),
                                                       @(NSURLErrorCannotDecodeContentData),
                                                       @(NSURLErrorCannotParseResponse),
                                                      ]];
    }
    return _debuggingErrorCodeSet;
}

@end
