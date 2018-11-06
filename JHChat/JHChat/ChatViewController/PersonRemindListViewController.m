//
//  PersonRemindListViewController.m
//  LeadingCloud
//
//  Created by dfl on 2017/12/1.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "PersonRemindListViewController.h"
#import "AppDateUtil.h"
#import "CommonFontModel.h"
#import "PersonRemindListTableViewCell.h"

@interface PersonRemindListViewController (){
    CGFloat curRatio;
}

@end

@implementation PersonRemindListViewController

- (void)viewDidLoad {
    self.isContainRefresh = YES;
    [super viewDidLoad];
    
    self.title = @"个人提醒";
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];

    [self addCustomDefaultBackButton:LZGDCommonLocailzableString(@"common_back")];
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"PersonRemindListViewController"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [(LZBaseTableView*)self.tableView hideLoadAndEmptyView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengUtil endLogPageView:@"PersonRemindListViewController"];
}
- (void)dealloc {
    
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RefreshSecondMsgVC);
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    return 1;
}

//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 0*curRatio;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return LZ_TableViewCell_Height54*curRatio;
    } else {
        return LZ_TableViewCell_Height64*curRatio;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [[UITableViewCell alloc] init];
    }else{
        static NSString *cellIdentifier = @"personRemindListTableViewCell";
        PersonRemindListTableViewCell *cell = (PersonRemindListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PersonRemindListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
//        BusinessSessionRecentModel *recentModels = self.dataSource[indexPath.row];
        
        [cell setupViewModelItem:nil atIndexPath:indexPath isBottom:NO];
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *commonVC = nil;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
    }
    else {
        
    }
    if(commonVC != nil){
        [self.navigationController pushViewController:commonVC animated:YES];
    }
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        //取消搜索状态
        [self.searchDisplayController setActive:NO animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
