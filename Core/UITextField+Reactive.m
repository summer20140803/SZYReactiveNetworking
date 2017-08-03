//
//  UITextField+Reactive.m
//  TDFReactiveExample
//
//  Created by 开不了口的猫 on 2017/7/14.
//  Copyright © 2017年 TDF. All rights reserved.
//

#import "UITextField+Reactive.h"
#import "TDFReactiveMacro.h"

@implementation UITextField (Reactive)

- (void)registerTextDidChangeWithSilence:(NSTimeInterval)silence handler:(void (^)(NSString *))handler {
    [[[self.rac_textSignal
    throttle:silence]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSString * _Nullable x) {
        !handler ? : handler(x);
    }];
}

@end
