//
//  TDFSignalPacket.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/20.
//
//

#import "TDFSignalPacket.h"
#import "TDFReactiveMacro.h"

@interface TDFSignalPacket ()

@property (nonatomic, strong) RACSignal *signal;

@end

@implementation TDFSignalPacket

+ (instancetype)pack:(id)signal {
    TDFSignalPacket *pack = [[TDFSignalPacket alloc] init];
    if (![signal isKindOfClass:[RACSignal class]]) {
        signal = [RACSignal empty];
    }
    pack->_signal = signal;
    return pack;
}

- (id)unpack {
    return self.signal ? : [RACSignal empty];
}

- (void)parsing:(void (^)(id))dataBlock {
    NSCParameterAssert(dataBlock != NULL);
    [((RACSignal *)[self unpack]) subscribeNext:dataBlock];
}

- (void)error:(void (^)(NSError *))errorBlock {
    NSCParameterAssert(errorBlock != NULL);
    [((RACSignal *)[self unpack]) subscribeError:errorBlock];
}

- (void)finish:(void (^)())finishBlock {
    NSCParameterAssert(finishBlock != NULL);
    [((RACSignal *)[self unpack]) subscribeCompleted:finishBlock];
}

- (void)parsing:(void (^)(id))dataBlock error:(void (^)(NSError *))errorBlock finish:(void (^)())finishBlock {
    NSCParameterAssert(dataBlock != NULL);
    RACSignal *signal = [self unpack];
    [signal subscribeNext:dataBlock
            error:errorBlock
            completed:finishBlock];
}

@end
