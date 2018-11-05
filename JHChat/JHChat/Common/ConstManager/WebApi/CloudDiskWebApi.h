//
//  CloudDiskWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef CloudDiskWebApi_h
#define CloudDiskWebApi_h


#endif /* CloudDiskWebApi_h */

/*-------------------云盘相关，文件夹--------------------*/
static NSString * const WebApi_CloudDiskFolder = @"api/CloudDiskApp/Folder";
/* 获取云盘文件夹 */
static NSString * const WebApi_CloudDiskFolder_GetFolder = @"api/CloudDiskApp/Folder/GetFolder/{tokenid}";
/* 获取文件夹信息 */
static NSString * const WebApi_CloudDiskFolder_GetFolderInfo = @"/api/CloudDiskApp/Folder/GetFolder/{classid}/{tokenid}";
/* 新建文件夹 */
static NSString * const WebApi_CloudDiskFolder_AddFolder = @"api/CloudDiskApp/Folder/AddFolder/{parentid}/{tokenid}";
/* 文件夹重命名 */
static NSString * const WebApi_CloudDiskFolder_EditFolder = @"api/CloudDiskApp/Folder/EditFolder/{tokenid}";
/* 文件夹修改 */
static NSString * const WebApi_CloudDiskFolder_EditFolderInfo = @"api/CloudDiskApp/Folder/EditFolderInfo/{tokenid}";
/* 删除文件夹 */
static NSString * const WebApi_CloudDiskFolder_DelFolder = @"api/CloudDiskApp/Folder/DelFolder/{id}/{tokenid}";
/* 文件夹移动 */
static NSString * const WebApi_CloudDiskFile_EditFolderParentFodler = @"api/CloudDiskApp/EditFolderParentFodler/{folderid}/{parentfolderid}/{tokenid}";

/*-------------------云盘相关，文件--------------------*/
static NSString * const WebApi_CloudDiskFile = @"api/CloudDiskApp";
/* 获取文件列表数据 */
static NSString * const WebApi_CloudDiskFile_List = @"api/CloudDiskApp/List/{tokenid}";
/* 获取文件信息 */
static NSString * const WebApi_CloudDiskFile_GetResInfo = @"api/resource/gallerymain/{resourceids}/{tokenid}";
/* 获取文件信息--版本 */
static NSString * const WebApi_CloudDiskFile_GetResVersionInfo = @"api/resource/gallerymain/{resourceid}/{version}/{tokenid}";

/* 获取文件信息--资源项 */
static NSString * const WebApi_CloudDiskFile_GetResInfoModelOrItem = @"api/resource/gallerymodeloritem/{rid}/{tokenid}";
/* 获取文件信息--资源项--版本 */
static NSString * const WebApi_CloudDiskFile_GetResVersionInfoModelOrItem = @"api/resource/gallerymodeloritem/{rid}/{version}/{tokenid}";
/* 资源保存到云盘 不带版本号的*/
static NSString * const WebApi_CloudDiskFile_SaveToNetDiskNOVersion = @"api/CloudDiskApp/SaveToCloudDisk/{folderid}/{tokenid}";
/* 增加新资源 */
static NSString * const WebApi_CloudDiskFile_AddResource = @"api/CloudDiskApp/AddResource/{tokenid}";
/* 保存至网盘 */
static NSString * const WebApi_CloudDiskFile_SaveToCloudDisk = @"api/CloudDiskApp/SaveToCloudDisk/{folderid}/{resourceid}/{version}/{tokenid}";
/* 文件新版本 */
static NSString * const WebApi_CloudDiskFile_UpgradeResource = @"api/CloudDiskApp/UpgradeResource/{tokenid}";
/* 覆盖此版本 */
static NSString * const WebApi_CloudDiskFile_ReplaceResource = @"api/CloudDiskApp/ReplaceResource/{tokenid}";
/* 删除文件 */
static NSString * const WebApi_CloudDiskFile_DelResource = @"api/CloudDiskApp/DelResource/{tokenid}";
/* 文件重命名 */
static NSString * const WebApi_CloudDiskFile_ReNameResource = @"api/CloudDiskApp/ReNameResource/{tokenid}";

