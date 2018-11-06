//
//  PersonRemindSettingViewController.m
//  LeadingCloud
//
//  Created by gjh on 2018/5/15.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "PersonRemindSettingViewController.h"
#import "CommonFontModel.h"
#import "ImRecentDAL.h"

@interface PersonRemindSettingViewController () {
    
    UISwitch *stickToTop;
    UISwitch *noDisturb;
    CGFloat curRatio;
}

@end

@implementation PersonRemindSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LZGDCommonLocailzableString(@"common_setting");
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    /* 初始化数据 */
    [self loadData];
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    [self addCustomDefaultBackButton:LZGDCommonLocailzableString(@"common_back")];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"ChatOneSettingController"];
    //注册订阅
    EVENT_SUBSCRIBE(self, EventBus_WebApi_SetRecentStick);
    EVENT_SUBSCRIBE(self, EventBus_WebApi_SetRecentOneDisturb);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UMengUtil endLogPageView:@"ChatOneSettingController"];
    //取消订阅
    EVENT_UNSUBSCRIBE(self, EventBus_WebApi_SetRecentStick);
    EVENT_UNSUBSCRIBE(self, EventBus_WebApi_SetRecentOneDisturb);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
    _contactid = nil;
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}
/**
 *  组织数据
 */
-(void)loadData{
    [self.tableDataSourceArr removeAllObjects];
    
    //第二组 聊天文件，置顶
    NSMutableArray *secondGroupArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *stickToTop = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_msg_sticktotop"),LEFTTITLE,@"",RIGHTTITLE,@"no",CellAccessory,@"",SELECTOR,@"sticktotop",CUSTOMVIEW,nil];
    NSMutableDictionary *noDisturb = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_msg_no_distrub"),LEFTTITLE,@"",RIGHTTITLE,@"no",CellAccessory,@"",SELECTOR,@"nodisturb",CUSTOMVIEW,nil];
    
    [secondGroupArr addObject:stickToTop];
    [secondGroupArr addObject:noDisturb];
    
    if(secondGroupArr.count>0){
        [self.tableDataSourceArr addObject:secondGroupArr];
    }
}

/**
 *  返回按钮方法处理
 */
-(void)customDefaultBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自定义处理

/**
 *  初始化自定义视图
 */
-(void)initCellCustomView:(NSMutableDictionary *)obj{
    UITableViewCell *cell = [obj objectForKey:@"cell"];
    NSMutableDictionary *itemDic = [obj lzNSMutableDictionaryForKey:@"data"];
    if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"sticktotop"]) {
        NSString *left = [itemDic lzNSStringForKey:LEFTTITLE];
        UILabel *lblLeftTitle = [cell.contentView viewWithTag:101];
        lblLeftTitle.text = left;
        
        stickToTop = [[UISwitch alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-50-15, 7*curRatio, (44-7*2)*curRatio, 10*curRatio)];
        [stickToTop addTarget:self action:@selector(stickToTopClick:) forControlEvents:UIControlEventValueChanged];
        
        BOOL isStickToTop = [[ImRecentDAL shareInstance] checkRecentModelIsStick:_contactid];
        [stickToTop setOn:isStickToTop];
        for(UIView *subView in [cell.contentView subviews]){
            if([subView isKindOfClass:[UISwitch class]]){
                [subView removeFromSuperview];
            }
        }
        [cell.contentView addSubview:stickToTop];
    }
    else if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"nodisturb"]) {
        NSString *left = [itemDic lzNSStringForKey:LEFTTITLE];
        UILabel *lblLeftTitle = [cell.contentView viewWithTag:101];
        lblLeftTitle.text = left;
        
        noDisturb = [[UISwitch alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-50-15, 7*curRatio, (44-7*2)*curRatio, 10*curRatio)];
        [noDisturb addTarget:self action:@selector(noDisturbClick:) forControlEvents:UIControlEventValueChanged];
        
        BOOL isNoDisturb = [[ImRecentDAL shareInstance] checkRecentModelIsNoDisturb:_contactid];
        [noDisturb setOn:isNoDisturb];
        for(UIView *subView in [cell.contentView subviews]){
            if([subView isKindOfClass:[UISwitch class]]){
                [subView removeFromSuperview];
            }
        }
        [cell.contentView addSubview:noDisturb];
    }
    
}

/**
 *  处理cell点击事件
 */
-(void)afterCellDidSelect:(NSMutableDictionary *)obj{
    NSMutableDictionary *itemDic = [obj lzNSMutableDictionaryForKey:@"data"];
    
    if([[itemDic objectForKey:CUSTOMVIEW] isEqualToString:@""]){
        
        NSString *selector = [itemDic lzNSStringForKey:SELECTOR];
        
        if( ![NSString isNullOrEmpty:selector] ){
            SEL sel = NSSelectorFromString(selector);
            if([self respondsToSelector:sel])
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

                [self performSelector:sel withObject:nil];
                
                #pragma clang diagnostic pop
            }
        }
    }
}

/* 聊天框置顶 */
- (void)stickToTopClick:(id)sender {
    BOOL isButtonOn = [stickToTop isOn];
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:_contactid forKey:@"recentid"];
    if (isButtonOn) {
        [getData setObject:@"1" forKey:@"state"];
    } else {
        [getData setObject:@"0" forKey:@"state"];
    }
    /* 判断网络是否连通 */
    if ([LZUserDataManager readIsConnectNetWork]) {
        [self showLoadingInfo];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_SetRecentStick
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    } else {
        [self showNetWorkConnectFail];
        [stickToTop setOn:!isButtonOn];
    }
}

- (void)noDisturbClick:(id)sender {
    BOOL isButtonOn = [noDisturb isOn];
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:_contactid forKey:@"recentid"];
    
    if (isButtonOn) {
        [getData setObject:@"1" forKey:@"state"];
    } else {
        [getData setObject:@"0" forKey:@"state"];
    }
    /* 判断网络是否连通 */
    if ([LZUserDataManager readIsConnectNetWork]) {
        [self showLoadingInfo];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_SetRecentDisturb
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    } else {
        [self showNetWorkConnectFail];
        [noDisturb setOn:!isButtonOn];
    }
}

#pragma mark - EventBus Delegate

/*
 事件代理
 */
- (void)eventOccurred:(NSString *)eventName event:(Event *)event
{
    [super eventOccurred:eventName event:event];
    if([eventName isEqualToString:EventBus_WebApi_SetRecentStick] ||
       [eventName isEqualToString:EventBus_WebApi_SetRecentOneDisturb]) {
        [self hideLoading];
    }
}

@end
