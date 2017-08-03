//
//  TDFKVPair.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/26.
//
//

#import <Foundation/Foundation.h>

@interface TDFKVPair : NSObject

@property (nonatomic, strong, readonly) id key;
@property (nonatomic, strong, readonly) id value;

+ (instancetype)pairWithKey:(id)key value:(id<NSCopying>)value;
+ (instancetype)empty;

@end
