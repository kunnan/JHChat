//
//  PersonRemindSettingViewController.h
//  LeadingCloud
//
//  Created by gjh on 2018/5/15.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ChatSettingController.h"
//#import "ImRecentDAL.h"
//#import "ImRecentModel.h"

@interface PersonRemindSettingViewController : ChatSettingController<UITableViewDelegate,UITableViewDataSource,EventSyncSubscriber>

@property (copy, nonatomic) NSString *contactid;

@end
