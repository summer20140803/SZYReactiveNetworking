//
//  TDFReactivePageAPIManager.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/11.
//
//

#import <Foundation/Foundation.h>
#import <TDFAPIKit/TDFAPIKit.h>

@interface TDFReactivePageAPIManager : NSObject

/**
 添加下拉刷新和上拉加载的视图
 */
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/**
 自动更新API入参时可以设置这个属性
 支持id，内部统一转换成NSString
 */
@property (nonatomic,   copy) NSDictionary*(^apiParamsFetcher)();

/**
 与Manager关联的分页API
 子类必须实现get方法
 */
@property (nonatomic, strong) __kindof TDFGeneralPageAPI *api;

/**
 是否要添加上下拉刷新，默认为YES
 */
@property (assign, nonatomic) BOOL shouldAddHeaderRefresh;
@property (assign, nonatomic) BOOL shouldAddFooterRefresh;

/**
 HUD的显示图层
 如果设置不为nil，则会自动设置和触发api的TDFMBHUDPresenter
 如果不设置，也可以在api自身的回调中手动添加HUD显示和隐藏逻辑
 */
@property (nonatomic, strong) __kindof UIView *hudLayer;

/**
 数据转换处理，将api加工后的数据转换成自己的item数组
 */
@property (nonatomic,   copy) NSArray* (^itemTransformHandler)(NSArray *data);

/**
 下拉刷新/下拉刷新的回调
 items为itemTransformHandler处理过后的item数组
 */
@property (nonatomic,   copy) void (^headerRefreshHandler)(NSArray *newItems);
@property (nonatomic,   copy) void (^footerRefreshHandler)(NSArray *newItems);

/**
 初始化APIManager
 这个方法可以由子类重载
 
 @param scrollView       要添加分页效果的滑动视图
 @param apiParamsFetcher API所须的入参生成，可以为空
 @return APIManager实例
 */
+ (instancetype)apiManagerWithScrollView:(__kindof UIScrollView *)scrollView apiParamsFetcher:(NSDictionary*(^)())apiParamsFetcher;
+ (instancetype)apiManagerWithScrollView:(__kindof UIScrollView *)scrollView;

/**
 手动执行重新加载第一页
 */
- (void)start;

@end
