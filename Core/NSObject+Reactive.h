//
//  NSObject+Reactive.h
//  Pods
//
//  Created by 开不了口的猫 on 17/5/26.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Reactive)

- (void)gyl_hookSelector:(SEL)selector fromProtocol:(Protocol *)protocol handler:(void (^)(id args))handler;

@end
