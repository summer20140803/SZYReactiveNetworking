//
//  TDFReactive.h
//  TDFReactiveExample
//
//  Created by 开不了口的猫 on 2017/7/13.
//  Copyright © 2017年 TDF. All rights reserved.
//

#ifndef TDFReactive_h
#define TDFReactive_h

#if __has_include(<TDFReactive/TDFReactive.h>)
#import <TDFReactive/TDFReactiveMacro.h>
#import <TDFReactive/TDFSignalPacket.h>
#import <TDFReactive/TDFCommandPacket.h>
#import <TDFReactive/TDFReactiveAPIManager.h>
#import <TDFReactive/TDFReactiveAPIManagerTrigger.h>
#import <TDFReactive/TDFReactivePageAPIManager.h>
#import <TDFReactive/TDFReactiveBatchAPIManager.h>
#import <TDFReactive/NSArray+Reactive.h>
#import <TDFReactive/NSDictionary+Reactive.h>
#import <TDFReactive/NSObject+Reactive.h>
#import <TDFReactive/UIButton+Reactive.h>
#import <TDFReactive/UIControl+Reactive.h>
#import <TDFReactive/TDFKVPair.h>
#else
#import "TDFReactiveMacro.h"
#import "TDFSignalPacket.h"
#import "TDFCommandPacket.h"
#import "TDFReactiveAPIManager.h"
#import "TDFReactiveAPIManagerTrigger.h"
#import "TDFReactivePageAPIManager.h"
#import "TDFReactiveBatchAPIManager.h"
#import "NSArray+Reactive.h"
#import "NSDictionary+Reactive.h"
#import "NSObject+Reactive.h"
#import "UIButton+Reactive.h"
#import "UIControl+Reactive.h"
#import "TDFKVPair.h"
#endif

#endif /* TDFReactive_h */
