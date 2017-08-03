//
//  TDFPacketProtocol.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/21.
//
//

#import <Foundation/Foundation.h>

@protocol TDFPacketProtocol <NSObject>

@required

/**
 组包
 
 @param signal 数据载体(RACSignal、RACCommand或其子类)
 @return 信息包
 */
+ (instancetype)pack:(id)carrier;

/**
 解包
 
 @return 数据载体
 */
- (id)unpack;


@end
