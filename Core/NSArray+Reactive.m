//
//  NSArray+Reactive.m
//  Pods
//
//  Created by 开不了口的猫 on 17/5/25.
//
//

#import "NSArray+Reactive.h"
#import "TDFReactiveMacro.h"
#import <objc/runtime.h>

@interface NSArray (SequencePersistence)

@end

@implementation NSArray (Reactive)

- (instancetype)gyl_skip:(NSUInteger)skip {
    NSCParameterAssert([self count] >= skip);
    return [[self.rac_sequence skip:skip] array];
}

- (instancetype)gyl_take:(NSUInteger)take {
    NSCParameterAssert([self count] >= take);
    return [[self.rac_sequence take:take] array];
}

- (instancetype)gyl_traverse:(BOOL (^)(id))traverse {
    NSCParameterAssert(traverse != NULL);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        *stop = traverse(obj);
    }];
    return self;
}

- (instancetype)gyl_map:(id (^)(id))map {
    NSCParameterAssert(map != NULL);
    return [[self.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return map(value);
    }] array];
}

- (instancetype)gyl_filter:(BOOL (^)(id))filter {
    NSCParameterAssert(filter != NULL);
    return [[self.rac_sequence filter:^BOOL(id  _Nullable value) {
        return filter(value);
    }] array];
}

- (instancetype)gyl_ignore:(id (^)())ignore {
    NSCParameterAssert(ignore != NULL);
    return [[self.rac_sequence ignore:ignore()] array];
}

- (id)gyl_concatWithStart:(id)start reduce:(id (^)(id, id))reduce {
    NSCParameterAssert(reduce != NULL);
    return [self.rac_sequence foldLeftWithStart:start reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return reduce(accumulator, value);
    }];
}

@end

