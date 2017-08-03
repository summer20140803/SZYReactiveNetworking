//
//  TDFCommandPacket.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/21.
//
//

#import <Foundation/Foundation.h>
#import "TDFSignalPacket.h"
#import "TDFPacketProtocol.h"

@interface TDFCommandPacket : NSObject <TDFPacketProtocol>

/**
  内部信号包
 */
@property (nonatomic, strong, readonly) TDFSignalPacket *signalPacket;

/**
  解析成功回调
 */
@property (nonatomic, copy) void (^parsingSuccess)(id data);

/**
  解析失败回调
 */
@property (nonatomic, copy) void (^parsingError)(NSError *error);

/**
  解析完成回调
 */
@property (nonatomic, copy) void (^parsingFinish)();

/**
 生成实例

 @param signalPacket 信号包
 @return commandPacket实例
 */
- (instancetype)initWithSignalPacket:(TDFSignalPacket *)signalPacket;

@end
