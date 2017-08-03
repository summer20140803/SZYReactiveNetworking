//
//  TDFReactiveBatchAPIManager.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/4.
//
//

#import "TDFReactiveBatchAPIManager.h"
#import "TDFReactiveMacro.h"
#import "TDFReactiveAPIManager.h"
#import "NSArray+Reactive.h"

@interface TDFReactiveBatchAPIManager ()

@property (nonatomic, strong) RACCompoundDisposable *disposables;
@property (nonatomic, strong) NSMutableArray<TDFReactiveAPIManager *> *performManagers;
@property (nonatomic, strong) NSArray *concurrencySupportSettings;
@property (nonatomic, strong) NSArray *eliminateEnableSettings;

@end

@implementation TDFReactiveBatchAPIManager

+ (instancetype)batchManager {
    TDFReactiveBatchAPIManager *bm = [[TDFReactiveBatchAPIManager alloc] init];
    return bm;
}

#pragma mark - interface -
- (void)doRequestsChainWithAPIManagers:(NSArray<TDFReactiveAPIManager *> *)managers completion:(void (^)(BOOL))completion {
    NSCParameterAssert(managers != NULL);
    if (![managers isKindOfClass:[NSArray class]] || managers.count < 2) {
        NSString *reason = [NSString stringWithFormat:@"%@ must be more than one apiManager", NSStringFromSelector(_cmd)];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    }
    if (self.performManagers.count) return;
    
    [self storeUpSettings:managers];
    [self cancelAllAPIRequest];
    
    managers.firstObject.successSignal = [RACSubject subject];
    managers.firstObject.errorSignal   = [RACSubject subject];
    
    @weakify(self)
    [[((RACSignal *)[[managers gyl_skip:1]
    gyl_concatWithStart:
    [RACSignal merge:@[managers.firstObject.successSignal, managers.firstObject.errorSignal]]
    reduce:^id(RACSignal *running, TDFReactiveAPIManager *next) {
        return [running flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
            if ([value isKindOfClass:[NSError class]]) {
                return [RACSignal return:value];
            }
            next.successSignal = [RACSubject subject];
            next.errorSignal = [RACSubject subject];
            [next start];
            return [RACSignal merge:@[next.successSignal, next.errorSignal]];
        }];
    }])
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) !completion ? : completion(NO);
        else !completion ? : completion(YES);
        [self restoreSettings];
    }];
    
    [managers.firstObject start];
}

- (void)doRequestsGroupWithAPIManagers:(NSArray<TDFReactiveAPIManager *> *)managers completion:(void (^)(BOOL isFinish))completion {
    NSCParameterAssert(managers != NULL);
    if (![managers isKindOfClass:[NSArray class]] || managers.count < 2) {
        NSString *reason = [NSString stringWithFormat:@"%@ must be more than one apiManager", NSStringFromSelector(_cmd)];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    }
    if (self.performManagers.count) return;
    
    [self storeUpSettings:managers];
    [self cancelAllAPIRequest];
    
    @weakify(self)
    [[[RACSignal
    zip:[managers
    gyl_map:^id(TDFReactiveAPIManager *manager) {
        manager.successSignal = [RACSubject subject];
        manager.errorSignal = [RACSubject subject];
        return [RACSignal merge:@[manager.successSignal, manager.errorSignal]];
    }]]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(RACTuple *_Nullable x) {
        @strongify(self)
        if ([[[x allObjects] gyl_filter:^BOOL(id element) {
            return [element isKindOfClass:[NSError class]];
        }] count]) {
            !completion ? : completion(NO);
        } else !completion ? : completion(YES);
        [self restoreSettings];
    }];
    [managers makeObjectsPerformSelector:@selector(start)];
}

- (void)break {
    [self cancelAllAPIRequest];
    [self restoreSettings];
}

#pragma mark - getter -
- (RACCompoundDisposable *)disposables {
    if (!_disposables) {
        _disposables = [RACCompoundDisposable compoundDisposable];
    }
    return _disposables;
}

- (NSMutableArray *)performManagers {
    if (!_performManagers) {
        _performManagers = @[].mutableCopy;
    }
    return _performManagers;
}

#pragma mark - private -
- (void)storeUpSettings:(NSArray<TDFReactiveAPIManager *> *)managers {
    [self.performManagers addObjectsFromArray:managers];
    self.concurrencySupportSettings = [managers gyl_map:^id(TDFReactiveAPIManager *manager) {
        return @(manager.isConcurrencySupport);
    }];
    self.eliminateEnableSettings = [managers gyl_map:^id(TDFReactiveAPIManager *manager) {
        return @(manager.isEliminateEnable);
    }];
    [managers makeObjectsPerformSelector:@selector(setConcurrencySupport:) withObject:@NO];
    [managers makeObjectsPerformSelector:@selector(setEliminateEnable:) withObject:@NO];
}

- (void)restoreSettings {
    @weakify(self)
    [self.performManagers gyl_traverse:^BOOL(TDFReactiveAPIManager *manager) {
        @strongify(self)
        NSInteger index = [self.performManagers indexOfObject:manager];
        manager.concurrencySupport = [self.concurrencySupportSettings[index] boolValue];
        manager.eliminateEnable = [self.eliminateEnableSettings[index] boolValue];
        return NO;
    }];
    [self.performManagers removeAllObjects];
}

- (void)cancelAllAPIRequest {
    [[self.performManagers gyl_map:^id(TDFReactiveAPIManager *manager) {
        return manager.api;
    }] makeObjectsPerformSelector:@selector(cancel)];
}

@end
