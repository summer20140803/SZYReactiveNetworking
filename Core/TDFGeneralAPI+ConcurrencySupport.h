//
//  TDFGeneralAPI+ConcurrencySupport.h
//  TDFReactiveExample
//
//  Created by 开不了口的猫 on 2017/7/17.
//  Copyright © 2017年 TDF. All rights reserved.
//

#import <TDFAPIKit/TDFAPIKit.h>

@interface TDFGeneralAPI (ConcurrencySupport)

/**
 API请求并发发送时的start方法
 */
- (void)startConcurrency;

@end
