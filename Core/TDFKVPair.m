//
//  TDFKVPair.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/26.
//
//

#import "TDFKVPair.h"

@interface TDFKVPair ()

@property (nonatomic, strong, readwrite) id key;
@property (nonatomic, strong, readwrite) id value;

@end

@implementation TDFKVPair

+ (instancetype)pairWithKey:(id)key value:(id<NSCopying>)value {
    NSCParameterAssert(key != NULL);
    NSCParameterAssert(value != NULL);
    TDFKVPair *pair = [[TDFKVPair alloc] init];
    pair.key = key;
    pair.value = value;
    return pair;
}

+ (instancetype)empty {
    return nil;
}

@end
