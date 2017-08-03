//
//  TDFReactiveAPIManagerTrigger.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/11.
//
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface TDFReactiveAPIManagerTrigger : NSObject

+ (instancetype)triggerWithSignal:(RACSignal *)signal;

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))delay;

- (TDFReactiveAPIManagerTrigger *)retry;

- (TDFReactiveAPIManagerTrigger *(^)(NSUInteger))retryFew;

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))timeout;

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))polling;

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval, BOOL *))pollingFew;

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))throttle;

- (TDFReactiveAPIManagerTrigger *)and;

- (RACSignal *)install;

@end
