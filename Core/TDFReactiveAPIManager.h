//
//  TDFReactiveAPIManager.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/20.
//
//

#import <Foundation/Foundation.h>
#import "TDFSignalPacket.h"
#import <TDFAPIKit/TDFAPIKit.h>
#import "TDFReactiveMacro.h"
#import "TDFReactiveAPIManagerTrigger.h"
#import "TDFAPIDebugger.h"

@interface TDFReactiveAPIManager : NSObject <TDFAPIDebuggerDataSource>

/**
 自动更新API入参时可以设置这个属性
 支持id，内部统一转换成NSString
 */
@property (nonatomic,   copy) NSDictionary*(^apiParamsFetcher)();

/**
 数据载体包
 已在父类中默认实现，可在子类手动重载get方法
 (一般不需要重载)
 */
@property (nonatomic, strong) TDFSignalPacket *packet;

/**
 与Manager关联的API
 子类必须实现get方法
 */
@property (nonatomic, strong) __kindof TDFGeneralAPI *api;

/**
 HUD的显示图层
 如果设置不为nil，则会自动设置和触发api的TDFMBHUDPresenter
 如果不设置，也可以在api自身的回调中手动添加HUD显示和隐藏逻辑
 */
@property (nonatomic, strong) __kindof UIView *hudLayer;

/**
 相同的API是否支持并发，默认为NO
 如果设置为YES，相同的API请求可能同时存在多个
 (不建议开启)
 */
@property (nonatomic, assign, getter=isConcurrencySupport) BOOL concurrencySupport;

/**
 相同的API是否启用淘汰，默认为NO
 如果设置为YES，则后发起的API请求会废弃上一个API请求
 */
@property (nonatomic, assign, getter=isEliminateEnable) BOOL eliminateEnable;

/**
 api响应成功的回调
 Manager内部会占用api的handler，所以有需要的话必须设置这个回调
 */
@property (nonatomic, copy) void (^apiSuccessHandler)(__kindof TDFGeneralAPI *api, id response);

/**
 api响应失败的回调
 Manager内部会占用api的handler，所以有需要的话必须设置这个回调
 */
@property (nonatomic, copy) void (^apiFailureHandler)(__kindof TDFGeneralAPI *api, NSError *error);

/**
 初始化APIManager
 这个方法可以由子类实现
 
 @param apiParamsFetcher API所须的入参生成，可以为空
 @return APIManager实例
 */
+ (instancetype)apiManagerWithApiParamsFetcher:(NSDictionary*(^)())apiParamsFetcher;
+ (instancetype)apiManager;

/**
 执行API请求
 */
- (void)start;

/**
 定制API请求并执行

 @param configurations 可定制的API配置
        trigger   是一个链式的配置触发器
 */
- (void)startWithConfigurations:(void (^)(TDFReactiveAPIManagerTrigger *trigger))configurations;



//====================================
//       私有属性/方法，仅供内部使用
//====================================
@property (nonatomic, strong) RACSubject *successSignal;
@property (nonatomic, strong) RACSubject *errorSignal;
@property (nonatomic, strong) RACSubject *finishSignal;

@end

