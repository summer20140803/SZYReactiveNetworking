//
//  TDFCommandPacket.m
//  Pods
//
//  Created by 开不了口的猫 on 2017/6/21.
//
//

#import "TDFCommandPacket.h"
#import "TDFReactiveMacro.h"

@interface TDFCommandPacket ()

@property (nonatomic, strong) RACCommand *command;
@property (nonatomic, strong) RACDisposable *successDisposable;
@property (nonatomic, strong) RACDisposable *errorDisposable;
@property (nonatomic, strong) RACDisposable *finishDisposable;

@end

@implementation TDFCommandPacket

- (TDFSignalPacket *)signalPacket {
    if (self.command) {
        return [TDFSignalPacket pack:self.command.executionSignals.switchToLatest];
    } else {
        return [TDFSignalPacket pack:[RACSignal empty]];
    }
}

+ (instancetype)pack:(id)carrier {
    TDFCommandPacket *packet = [[TDFCommandPacket alloc] init];
    if (![carrier isKindOfClass:[RACCommand class]]) {
        carrier = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal empty];
        }];
    }
    packet->_command = carrier;
    return packet;
}

- (id)unpack {
    return self.command;
}

- (void)setParsingSuccess:(void (^)(id))parsingSuccess {
    _parsingSuccess = parsingSuccess;
    [self.successDisposable dispose];
    RACDisposable *d =
    [[[self.command.executionSignals.switchToLatest
    deliverOn:[RACScheduler mainThreadScheduler]]
    distinctUntilChanged]
    subscribeNext:^(id  _Nullable x) {
        !parsingSuccess ? : parsingSuccess(x);
    }];
    self.successDisposable = d;
}

- (void)setParsingError:(void (^)(NSError *))parsingError {
    _parsingError = parsingError;
    [self.errorDisposable dispose];
    RACDisposable *d =
    [[[self.command.errors
    deliverOn:[RACScheduler mainThreadScheduler]]
    distinctUntilChanged]
    subscribeNext:^(NSError * _Nullable x) {
        !parsingError ? : parsingError(x);
    }];
    self.errorDisposable = d;
}

- (void)setParsingFinish:(void (^)())parsingFinish {
    _parsingFinish = parsingFinish;
    [self.finishDisposable dispose];
    RACDisposable *d =
    [[[self.command.executing skip:1]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(NSNumber * _Nullable x) {
        if (![x boolValue]) {
            !parsingFinish ? : parsingFinish();
        }
    }];
    self.finishDisposable = d;
}

- (instancetype)initWithSignalPacket:(TDFSignalPacket *)signalPacket {
    NSCParameterAssert(signalPacket != NULL);
    return [TDFCommandPacket pack:[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [signalPacket unpack];
    }]];
}

@end
