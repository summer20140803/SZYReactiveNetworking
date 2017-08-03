//
//  TDFSignalPacket.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/20.
//
//

#import <Foundation/Foundation.h>
#import "TDFPacketProtocol.h"

@interface TDFSignalPacket : NSObject <TDFPacketProtocol>

/**
 解析信息包
 
 @param dataBlock   加工数据返回回调
        errorBlock  错误回调
        finishBlock 解析完成回调
 */
- (void)parsing:(void (^)(id data))dataBlock;
- (void)error:(void (^)(NSError *error))errorBlock;
- (void)finish:(void (^)())finishBlock;
- (void)parsing:(void (^)(id data))dataBlock error:(void (^)(NSError *error))errorBlock finish:(void (^)())finishBlock;

@end
