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

@property (nonatomic, strong) NSString *taskName;
@property(nonatomic,copy)NSString *taskdetial;
@property(nonatomic,copy)NSString *taskID;
@property(nonatomic,assign)id<CooperationTaskDetialEditDelegate>delegate;
@end
