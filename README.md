


# <center><font color=black size=6>TDFReactive</font></center> 

## Features
-----------

1. 常用的Reactive功能分类

2. 离散型APIManager体系

- [x] 普通单页API、分页API用法统一并标准化(将loader、hudPresenter、api内嵌)
- [x] 单API支持并发、淘汰机制
- [x] API的起飞与着陆可自由控制
- [x] 批量API(请求链和请求组)
- [x] API的参数内部转化(外部不用转化成NSString)
- [x] 本地数据Mock体系
- [x] ......


## Requirements
---------------

- iOS 8.0 or later

## Communication
----------------

- DingDing 藕粉
- summer20140803@gmail.com

## Installation
---------------
TDFReactive is available through CocoaPods. To install it, simply add the following line to your Podfile:

    pod 'TDFReactive'

## Usage
--------
<b>1.普通单页APIManager的创建</b>
<br>首先继承TDFReactiveAPIManager创建一个自己的APIManager，然后在.m关联一个继承于TDFGeneralAPI的API

	#import "ChildAPIManager.h"
	#import "ChildRequestModel.h"
	
	@implementation ChildAPIManager
	
	@synthesize api = _api;
	
	- (TDFGeneralAPI *)api {
	    if (!_api) {
	        _api = [[TDFGeneralAPI alloc] init];
	        _api.requestModel = [[ChildRequestModel alloc] init];
	        _api.apiResponseReformBlock = ^id(__kindof TDFBaseAPI *api, id response) {
	            return response[@"data"];
	        };
	    }
	    return _api;
	}
	
	@end
<b>2.分页PageAPIManager的创建</b>
<br>首先继承TDFReactivePageAPIManager创建一个自己的PageAPIManager，然后在.m关联一个继承于TDFGeneralPageAPI的API

    #import "ChildPageAPIManager.h"
	#import "ChildRequestModel.h"
	
	@implementation ChildPageAPIManager
	
	@synthesize api = _api;
	
	- (TDFGeneralPageAPI *)api {
	    if (!_api) {
	        _api = [[TDFGeneralPageAPI alloc] init];
	        _api.requestModel = [[ChildRequestModel alloc] init];
	        _api.apiResponseReformBlock = ^id(__kindof TDFBaseAPI *api, id response) {
	            return response[@"data"][@"xxxlist"];
	        };
	        _api.currentPageSizeBlock = ^NSInteger(id response) {
	            return [response[@"data"][@"xxxlist"] count];
	        };
	    }
	    return _api;
	}
	
	@end

