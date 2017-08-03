//
//  NSArray+Reactive.h
//  Pods
//
//  Created by 开不了口的猫 on 17/5/25.
//
//

#import <Foundation/Foundation.h>

@interface NSArray<T> (Reactive)

- (instancetype)gyl_skip:(NSUInteger)skip;

- (instancetype)gyl_take:(NSUInteger)take;

- (instancetype)gyl_traverse:(BOOL (^)(T element))traverse;

- (instancetype)gyl_map:(id (^)(T element))map;

- (instancetype)gyl_filter:(BOOL (^)(T element))filter;

- (instancetype)gyl_ignore:(id (^)())ignore;

- (id)gyl_concatWithStart:(id)start reduce:(id (^)(id running, T next))reduce;

@end