/* 修改资源 （名称和描述）2018.08.09 */
static NSString * const WebApi_CloudDiskFile_EditResourceInfo = @"api/CloudDiskApp/EditResourceInfo/{tokenid}";
/* 获取资源详细信息 */
static NSString * const WebApi_CloudDiskFile_GetResourceDetails = @"api/CloudDiskApp/getresourcedetails/{tokenid}";
/* 获取文件夹详情 */
static NSString * const WebApi_CloudDiskFilDe_GetFolderDetails = @"api/CloudDiskApp/getfolderdetails/{tokenid}";

/* 文件的移动 */
static NSString * const WebApi_CloudDiskFile_EditResourceFolder = @"api/CloudDiskApp/EditResourceFodler/{folderid}/{tokenid}";
/* 文件历史版本 */
static NSString * const WebApi_CloudDiskFile_Versionall = @"api/resource/versionall/{rid}/{tokenid}";
/*获取文件包里面的所有数据 */
static NSString * const WebApi_CloudDiskFile_getBagInfo = @"api/resource/item/{resourceid}/{tokenid}";
/* 获取文件包里面的所有数据 */
static NSString * const WebApi_ClouDiskFile_GetHaveVersionBag = @"api/resource/item/{resourceid}/{version}/{tokenid}";
/* 混合下载 */
static NSString * const WebApi_CloudDiskFile_MixDownload = @"api/Resource/MixDownload/{tokenid}";

/* 根据expid获取文件信息 */
static NSString * const WebApi_CloudDiskFile_GetFileInfoWithExpid = @"api/fileserver/gallelryfilemodel/{fileid}/{tokenid}";
/* 文件替换新api  2017-08-08 */
static NSString * const WebApi_FileReplace_Replace = @"api/filemanager/handler/replace/{source}/{target}/{tokenid}";

/* 云盘批量删除 */
static NSString * const WebApi_CloudDisk_BatchDelete = @"api/CloudDiskApp/DelBatchDelete/{tokenid}";
/*------------------云盘相关，收藏文件-------------------*/
/* 收藏文件 */
static NSString * const WebApi_CloudDiskFavorites = @"api/CloudDiskApp/Favorites";
static NSString * const WebApi_CloudDiskFile_AddFavoritesFile = @"api/favorites/add/{tokenid}";
static NSString * const WebApi_CloudDiskFile_V2_AddFavoritesFile = @"api/favorites/v2/add/{tokenid}";
/* 收藏列表展示 */
static NSString * const WebApi_CloudDiskFile_CollectionFileList = @"api/CloudDiskApp/Collerction/List/{tokenid}";
/* 取消收藏 */
static NSString * const WebApi_CloudDiskFile_CancelCollection = @"api/favorites/remove/{favoritetype}/{objectid}/{appcode}/{tokenid}";
static NSString * const WebApi_CloudDiskFile_V2_CancelCollection = @"api/favorites/v2/remove/{type}/{objectid}/{appcode}/{state}/{tokenid}";
/* 获取单个收藏对象 */
static NSString * const WebApi_CloudDiskFavorite_GetFavoriteInfo = @"api/favorites/achieve/{objectid}/{type}/{tokenid}";


/*------------------云盘相关，分享文件-------------------*/
/* 唯一标识 */
static NSString * const WebApi_CloudDiskShare = @"api/CloudDiskApp/Share";
/* 获取回收站列表 */
static NSString * const WebApi_CloudDiskShare_List = @"api/CloudDiskApp/Share/List/{tokenid}";
/* 分享文件 */
static NSString * const WebApi_CloudDiskShare_Share = @"api/CloudDiskApp/Share/{tokenid}";
/* 取消分享 */
static NSString * const WebApi_CloudDiskShare_CancleShare = @"api/CloudDiskApp/CancelShare/{shareid}/{tokenid}";
/* 获取分享model 的信息(带密码的) */
static NSString * const WebApi_CloudDiskShare_GetSharePawModelInfo = @"api/CloudDiskApp/Share/gallery/{shareid}/{paw}/{tokenid}";
/* 获取分享model 信息（不带密码的）*/
static NSString * const WebApi_CloudDiskShare_GetShareModelInfo = @"api/CloudDiskApp/Share/gallery/{shareid}/{tokenid}";
/*获取分享文件夹model信息 (GET) */
static NSString * const WebApi_CloudDiskShare_GetShareFolderInfo = @"api/CloudDiskApp/Share/folder/{shiid}/{folderid}/{tokenid}";
/* 查看已分享的文件保存到网盘 */
static NSString * const WebApi_CloudDiskShare_MoveToCloudDisk = @"api/CloudDiskApp/MoveToCloudDisk/{shiid}/{folderid}/{tokenid}";

