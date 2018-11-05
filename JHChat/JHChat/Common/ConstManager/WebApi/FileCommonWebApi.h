//
//  FileCommonWebApi.h
//  LeadingCloud
//
//  Created by SY on 16/8/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef FileCommonWebApi_h
#define FileCommonWebApi_h

#endif /* FileCommonWebApi_h */

static NSString * const WebApi_FileCommon = @"api/filecommon";

/* 替换数据 GET */
static NSString * const WebApi_FileCommon_ReplaceDataWithRpid = @"api/resource/replacedata/{rpid}/{tokenid}";
static NSString * const WebApi_FileCommon_ReplaceDataNotRpid = @"api/resource/replacedata/{tokenid}";
/* 创建资源池 */
static NSString * const WebApi_FileCommon_CreatePool = @"api/resource/createpool/{bindid}/{bindtype}/{userid}/{tokenid}";

/**************** 文件夹 ****************/
/* 获取所有文件夹节点 */
static NSString * const WebApi_FileCommon_GetFolderList = @"api/resource/folder/getfolder/{rpid}/{tokenid}";
/* 获取下级文件夹列表节点 */
static NSString * const WebApi_FileCommon_GetNextFolderList = @"api/resource/folder/getfolder/{rpid}/{folderids}/{tokenid}";
/* 获取展示文件夹（包括内部资源） GET*/
static NSString * const WebApi_FileCommon_Getfolder = @"api/resource/getfolder/{rpid}/{partitiontype}/{folderid}/{tokenid}";
/* 增加文件夹 */
static NSString * const WebApi_FileCommon_AddFolder = @"api/resource/folder/addfolder/{tokenid}";
/* 修改文件夹 */
static NSString * const webApi_FileCommon_EditFolder = @"api/resource/folder/editfolder/{tokenid}";
/* 导入文件夹 */
static NSString * const WebApi_FileCommon_ImportFolder = @"api/resource/folder/import/{tokenid}";

/**************** 文件 ****************/
/* 批量增加新资源 POST */
static NSString * const WebApi_FileCommon_AddResourceList = @"api/resource/addresourcelist/{tokenid}";
/* 获取列表数据 POST */
static NSString * const WebApi_FileCommon_GetDataList = @"api/resource/list/{tokenid}";
/* 增加新资源 POST */
static NSString * const WebApi_FileCommon_AddResource = @"api/resource/addresource/{tokenid}";
/* 增加新资源包 POST */
static NSString * const WebApi_FileCommon_AddResBag = @"api/resource/addresourcebag/{tokenid}";
/* 升级资源 POST */
static NSString * const WebApi_FileCommon_UpgradeRes = @"api/resource/upgraderesource/{tokenid}";
/* 资源替换 POST */
static NSString * const WebApi_FileCommon_ReplaceRes = @"api/resource/replaceresource/{tokenid}";
/* 展示资源 GET */
static NSString * const WebApi_FileCommon_GalleryRes = @"api/resource/gallery/{resourceid}/{tokenid}";
/* 展示资源(带版本号的) GET */
static NSString * const WebApi_FileCommon_GallerymainWithVersion = @"api/resource/gallerymain/{resourceid}/{version}/{tokenid}";
/* 展示资源主信息 GET */
static NSString * const WebApi_FileCommon_Gallerymain = @"api/resource/gallerymain/{resourceids}/{tokenid}";
/*  展示资源(如果是资源、展示资源主信息(指定版本)，如果是资源项、展示资源项信息(资源项无版本信息)) */
static NSString * const WebApi_FileCommon_GallerymodeloritemWithVersion = @"api/resource/gallerymodeloritem/{resourceid}/{version}/{tokenid}";
/* 展示资源项信息 GET */
static NSString * const WebApi_FileCommon_ItemInfo = @"api/resource/item/{resourceid}/{tokenid}";
/* 展示资源项信息(带版本) GET */
static NSString * const WebApi_FileCommon_ItemInfoWithVersion = @"api/resource/item/{resourceid}/{version}/{tokenid}";
/* 展示资源所有版本信息 GET */
static NSString * const WebApi_FileCommon_VersionAll = @"api/resource/versionall/{resourceid}/{tokenid}";
/* 资源下载 GET */
static NSString * const WebApi_FileCommon_Download = @"api/Resource/Download/{resourceid}/{tokenid}";
/* 资源下载（带版本） GET*/
static NSString * const WebApi_FileCommon_DownloadWithVersion = @"api/Resource/Download/{resourceid}/{version}/{tokenid}";
/* 混合下载 POST*/
static NSString * const WebApi_FileComon_MixDownload = @"api/Resource/MixDownload/{tokenid}";
/* 拷贝资源 POST */
static NSString * const WebApi_FileCommon_copyResource = @"api/resource/copyresource/{targetrpid}/{targetpartitiontype}/{folderid}/{tokenid}";
/*重命名资源名称 */
static NSString * const WebApi_FileCommon_ReNameResource = @"api/Resource/ReNameResource/{tokenid}";



/* 删除资源 */
static NSString * const WebApi_FileCommon_DelResource = @"api/Resource/DelResource/{rpid}/{tokenid}";
/* 批量删除资源 */
static NSString * const WebApi_FileCommon_DelBatchDelete = @"api/Resource/DelBatchDelete/{tokenid}";
/* 移动资源 */
static NSString * const WebApi_FileCommon_MoveResourceFodler = @"api/Resource/EditResourceFodler/{folderid}/{tokenid}";


/* 文件上传js插件 --> 文件替换 */
static NSString * const WebApi_FileUploadJSNC_ReplaceUpload = @"api/fileserver/replaceupload/{filedid}/{tokenid}";

/* 限制文档类型的 */
static NSString * const WebApi_FileUploadExp_LimitUpload = @"api/fileserver/uploadfileexp/{tokenid}";
/* 获取以及其子文件夹和子资源（不递归获取资源） GET */
static NSString *const WebApi_FileCommom_GetfolderAndResource = @"api/resource/folder/getfolderandresource/{rpid}/{partitiontype}/{folderid}/{tokenid}";
/* 获取文件夹指定节点*/
static NSString * const WebApi_FileCommon_GetFolderOne = @"api/resource/folder/getfolderone/{rpid}/{folderid}/{tokenid}";



