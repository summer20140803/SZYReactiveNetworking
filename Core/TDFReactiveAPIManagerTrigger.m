//
//  TDFReactiveAPIManagerTrigger.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/11.
//
//

#import "TDFReactiveAPIManagerTrigger.h"
#import "TDFReactiveMacro.h"

@interface TDFReactiveAPIManagerTrigger ()

@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, assign) BOOL stopPolling;

@end

@implementation TDFReactiveAPIManagerTrigger

+ (instancetype)triggerWithSignal:(RACSignal *)signal {
    TDFReactiveAPIManagerTrigger *trigger = [[TDFReactiveAPIManagerTrigger alloc] init];
    trigger->_signal = signal;
    return trigger;
}

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))delay {
    @weakify(self)
    return ^(NSTimeInterval delay) {
        @strongify(self)
        self.signal =
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }]
        delay:delay]
        then:^RACSignal * _Nonnull{
            @strongify(self)
            return self.signal;
        }];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *)retry {
    self.signal = [self.signal retry];
    return self;
}

- (TDFReactiveAPIManagerTrigger *(^)(NSUInteger))retryFew {
    @weakify(self)
    return ^(NSUInteger count) {
        @strongify(self)
        self.signal = [self.signal retry:count];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))timeout {
    @weakify(self)
    return ^(NSTimeInterval timeout) {
        @strongify(self)
        self.signal = [self.signal timeout:timeout onScheduler:[RACScheduler currentScheduler]];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))polling {
    @weakify(self)
    return ^(NSTimeInterval interval) {
        @strongify(self)
        self.signal = [[[[[[RACSignal return:nil]
        delay:interval]
        deliverOnMainThread]
        then:^RACSignal * _Nonnull{
            @strongify(self)
            return self.signal;
        }]
        repeat]
        takeUntil:[self rac_willDeallocSignal]];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval, BOOL *))pollingFew {
    @synchronized (self) {
        self.stopPolling = NO;
    }
    @weakify(self)
    return ^(NSTimeInterval interval, BOOL *stop) {
        @strongify(self)
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            RACDisposable *d = [RACObserve(self, stopPolling) subscribeNext:^(id  _Nullable x) {
                if ([x boolValue]) {
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
                [d dispose];
            }];
        }];
        self.signal =
        [[[[[[[RACSignal return:nil]
        delay:interval]
        deliverOnMainThread]
        then:^RACSignal * _Nonnull{
            @strongify(self)
            return self.signal;
        }]
        repeat]
        takeUntil:signal]
        doNext:^(id  _Nullable x) {
            @strongify(self)
            @synchronized (self) {
                self.stopPolling = *stop;
            }
        }];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *(^)(NSTimeInterval))throttle {
    @weakify(self)
    return ^(NSTimeInterval silence) {
        @strongify(self)
        self.signal = [self.signal throttle:silence];
        return self;
    };
}

- (TDFReactiveAPIManagerTrigger *)and {
    return self;
}

- (RACSignal *)install {
    return self.signal;
}

@end
