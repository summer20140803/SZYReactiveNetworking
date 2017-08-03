//
//  TDFReactiveAPIManager.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/20.
//
//

#import "TDFReactiveAPIManager.h"
#import "NSDictionary+Reactive.h"
#import "TDFGeneralAPI+ConcurrencySupport.h"
#import "YYModel.h"
#import <objc/runtime.h>

@interface TDFReactiveAPIManager (Debugging)

#if DEBUG && !ENTERPRISE
@property (nonatomic, strong) TDFAPIDebugger *debugger;
#endif

@end

@interface TDFReactiveAPIManager ()

@property (nonatomic, strong) TDFReactiveAPIManagerTrigger *trigger;

@end

@implementation TDFReactiveAPIManager

+ (instancetype)apiManagerWithApiParamsFetcher:(NSDictionary *(^)())apiParamsFetcher {
    TDFReactiveAPIManager *apiManager = [self apiManager];
    apiManager.apiParamsFetcher = apiParamsFetcher;
    return apiManager;
}

+ (instancetype)apiManager {
    TDFReactiveAPIManager *apiManager = [[self alloc] init];
    return apiManager;
}

- (void)dealloc {
    [self.finishSignal.rac_willDeallocSignal subscribeCompleted:^{
        NSLog(@"subject dealloc");
    }];
}

- (__kindof TDFGeneralAPI *)api {
    NSString *reason = [NSString stringWithFormat:@"%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)setHudLayer:(__kindof UIView *)hudLayer {
    _hudLayer = hudLayer;
    self.api.presenter = [TDFMBHUDPresenter HUDWithView:hudLayer];
}

- (void)setConcurrencySupport:(BOOL)concurrencySupport {
    _concurrencySupport = concurrencySupport;
}

- (TDFSignalPacket *)packet {
    @weakify(self)
    return [TDFSignalPacket pack:
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        self.api.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, id response) {
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        };
        self.api.apiFailureHandler = ^(__kindof TDFBaseAPI *api, NSError *error) {
#if DEBUG && !ENTERPRISE
            @strongify(self)
            BOOL dnsToLocal = [self.debugger debuggingWithError:error asyncData:^(id data) {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
            if (!dnsToLocal) {
                [subscriber sendError:error];
            }
#else
            [subscriber sendError:error];
#endif
        };
        self.api.params = [[self compatibleParams] mutableCopy];
        if (self.concurrencySupport) {
            [self.api startConcurrency];
        } else {
            [self.api start];
        }
        return [RACDisposable disposableWithBlock:^{
            if (self.api.isLoading) {
                [self.api cancel];
            }
        }];
    }]
    // @discuss:这里跟触发器的retry有冲突..暂抛弃..
//    replayLazily]
    deliverOn:[RACScheduler mainThreadScheduler]]];
}

- (void)start {
    [self triggerConnection:[[self packet] unpack]];
}

- (void)startWithConfigurations:(void (^)(TDFReactiveAPIManagerTrigger *))configurations {
    if (!configurations) {
        [self start];
        return;
    }
    self.trigger = [TDFReactiveAPIManagerTrigger triggerWithSignal:[[self packet] unpack]];
    configurations(self.trigger);
    RACSignal *customizedSignal = [self.trigger install];
    [self triggerConnection:customizedSignal];
}

- (void)triggerConnection:(RACSignal *)customizedSignal {
    if (self.api.isLoading) {
        if (self.isEliminateEnable) [self.api cancel];
        else return;
    }
    NSCParameterAssert(customizedSignal != NULL);
    RACMulticastConnection *connection = [customizedSignal publish];
    
    @weakify(self)
    [[TDFSignalPacket pack:[connection.signal
    deliverOn:[RACScheduler mainThreadScheduler]]]
     parsing:^(id data) {
         @strongify(self)
         !self.apiSuccessHandler ? : self.apiSuccessHandler(self.api, data);
         !self.successSignal ? : [self.successSignal sendNext:data];
     } error:^(NSError *error) {
         @strongify(self)
         !self.apiFailureHandler ? : self.apiFailureHandler(self.api, error);
         !self.errorSignal ? : [self.errorSignal sendNext:error];
     } finish:^{
         @strongify(self)
         !self.finishSignal ? : [self.finishSignal sendCompleted];
     }];
    
    [connection connect];
}

- (NSDictionary *)compatibleParams {
    NSDictionary *compatibleParams;
    if (self.apiParamsFetcher) {
        NSDictionary *params = self.apiParamsFetcher();
        if (params) {
            compatibleParams = [params gyl_map:^TDFKVPair *(TDFKVPair *oriPair) {
                if ([oriPair.value isKindOfClass:[NSString class]]) {
                    return [TDFKVPair pairWithKey:oriPair.key value:oriPair.value];
                }
                if ([oriPair.value isKindOfClass:[NSNumber class]]) {
                    NSNumber *number = oriPair.value;
                    return [TDFKVPair pairWithKey:oriPair.key value:number.stringValue];
                }
                else return [TDFKVPair pairWithKey:oriPair.key value:[oriPair.value yy_modelToJSONString]];
            }];
        }
        else compatibleParams = nil;
    }
    return compatibleParams;
}

@end

@implementation TDFReactiveAPIManager (Debugging)
#if DEBUG && !ENTERPRISE
@dynamic debugger;

#pragma mark - getter -
- (TDFAPIDebugger *)debugger {
    TDFAPIDebugger *debugger = objc_getAssociatedObject(self, _cmd);
    if (!debugger) {
        debugger = [[TDFAPIDebugger alloc] init];
        debugger.dataSource = self;
        objc_setAssociatedObject(self, @selector(debugger), debugger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return debugger;
}
#endif

@end
