//
//  TDFGeneralPageAPI+APIDebugger.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/12.
//
//

#import "TDFGeneralPageAPI+APIDebugger.h"
#import <objc/runtime.h>
#import <libextobjc/EXTScope.h>

@implementation TDFGeneralPageAPI (APIDebugger)

#if DEBUG && !ENTERPRISE
- (void)fetchDataWithCompleteHandler:(void (^)(NSArray *response, NSError *error))complete {
    [self setApiSuccessHandler:^(TDFBaseAPI *api, id response) {
        complete(response, nil);
    }];
    @weakify(self)
    [self setApiFailureHandler:^(TDFBaseAPI *api, NSError *error) {
        @strongify(self)
        BOOL dnsToLocal = [self.debugger debuggingWithError:error asyncData:^(id data) {
            complete(data, nil);
        }];
        if (!dnsToLocal) {
            complete(nil, error);
        }
    }];
    [self start];
}

- (void)fetchMoreDataWithCompleteHandler:(void (^)(NSArray *response, NSError *error))complete {
    [self setApiSuccessHandler:^(TDFBaseAPI *api, id response) {
        complete(response, nil);
    }];
    @weakify(self)
    [self setApiFailureHandler:^(TDFBaseAPI *api, NSError *error) {
        @strongify(self)
        BOOL dnsToLocal = [self.debugger debuggingWithError:error asyncData:^(id data) {
            complete(data, nil);
        }];
        if (!dnsToLocal) {
            complete(nil, error);
        }
    }];
    [self startForNextPage];
}

- (TDFAPIDebugger *)debugger {
    TDFAPIDebugger *debugger = objc_getAssociatedObject(self, _cmd);
    if (!debugger) {
        debugger = [[TDFAPIDebugger alloc] init];
        debugger.dataSource = self.dataSource;
        objc_setAssociatedObject(self, @selector(debugger), debugger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return debugger;
}

- (id<TDFAPIDebuggerDataSource>)dataSource {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDataSource:(id<TDFAPIDebuggerDataSource>)dataSource {
    objc_setAssociatedObject(self, @selector(dataSource), dataSource, OBJC_ASSOCIATION_ASSIGN);
}
#endif

@end
