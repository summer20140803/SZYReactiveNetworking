//
//  TDFGeneralAPI+ConcurrencySupport.m
//  TDFReactiveExample
//
//  Created by 开不了口的猫 on 2017/7/17.
//  Copyright © 2017年 TDF. All rights reserved.
//

#import "TDFGeneralAPI+ConcurrencySupport.h"
#import <TDFAPIKit/TDFAPIManager.h>

@implementation TDFGeneralAPI (ConcurrencySupport)

- (void)startConcurrency {
    /*
     因为所继承的离散型API体系结构底层并不支持单API并发操作
     所以这个方法的作用仅仅是将API的原start方法内isLoading的check隐藏
     但是由于API内部会用一个taskId标识并记录API发出的请求任务
     这里将不会添加新的数据结构用以保存和retain发出的请求
     这意味着：
       1.请求将不能被外部手动cancel
       2.请求将不会随controller的生命周期结束而自动取消
     */
    [[TDFAPIManager shared] sendRequest:self];
}

@end
