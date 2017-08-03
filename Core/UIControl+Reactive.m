//
//  UIControl+Reactive.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/21.
//
//

#import "UIControl+Reactive.h"
#import "TDFReactiveMacro.h"
#import <objc/runtime.h>

@interface UIControl (Disposable)

@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation UIControl (Reactive)

- (void)gyl_addEvents:(UIControlEvents)events handler:(void (^)(id))handler {
    [self.disposable dispose];
    self.disposable = [[self rac_signalForControlEvents:events] subscribeNext:^(__kindof UIControl * _Nullable x) {
        !handler ? : handler(x);
    }];
}

- (RACDisposable *)disposable {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDisposable:(RACDisposable *)disposable {
    objc_setAssociatedObject(self, @selector(disposable), disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
