//
//  ChatSettingController.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "XHBaseViewController.h"
#import "MWPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "TZImagePickerViewModel.h"

#define LEFTTITLE   @"lefttitle"
#define CellAccessory @"cellaccessory"
#define RIGHTTYYPE  @"righttype"
#define RIGHTTITLE  @"righttitle"
#define SELECTOR   @"selector"
#define CUSTOMVIEW   @"customview"

@interface ChatSettingController : XHBaseViewController<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>

@property (strong, nonatomic) LZBaseTableView *mainTableView; //tableView
/* 列表数据源 */
@property (strong, nonatomic) NSMutableArray *tableDataSourceArr;

/* 聊天文件 */
@property (strong, nonatomic) NSMutableArray *fileBrowserArr;
/* 聊天图片 */
@property (strong, nonatomic) NSMutableArray *imageBrowserArr;


/**
 *  查看文件
 */
-(void)showChatViewControllerFile:(NSString *)dialogId;

@end
