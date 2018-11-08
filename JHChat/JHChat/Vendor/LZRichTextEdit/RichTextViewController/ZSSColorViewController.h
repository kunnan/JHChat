//
//  ZSSColorViewController.h
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/12/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@protocol CooperationTaskDetialEditDelegate <NSObject>


-(void)CooperationTaskChangeDetial:(NSString*)name;


@end

@interface ZSSColorViewController : ZSSRichTextEditor

/**
 导航title
 */
@property (nonatomic, strong) NSString *taskName;

/**
 已有文本
 */
@property(nonatomic,copy)NSString *taskdetial;


@property(nonatomic,copy)NSString *taskID;
@property(nonatomic,assign)id<CooperationTaskDetialEditDelegate>delegate;

/**
 是否展示插入img项
 */
//@property (nonatomic, assign) BOOL isShowAddImgItem;
@end
