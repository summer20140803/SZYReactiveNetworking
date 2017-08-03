//
//  TDFGeneralPageAPI+APIDebugger.h
//  Pods
//
//  Created by 开不了口的猫 on 2017/7/12.
//
//

#import <TDFAPIKit/TDFAPIKit.h>
#import "TDFAPIDebugger.h"

@interface TDFGeneralPageAPI (APIDebugger)

#if DEBUG && !ENTERPRISE
@property (nonatomic, weak) id<TDFAPIDebuggerDataSource> dataSource;
#endif

@end
