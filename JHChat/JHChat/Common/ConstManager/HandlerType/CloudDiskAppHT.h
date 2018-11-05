//
//  CloudDiskAppHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef CloudDiskAppHT_h
#define CloudDiskAppHT_h


#endif /* CloudDiskAppHT_h */

/* =================================网盘(clouddiskapp)================================= */
static NSString * const Handler_CloudDiskApp = @"clouddiskapp"; //  一级

/* 操作(noraml) */
static NSString * const Handler_CloudDiskApp_Normal = @"normal";  // 二级
static NSString * const Handler_CloudDiskApp_Normal_Add  = @"clouddiskapp.normal.add";  //新增--临时通知(处理)
static NSString * const Handler_CloudDiskApp_Normal_Update  = @"clouddiskapp.normal.update";  //修改--临时通知(处理)
static NSString * const Handler_CloudDiskApp_Normal_UpdateName  = @"clouddiskapp.normal.updatename";  //修改名称--临时通知(处理)
static NSString * const Handler_CloudDiskApp_Normal_Delete  = @"clouddiskapp.normal.delete";  //删除--临时通知(处理)
static NSString * const Handler_CloudDiskApp_Normal_Move  = @"clouddiskapp.normal.move";  //移动--临时通知(处理)

/* 分享 */
static NSString * const Handler_CloudDiskApp_Share = @"share";
static NSString * const Handler_CloudDiskApp_Share_Add = @"clouddiskapp.share.add"; // 新增--临时通知(处理)
static NSString * const Handler_CloudDiskApp_Share_Delete = @"clouddiskapp.share.delete"; //删除--临时通知（处理）

/* 回收站 */
static NSString * const Handler_CloudDiskApp_Recycle = @"recycle";
static NSString * const Handler_CloudDiskApp_Recycle_Add = @"clouddiskapp.recycle.add"; //新增--临时通知 0
static NSString * const Handler_CloudDiskApp_Recycle_Delete = @"clouddiskapp.recycle.delete"; // 删除--临时通知 1
static NSString * const Handler_CloudDiskApp_Recycle_Clear = @"clouddiskapp.recycle.clear"; // 清空回收站--临时通知 1














