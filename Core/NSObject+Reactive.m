//
//  NSObject+Reactive.m
//  Pods
//
//  Created by 开不了口的猫 on 17/5/26.
//
//

#import "NSObject+Reactive.h"
#import "TDFReactiveMacro.h"

@implementation NSObject (Reactive)

- (void)gyl_hookSelector:(SEL)selector fromProtocol:(Protocol *)protocol handler:(void (^)(id))handler {
    [[[self rac_signalForSelector:selector fromProtocol:protocol]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id  _Nullable args) {
        !handler ? : handler(args);
    }];
}

@end
