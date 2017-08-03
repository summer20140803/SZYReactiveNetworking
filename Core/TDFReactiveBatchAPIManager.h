//
//  TDFReactiveBatchAPIManager.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/4.
//
//

#import <Foundation/Foundation.h>
@class TDFReactiveAPIManager;

@interface TDFReactiveBatchAPIManager : NSObject


/**
 获取实例

 @return TDFReactiveBatchAPIManager实例
 */
+ (instancetype)batchManager;

/**
 执行一条依赖的请求链
 A->B->C->Input，上一个请求得到成功响应才会发起第二个请求

 @param managers API管理者组，序号决定发起顺序
 @param completion 请求链结束回调
 当isFinish为YES，则说明请求链上的所有请求都得到了响应
 当isFinish为NO，则说明请求链中有请求失败了，被迫中断
 */
- (void)doRequestsChainWithAPIManagers:(NSArray<TDFReactiveAPIManager *> *)managers completion:(void(^)(BOOL isFinish))completion;

/**
 执行一个要求同时输入同时输出的请求组
 A/B/C->Input
 
 @param managers API管理者组，可无序
 @param completion 请求组结束回调
 当isFinish为YES，则说明请求组里的所有请求都得到了响应
 当isFinish为NO，则说明请求组里至少有一个请求失败了
 */
- (void)doRequestsGroupWithAPIManagers:(NSArray<TDFReactiveAPIManager *> *)managers completion:(void(^)(BOOL isFinish))completion;

/**
 中断当前的批量请求
 */
- (void)break;

@end
