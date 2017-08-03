//
//  UIButton+Reactive.m
//  Pods
//
//  Created by 开不了口的猫 on 17/5/25.
//
//

#import "UIButton+Reactive.h"
#import "UIControl+Reactive.h"
#import "TDFReactiveMacro.h"
#import "TDFCommandPacket.h"

@implementation UIButton (Reactive)

- (void)gyl_click:(void (^)(id sender))handler {
    [self gyl_addEvents:UIControlEventTouchUpInside handler:handler];
}

- (void)gyl_bindPacket:(TDFCommandPacket *)packet {
    NSCParameterAssert(packet != NULL);
    self.rac_command = [packet unpack];
}

@end
