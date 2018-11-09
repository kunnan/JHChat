//
//  PostFileModel.h
//  LeadingCloud
//
//  Created by wang on 16/3/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2015-03-18
 Version: 1.0
 Description: 收藏信息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostFileModel : NSObject
/*展示尺寸*/
@property(nonatomic,strong)NSString *showsize;

@property(nonatomic,assign)BOOL iscurrentversion;

@property(nonatomic,strong)NSString *iconurl;

@property(nonatomic,assign)NSInteger subcount;

@property(nonatomic,strong)NSDate *updatedate;

@property(nonatomic,strong)NSString *icon;

@property(nonatomic,assign)NSInteger rtype;
/**/
@property(nonatomic,strong)NSString *expid;

@property(nonatomic,strong)NSString *updateusername;

@property(nonatomic,strong)NSString *name;
/*展示名字*/
@property(nonatomic,strong)NSString *showname;

@property(nonatomic,strong)NSString *version;
/*尺寸*/
@property(nonatomic,assign)NSInteger size;

@property(nonatomic,strong)NSString *versionid;

@property(nonatomic,assign)NSInteger sortindex;

@property(nonatomic,strong)NSDictionary *resourcefavorite;

@property(nonatomic,strong)NSString *classid;

//？？？
@property(nonatomic,strong)NSString *rpid;
/*文件类型*/
@property(nonatomic,strong)NSString *exptype;
/*版本*/
@property(nonatomic,strong)NSString *showversion;

/*文件ID*/
@property(nonatomic,strong)NSString *rid;

@property(nonatomic,strong)NSString *expandinfo;

//description
@property(nonatomic,strong)NSString *descripti;

@property(nonatomic,strong)NSString *postID;

//图片宽高 (cell 使用)
@property(nonatomic,assign)CGFloat picWidth;
@property(nonatomic,assign)CGFloat picHeight;


@end
