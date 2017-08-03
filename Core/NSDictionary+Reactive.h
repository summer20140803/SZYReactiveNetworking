//
//  NSDictionary+Reactive.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/26.
//
//

#import <Foundation/Foundation.h>
#import "TDFKVPair.h"

@interface NSDictionary (Reactive)

- (instancetype)gyl_map:(TDFKVPair*(^)(TDFKVPair *oriPair))map;

@end