<b>3.业务Controller中的APIManager使用</b>
      
	//
	//  ViewController.m
	//  TDFReactiveExample
	//
	//  Created by 开不了口的猫 on 2017/7/13.
	//  Copyright © 2017年 TDF. All rights reserved.
	//

	#import "ViewController.h"
	#import "TDFReactive.h"
	#import "ChildAPIManager.h"

	@interface ViewController ()

	//====================================
	//            普通的APIM
	//====================================
	@property (nonatomic, strong) ChildAPIManager *normalAPIM;
	
	//====================================
	//           带有配置的APIM
	//====================================
	@property (nonatomic, strong) ChildAPIManager *triggerAPIM;
	
	//====================================
	//           用于批量的APIM
	//====================================
	@property (nonatomic, strong) ChildAPIManager *groupAPIM_1;
	@property (nonatomic, strong) ChildAPIManager *groupAPIM_2;
	@property (nonatomic, strong) ChildAPIManager *groupAPIM_3;
	
	@property (nonatomic, strong) ChildAPIManager *chainAPIM_1;
	@property (nonatomic, strong) ChildAPIManager *chainAPIM_2;
	@property (nonatomic, strong) ChildAPIManager *chainAPIM_3;
	
	@property (nonatomic, strong) TDFReactiveBatchAPIManager *batchManager;
	
	//====================================
	//           用于分页的APIM
	//====================================
	@property (nonatomic, strong) TDFReactivePageAPIManager *pageAPIM;
	
	//====================================
	//              示例用
	//====================================
	@property (nonatomic, copy)   NSString    *parameter_value;
	@property (nonatomic, strong) UITableView *tableView;
	
	@property (nonatomic, assign) BOOL *pollingStop;
	
	@end
	
	@implementation ViewController
	
	- (void)viewDidLoad {
	    [super viewDidLoad];
	}
	
	#pragma mark - 普通的API请求 -
	- (ChildAPIManager *)normalAPIM {
	    if (!_normalAPIM) {
	        _normalAPIM = [ChildAPIManager apiManager];
	        @weakify(self)
	        _normalAPIM.apiParamsFetcher = ^NSDictionary *{
	            @strongify(self)
	            return @{@"request_parameter" : self.parameter_value};
	        };
	        _normalAPIM.hudLayer = self.view;
	        _normalAPIM.apiSuccessHandler = ^(__kindof TDFGeneralAPI *api, id response) {
	            /// 接收数据，渲染页面
	        };
	    }
	    return _normalAPIM;
	}
	
	- (void)normalAPIRequest {
	    [self.normalAPIM start];
	}
	
	
	
	#pragma mark - 带有配置的API请求 -
	- (ChildAPIManager *)triggerAPIM {
	    if (!_triggerAPIM) {
	        _triggerAPIM = [ChildAPIManager apiManager];
	        @weakify(self)
	        _triggerAPIM.apiParamsFetcher = ^NSDictionary *{
	            @strongify(self)
	            return @{@"request_parameter" : self.parameter_value};
	        };
	        _triggerAPIM.hudLayer = self.view;
	        
	        ////////////////////////////////////////////////
	        
	        _triggerAPIM.eliminateEnable = YES;
	        _triggerAPIM.concurrencySupport = YES;
	        _triggerAPIM.apiSuccessHandler = ^(__kindof TDFGeneralAPI *api, id response) {
	            /// 接收数据，渲染页面
	        };
	        
	        ////////////////////////////////////////////////
	    }
	    return _triggerAPIM;
	}
	
	- (void)triggerAPIRequest {
	    BOOL stop = NO;
	    self.pollingStop = &stop;
	    [self.triggerAPIM startWithConfigurations:^(TDFReactiveAPIManagerTrigger *trigger) {
	        /// 做一些关于request的配置
	        trigger.delay(2).retry.pollingFew(2,self.pollingStop);
	    }];
	}
	
	#pragma mark - 批量API请求-链式依赖 -
	- (void)chainAPIRequest {
	    self.batchManager = [TDFReactiveBatchAPIManager batchManager];
	    [self.batchManager doRequestsChainWithAPIManagers:@[self.chainAPIM_1,
	                                                        self.chainAPIM_2,
	                                                        self.chainAPIM_3]
	    completion:^(BOOL isFinish) {
	        /// isFinish决定后续操作
	        NSLog(@"%d", isFinish);
	    }];
	    [self.batchManager break];
	}
	
	
	
	#pragma mark - 批量API请求-组依赖 -
	- (void)groupAPIRequest {
	    self.batchManager = [TDFReactiveBatchAPIManager batchManager];
	    [self.batchManager doRequestsGroupWithAPIManagers:@[self.groupAPIM_1,
	                                                        self.groupAPIM_2,
	                                                        self.groupAPIM_3]
	    completion:^(BOOL isFinish) {
	        /// isFinish决定后续操作
	        NSLog(@"%d", isFinish);
	    }];
	    [self.batchManager break];
	}
	
	
	
	
	#pragma mark - 分页API请求 -
	- (TDFReactivePageAPIManager *)pageAPIM {
	    if (!_pageAPIM) {
	        _pageAPIM = [TDFReactivePageAPIManager apiManagerWithScrollView:self.tableView];
	        @weakify(self)
	        _pageAPIM.apiParamsFetcher = ^NSDictionary *{
	            @strongify(self)
	            return @{@"request_parameter" : self.parameter_value};
	        };
	        _pageAPIM.hudLayer = self.view;
	        _pageAPIM.shouldAddFooterRefresh = NO;
	        _pageAPIM.shouldAddHeaderRefresh = YES;
	        _pageAPIM.itemTransformHandler = ^NSArray *(NSArray *data) {
	            /// 将api加工后的数据(一般是模型)转化为自定义的item或者其他用于渲染页面的单元，这其实是可选的
	            return @[];
	        };
	        _pageAPIM.headerRefreshHandler = ^(NSArray *newItems) {
	            /// 头部刷新->API->API数据加工->itemTransformHandler数据加工->这个回调
	        };
	        _pageAPIM.footerRefreshHandler = ^(NSArray *newItems) {
	            /// 尾部刷新->API->API数据加工->itemTransformHandler数据加工->这个回调
	        };
	    }
	    return _pageAPIM;
	}
	
	- (void)pageAPIRequest {
	    ///1.手滑scrollView的顶部或者底部触发
	    
	    ///2.手动调用start加载第一页
	    [self.pageAPIM start];
	}
	
	@end

<b>4.未详尽功能想进一步了解，请联系作者</b>


## Architecture

* NSArray+Reactive
* NSDictionary+Reactive
* UIButton+Reactive
* UIControl+Reactive
* UITextField+Reactive
* NSObject+Reactive
* TDFReactiveAPIManager
* TDFReactivePageAPIManager
* TDFReactiveBatchAPIManager
* TDFReactiveAPIManagerTrigger
* TDFAPIDebugger