/* 获取带链接的分享model信息*/
static NSString * const WebApi_ResShareModel_GetShareModelInfo = @"api/resource/share/gallery/{shareid}/{tokenid}";
static NSString * const WebApi_ResShareModel_GetSharePawModelInfo = @"api/resource/share/gallery/{shareid}/{paw}/{tokenid}";

/*------------------云盘相关，回收站-------------------*/
static NSString * const WebApi_CloudDiskRecycle = @"api/CloudDiskApp/Recycle";
/* 获取回收站列表 */
static NSString * const WebApi_CloudDiskRecycle_List = @"api/CloudDiskApp/Recycle/List/{tokenid}";
/* 删除回收站文件 */
static NSString * const WebApi_CloudDiskRecycle_Del = @"api/CloudDiskApp/Recycle/Del/{tokenid}";
/* 清空回收站 */
static NSString * const WebApi_CloudDiskRecycle_DelAll = @"api/CloudDiskApp/Recycle/Clear/{tokenid}";
/* 还原回收站文件 */
static NSString * const WebApi_CloudDiskRecycl_Reduction = @"api/CloudDiskApp/Recycle/Reduction/{tokenid}";


/*------------------文件图标，格式相关-------------------*/
/* 根据扩展名获取对应的id */
static NSString * const WebApi_Format_GetFormatIcon  = @"api/Resource/Format/GetFormatIcon/{format}/{ishandlerjpg}/{tokenid}";

/*------------------ CloudDiskAppOrganization 组织云盘控制器 -------------------*/
/* 获取组织云盘企业区model GET */
static NSString *const WebApi_CloudDiskAppOrganization_OrganizationModel = @"api/CloudDiskApp/Organization/Model/{tokenid}";
/* 获取组织云盘基础列表数据 post */
static NSString *const WebApi_CloudDiskAppOrganization_NormalList = @"api/CloudDiskApp/Organization/Normal/List/{tokenid}";
/* 获取组织云盘组织列表数据 post */
static NSString *const WebApi_CloudDiskAppOrganization_Organization = @"api/CloudDiskApp/Organization/Organization/List/{tokenid}";
/* 获取网盘大小 GET api/CloudDiskApp/Size/{tokenid}*/
static NSString *const WebApi_CloudDiskApp_Size = @"api/clouddisk/personal/usesize/{tokenid}";

/* 获取组织云盘回收站列表数据 POST */
static NSString *const WebApi_CloudDiskAppOrganization_RecycleList = @"api/CloudDiskApp/Organization/Recycle/List/{tokenid}";
/* 获取组织云盘分享列表数据 POST */
static NSString *const WebApi_CloudDiskAppOrganization_ShareList = @"api/CloudDiskApp/Organization/Share/List/{tokenid}";
/* 获取组织云盘收藏列表数据 POST  api/resource/folder/getfolderonepartitiontype/{rpid}/{partitiontype}/{tokenId}*/
static NSString *const WebApi_CloudDiskAppOrganization_FavorList = @"api/CloudDiskApp/Organization/Favor/List/{tokenid}";

/* 获取资源池中的一个分区所有文件夹节点 GET  */
static NSString *const WebApi_CloudDiskAppOrganization_GetFolderOnepartitionType = @"api/resource/folder/getfolderonepartitiontype/{rpid}/{partitiontype}/{tokenid}";


