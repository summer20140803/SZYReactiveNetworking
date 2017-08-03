//
//  TDFReactiveMacro.h
//  Pods
//
//  Created by 开不了口的猫 on 17/5/27.
//
//

#ifndef TDFReactiveMacro_h
#define TDFReactiveMacro_h

#import <ReactiveObjC/ReactiveObjC.h>

#define TDFKey(TARGET, ...)  \
RAC(TARGET, __VA_ARGS__)

#define TDFObserve(TARGET, KEYPATH)  \
RACObserve(TARGET, KEYPATH)

#define TDFBindKey(bindTarget, bindkey, destination, destinationKey)   \
RAC(bindTarget, bindkey)=RACObserve(destination, destinationKey);

#define TDFOpenChannel(target_1, keyPath_1, target_2, keyPath_2)   \
RACChannelTo(target_1, keyPath_1)=RACChannelTo(target_2, keyPath_2);

#define BPArray(UNIT, NUM)  ({  \
NSMutableArray *array = [NSMutableArray array];  \
for (int i=0; i<NUM; i++) {  \
    [array addObject:UNIT];  \
};  \
[array copy]; \
});


#endif /* TDFReactiveMacro_h */
