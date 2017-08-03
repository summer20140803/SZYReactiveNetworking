//
//  UIButton+Reactive.h
//  Pods
//
//  Created by 开不了口的猫 on 17/5/25.
//
//

#import <UIKit/UIKit.h>
@class TDFCommandPacket;

@interface UIButton (Reactive)

- (void)gyl_click:(void (^)(id sender))handler;

- (void)gyl_bindPacket:(TDFCommandPacket *)packet;

@end
