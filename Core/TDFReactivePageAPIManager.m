//
//  TDFReactivePageAPIManager.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/11.
//
//

#import "TDFReactivePageAPIManager.h"
#import <TDFPagingDataLoader/TDFPagingDataLoader.h>
#import "NSDictionary+Reactive.h"
#import "TDFKVPair.h"
#import "YYModel.h"
#import "TDFAPIDebugger.h"
#import "TDFGeneralPageAPI+APIDebugger.h"
#import <libextobjc/EXTScope.h>

@interface TDFReactivePageAPIManager ()<TDFPagingDataLoaderReformer, TDFPagingDataLoaderInterceptor, TDFAPIDebuggerDataSource>

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) TDFBasePagingDataLoader *loader;

@end

@implementation TDFReactivePageAPIManager

+ (instancetype)apiManagerWithScrollView:(__kindof UIScrollView *)scrollView apiParamsFetcher:(NSDictionary *(^)())apiParamsFetcher {
    TDFReactivePageAPIManager *apiManager = [self apiManagerWithScrollView:scrollView];
    apiManager.apiParamsFetcher = apiParamsFetcher;
    return apiManager;
}

+ (instancetype)apiManagerWithScrollView:(__kindof UIScrollView *)scrollView {
    NSCParameterAssert(scrollView != NULL);
    TDFReactivePageAPIManager *apiManager = [[self alloc] init];
    apiManager.scrollView = scrollView;
#if DEBUG && !ENTERPRISE
    apiManager.api.dataSource = apiManager;
#endif
    return apiManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.shouldAddFooterRefresh = YES;
        self.shouldAddHeaderRefresh = YES;
    }
    return self;
}

- (__kindof TDFGeneralPageAPI *)api {
    NSString *reason = [NSString stringWithFormat:@"%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)setApiParamsFetcher:(NSDictionary *(^)())apiParamsFetcher {
    _apiParamsFetcher = [apiParamsFetcher copy];
    @weakify(self)
    self.api.apiRequestWillBeSentBlock = ^(__kindof TDFBaseAPI *api) {
        @strongify(self)
        self.api.params = [[self compatibleParams] mutableCopy];
    };
}

- (void)setHudLayer:(__kindof UIView *)hudLayer {
    _hudLayer = hudLayer;
    self.api.presenter = [TDFMBHUDPresenter HUDWithView:hudLayer];
}

- (void)start {
    [self.loader start];
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

#pragma mark - getter & setter -
- (TDFBasePagingDataLoader *)loader {
    if (!_loader) {
        _loader = [[TDFBasePagingDataLoader alloc] initWithScrollView:self.scrollView];
        _loader.fetcher = (id<TDFPagingDataFetcher>)self.api;
        _loader.reformer = self;
        _loader.interceptor = self;
    }
    return _loader;
}

- (void)setShouldAddHeaderRefresh:(BOOL)shouldAddHeaderRefresh {
    _shouldAddHeaderRefresh = shouldAddHeaderRefresh;
    self.loader.shouldAddHeaderRefresh = shouldAddHeaderRefresh;
}

- (void)setShouldAddFooterRefresh:(BOOL)shouldAddFooterRefresh {
    _shouldAddFooterRefresh = shouldAddFooterRefresh;
    self.loader.shouldAddFooterRefresh = shouldAddFooterRefresh;
}

#pragma mark - TDFPagingDataLoaderReformer -
- (NSArray *)reformDataWithNewItems:(NSArray *)items {
    return self.itemTransformHandler ? self.itemTransformHandler(items) : items;
}

#pragma mark - TDFPagingDataLoaderInterceptor -
- (void)afterHeaderRefreshWithNewItems:(NSArray *)items {
    !self.headerRefreshHandler ? : self.headerRefreshHandler(items);
}

- (void)afterFooterRefreshWithNewItems:(NSArray *)items {
    !self.footerRefreshHandler ? : self.footerRefreshHandler(items);
}

@end
