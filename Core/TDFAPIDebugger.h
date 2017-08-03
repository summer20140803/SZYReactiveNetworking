//
//  TDFAPIDebugger.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/2.
//
//

#import <Foundation/Foundation.h>

@protocol TDFAPIDebuggerDataSource <NSObject>

@optional
/**
 调试用的模拟异步返回的Json数据源

 @return 假的Json数据源
 */
- (id)fakeJson;

@end

@interface TDFAPIDebugger : NSObject

@property (nonatomic, weak) id<TDFAPIDebuggerDataSource> dataSource;

/**
 模拟发送一个异步请求

 @param error 正常的API请求返回的错误
 @return 是否模拟成功
 */
- (BOOL)debuggingWithError:(NSError *)error asyncData:(void(^)(id data))asyncData;

@end
