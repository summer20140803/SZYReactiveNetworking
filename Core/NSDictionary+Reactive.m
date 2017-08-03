//
//  NSDictionary+Reactive.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/26.
//
//

#import "NSDictionary+Reactive.h"
#import "TDFReactiveMacro.h"

@implementation NSDictionary (Reactive)

- (instancetype)gyl_map:(TDFKVPair *(^)(TDFKVPair *))map {
    NSCParameterAssert(map != NULL);
    NSMutableDictionary *mutableD = self.mutableCopy;
    //@note 这里不用sequence是因为避免异步操作
    for (id key in [self allKeys]) {
        id obj = [self objectForKey:key];
        TDFKVPair *origin = [TDFKVPair pairWithKey:key value:obj];
        TDFKVPair *new = map(origin);
        if ([new isEqual:[TDFKVPair empty]]) continue;
        [mutableD setObject:new.value forKey:new.key];
    }
    return [mutableD copy];
}

@end
