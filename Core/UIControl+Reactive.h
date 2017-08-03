//
//  UIControl+Reactive.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/21.
//
//

#import <UIKit/UIKit.h>

@interface UIControl (Reactive)

- (void)gyl_addEvents:(UIControlEvents)events handler:(void (^)(id sender))handler;

@end
