//
//  MessageRootViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/17.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-17
 Version: 1.0
 Description: 消息页签数据ViewModel
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@class MessageRootTableViewCellViewModel;
@interface MessageRootViewModel : BaseViewModel

@property (nonatomic,strong) NSMutableArray *arrCellItem;

/**
 *  获取ViewModel数据源
 */
-(void)getViewDataSource:(NSString *)selectGUID;

///**
// *  获取搜索后的数据源
// */
//-(NSMutableArray *)getViewSearchDataSource:(NSString *)sarchText;

/**
 *  获取ViewModel选择数据源
 */
-(void)getViewDataSourceForSelect;

/**
 *  将行数据源转为cellViewModel
 *
 *  @param cellData 数据库对应Model
 *
 *  @return MessageRootTableViewCellViewModel
 */
-(MessageRootTableViewCellViewModel *)resetToCellViewModel:(id)cellData;

@end
