//
//  UITextField+Reactive.h
//  TDFReactiveExample
//
//  Created by 开不了口的猫 on 2017/7/14.
//  Copyright © 2017年 TDF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Reactive)

- (void)registerTextDidChangeWithSilence:(NSTimeInterval)silence handler:(void (^)(NSString *value))handler;

@end
