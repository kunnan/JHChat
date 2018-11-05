//
//  AppConst.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef AppConst_h
#define AppConst_h


#endif /* AppConst_h */

static NSString * const File_Upload_FileType_File = @"file"; //网盘，文件
static NSString * const File_Upload_FileType_Icon = @"icon"; //图标
static NSString * const File_Upload_FileType_Face = @"face"; //头像
static NSString * const File_Upload_FileType_IM = @"im"; //消息

static NSString * const Res_Rpid_Icon = @"11112"; //图标资源池Id
static NSString * const Res_Rpid_Face = @"11113"; //头像资源池Id
static NSString * const Res_Rpid_IM = @"11114"; //消息资源池Id
static NSString * const Res_Rpid_Zip = @"11115"; //压缩解压缩资源池Id
static NSString * const Res_Rpid_Uedit = @"11116"; //文本编辑器资源池Id


static NSInteger const App_NetDisk_File_UploadSuccess = 0; //上传成功
static NSInteger const App_NetDisk_File_UploadIng = 3;     //上传中
static NSInteger const App_NetDisk_File_UploadFail = 5;    //上传失败

static NSInteger const App_NetDisk_File_NoDownload = 0; //未下载
static NSInteger const App_NetDisk_File_DownloadSuccess = 3; //下载成功
static NSInteger const App_NetDisk_File_DownloadFail = 5; //下载失败

static NSString * const App_NetDisk_Sort_Date_Desc = @"1"; //按时间倒序排序
static NSString * const App_NetDisk_Sort_Date_Asc = @"2";  //按时间正序排序
static NSString * const App_NetDisk_Sort_Name_Desc = @"4"; //按名称倒序排序
static NSString * const App_NetDisk_Sort_Name_Asc = @"5";  //按名称正序排序
static NSString * const App_NetDisk_Sort_Size_Desc = @"7"; //按大小倒序排序
static NSString * const App_NetDisk_Sort_Size_Asc = @"8";  //按大小正序排序

static NSString * const App_NetDisk_Sort_CollectDate_Desc = @"11"; //收藏按时间倒序排序
