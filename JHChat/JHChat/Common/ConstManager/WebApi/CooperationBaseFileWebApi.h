//
//  CooperationBaseFileWebApi.h
//  LeadingCloud
//
//  Created by SY on 16/12/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef CooperationBaseFileWebApi_h
#define CooperationBaseFileWebApi_h


#endif /* CooperationBaseFileWebApi_h */

static NSString *const  WebApi_CooperationBaseFile = @"api/basecooperationfile";

/* 获取权限类型 */
static NSString * const WebApi_CooperationBaseFile_Authority_MyAuthority =@"api/basecooperationfile/authority/myauthority/{cid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_Authority_MyAuthority_Expend =@"api/basecooperationfile/authority/myauthority/expend/{cid}/{rpid}/{tokenid}";

/* 打开权限设置页面 */
static NSString * const WebApi_CooperationBaseFile_Authority_FileAuthority = @"api/basecooperationfile/authority/basecooperationfileauthority/{cid}/{tokenid}";
/* 打开权限设置页面 */
static NSString * const WebApi_CooperationBaseFile_Authority_FileAuthority_Expend = @"api/basecooperationfile/authority/basecooperationfileauthority/expend/{cid}/{rpid}/{tokenid}";
/* 文件上报下发时打开自定义权限的任务是不能点击的<##> */
static NSString * const WebApi_CooperationBaseFile_Authority_asecooperationfileauthority = @"api/basecooperationfile/authority/basecooperationfileauthority/{tokenid}";
/* 权限设置选项post cid:  fileauthority:1.none 2.my 3.admin 4.customize userauthority*/
static NSString * const WebApi_CooperationBaseFile_Authority_SettingsAuthority = @"api/basecooperationfile/authority/settingsauthority/{tokenid}";
/* 权限设置选项post cid:  fileauthority:1.none 2.my 3.admin 4.customize userauthority*/
static NSString * const WebApi_CooperationBaseFile_Authority_SettingsAuthority_Expend = @"api/basecooperationfile/authority/settingsauthority/expend/{tokenid}";

/* 自定义人员权限 post*/
static NSString * const WebApi_CooperationBaseFile_Authority_Member = @"api/basecooperationfile/authority/member/{tokenid}";
/* POST设置基础协作权限(文件夹权限设置)
 cid  rpid folderid
 userauthority
 权限设置 key：权限，value：用户列表
 */
static NSString * const WebApi_CooperationBaseFile_Authority_SettingsAuthorityForFolder = @"api/basecooperationfile/authority/settingsauthorityforfolder/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_Authority_SettingsAuthorityForFolder_Expend = @"api/basecooperationfile/authority/settingsauthorityforfolder/expend//{tokenid}";

/*GET获取基础协作权限(文件夹权限)cid  folderid<##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_CooperationAuthorityForFolder = @"api/basecooperationfile/authority/basecooperationfileauthorityforfolder/{cid}/{folderid}/{tokenid}";
/*GET获取基础协作权限(文件夹权限)cid  folderid<##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_CooperationAuthorityForFolder_Expend = @"api/basecooperationfile/authority/basecooperationfileauthorityforfolder/expend/{cid}/{rpid}/{folderid}/{tokenid}";
/* 根据基础协作id获取当前登陆人的权限(拥有文件夹使用权限)cid get <##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_MyAuthorityModel = @"api/basecooperationfile/authority/myauthoritymodel/{cid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_Authority_MyAuthorityModel_Expend = @"api/basecooperationfile/authority/myauthoritymodel/expend/{cid}/{rpid}/{tokenid}";

/* 查询文件夹权限 get当前文件夹下文件的权限 <##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_FileFolderAuthority = @"api/basecooperationfile/authority/basecooperationfilefolderauthority/{cid}/{folderid}/{tokenid}";
/* 查询文件夹权限 get当前文件夹下文件的权限 <##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_FileFolderAuthority_Expend = @"api/basecooperationfile/authority/basecooperationfilefolderauthority/expend/{cid}/{rpid}/{folderid}/{tokenid}";

/* 获取当前登陆人的权限(拥有文件夹管理权限)cid get <##>*/
static NSString * const WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel = @"api/basecooperationfile/authority/getmyadminauthoritymodel/{cid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel_Expend = @"api/basecooperationfile/authority/getmyadminauthoritymodel/expend/{cid}/{rpid}/{tokenid}";


static NSString * const WebApi_CooperationBaseFile_Authority_GetMyOperateAuthorityModel = @"api/basecooperationfile/authority/getmyoperateauthoritymodel/{cid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_Authority_GetMyOperateAuthorityModel_Expend = @"api/basecooperationfile/authority/getmyoperateauthoritymodel/expend/{cid}/{rpid}/{tokenid}";
/* 获取文件夹数据 api/basecooperationfile/getfolder/{rpid}/{tokenid} -->api/basecooperationfile/getresourcefolder */
static NSString * const WebApi_CooperationBaseFile_GetFolder = @"api/basecooperationfile/getresourcefolder/{tokenid}";

/* 通过classid获取当前文件夹目录 <##>*/
static NSString * const WebApi_CooperationBaseFile_GetFolderByClassid = @"api/basecooperationfile/getfolderbyclassid/{rpid}/{folderid}/{tokenid}";

/* 打开文件夹 api/basecooperationfile/getresource/{tokenid}--> api/basecooperationfile/getresources/{tokenid}
 --> api/basecooperationfile/normal/list/{tokenId}
 */
static NSString * const WebApi_CooperationBaseFile_GetResource = @"api/basecooperationfile/normal/list/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_GetResource_SolrList = @"api/basecooperationfile/normal/solr/list/{tokenid}";

/* 新建文件夹 */
static NSString * const WebApi_CooperationBaseFile_AddFolder  =@"api/basecooperationfile/addfolder/{tokenid}";
/* 删除分类文件夹 */
static NSString * const WebApi_CooperationBaseFile_DelFolderContext = @"api/basecooperationfile/delfoldercontext/{tokenid}";
/* 修改文件夹 重命名 */
static NSString *const WebApi_CooperationBaseFile_EditFolderName = @"api/basecooperationfile/editfoldername/{tokenid}";
/* 修改文件夹 及描述信息 */
static NSString *const WebApi_CooperationBaseFile_EditFolderInfo = @"api/basecooperationfile/editfolderinfo/{tokenid}";
/* 删除资源 */
static NSString * const WebApi_CooperationBaseFile_DelResourced = @"api/basecooperationfile/delresource/{tokenid}";
/* 修改资源名称 */
static NSString * const WebApi_CooperationBaseFile_EditResourceName = @"api/basecooperationfile/editresourcename/{tokenid}";
/* 修改资源 */
static NSString * const WebApi_CooperationBaseFile_EditResourceInfo = @"api/basecooperationfile/editresourceinfo/{tokenid}";
/* 查看详情 资源 */
static NSString * const WebApi_CooperationBaseFile_GetResourceDetails = @"api/basecooperationfile/getresourcedetails/{tokenid}";
/* 查看详情 文件夹 */
static NSString * const WebApi_CooperationBaseFile_GetFolderDetails = @"api/basecooperationfile/getfolderdetails/{tokenid}";
/* 新增文件 发送动态 日志 */
static NSString * const WebApi_CooperationBaseFile_AddResourceForLogic = @"api/basecooperationfile/addresourceforlogic/{tokenid}";
/* 新增文件 批量发送动态  */
static NSString * const WebApi_CooperationBaseFile_AddResourceForMoreLogic = @"api/basecooperationfile/addresource/{tokenid}";
/* 覆盖文件 发送通知动态 日志 */
static NSString *const WebApi_CooperationBaseFile_ReplaceResource = @"api/basecooperationfile/replaceresource/{tokenid}";
/* 升级资源 发送通知动态 日志*/
static NSString * const WebApi_CooperationBaseFile_UpgradeResource = @"api/basecooperationfile/upgraderesource/{tokenid}";
/* 保存到云盘 */
static NSString * const WebApi_CooperationBaseFile_CopyToNetDisk =@"api/basecooperationfile/copymobilefile/{folderid}/{tokenid}";
/* 批量删除 */
static NSString * const WebApi_CooperationBaseFile_MixRemoveDara = @"api/basecooperationfile/mixremovedata/{tokenid}";
/* 文件移动 */
static NSString * const WebApi_CooperationBaseFile_MoveFile = @"api/basecooperationfile/mobilefile/{islog}/{appcode}/{rpid}/{cooperationid}/{folderid}/{tokenid}";
/* 导入云盘文件 */
static NSString * const WebApi_CooperationBaseFile_ImportNetDiskResource = @"api/basecooperationfile/importsource/{folderid}/{tokenid}";

/* 协作新增文件 */
static NSString * const WebApi_CooperationBaseFile_CreateResourceNewResource = @"api/basecooperationfile/createresource/{tokenid}";
/* 协作新增文件发动态 */
static NSString * const WebApi_CooperationBaseFile_AddResourceForDy = @"api/basecooperationfile/addresource/{tokenid}";
/* 协新增资源覆盖 */
static NSString * const WebApi_CooperationBaseFile_ReplaceResourceForNew = @"api/basecooperationfile/replaceresource/authority/{tokenid}";

/* 升级支援 */
static NSString * const WebApi_CooperationBaseFile_UpgradeResourceforNew = @"api/basecooperationfile/upgraderesource/authority/{tokenid}";



/* 获取文件夹指定节点（获取文件夹信息） */
static NSString * const WebApi_Resource_Folder_GetFOlderOne = @"api/resource/folder/getfolderone/{rpid}/{partitiontype}/{folderid}/{tokenid}";




/* 新增资源共享文件夹post
 rsfname:共享文件夹0001
 rpid:243535438008946688
 folderid:251233780921012224
 rsftype:1:私密 2:公开
 api/resource/folder/sharedfolder/addmodel/{tokenid}==>>api/basecooperationfile/share/{tokenid}
 */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_AddShareFolderModel = @"api/basecooperationfile/share/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_ShareFolder_AddShareModel = @"api/resource/folder/sharedfolder/addmodel/{tokenid}";

/* 取消共享文件夹 在文件列表中用到api/resource/folder/sharedfolder/deletemodel/{rpid}/{folderid}/{tokenid}==> api/basecooperationfile/cancelshare/{shareId}/{tokenId}*/
static NSString * const WebApi_CooperationBaseFile_ShareFolder_DeleShareFolderInFolderList = @"api/basecooperationfile/cancelshare/{shareid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_ShareFolder_CancelShareOld = @"api/resource/folder/sharedfolder/deletemodel/{rpid}/{folderid}/{tokenid}";

/*
 删除资源共享文件夹信息get
 */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_DeleteModel = @"api/resource/folder/sharedfolder/deletemodel/{rsfid}/{tokenid}";
/*
 修改资源共享文件夹信息post
 rsfid:251233890472038400
 rsfname:共享文件夹0002
 rpid:243535438008946688
 folderid:251233826848641024
 foldername:共享文件夹0002
 rsftype:1
 password:h3ffiv
 createuser:148954964599508992
 createdate:2017-11-24T14:33:47
 */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_UpdateModel = @"api/resource/folder/sharedfolder/updatemodel/{tokenid}";

static NSString * const WebApi_CooperationBaseFile_ShareFolder_EditSharePaw = @"api/share/editsharepaw/{tokenid}";
/*
 获取资源共享文件夹(自己全部共享的文件夹) get
 */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_GetModelForRpid = @"api/resource/folder/sharedfolder/getmodelforrpid/{rpid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_ShareFolder_GetShareList = @"api/basecooperationfile/share/list/{tokenid}";
/*
 添加自己的文件为共享文件
 */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_AddFolderForShare = @"api/resource/folder/sharedfolder/addmodel/{tokenid}";


/* 分享内容 -- 删除分享项<##> */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_DelShareItem = @"api/basecooperationfile/delshareitem/{shiid}/{tokenid}";
/* 分享内容 -- 添加分享项<##> */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_AddShareItem = @"api/basecooperationfile/addshareitem/{tokenid}";
/*
 获取资源引用文件夹(已添加的共享文件夹) get api/resource/folder/quotefolder/getmodel/{rpid}/{tokenid}==》api/cooperationfile/getresquote
 */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_Getmodel = @"api/cooperationfile/getresquote/{tokenid}";

static NSString * const WebApi_CooperationBaseFile_QuoteFolder_GetOldSharemodel = @"api/resource/folder/quotefolder/getmodel/{rpid}/{tokenid}";
/* 查看引用的外部文件列表<##> */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_ShareItemList = @"api/basecooperationfile/share/item/list/{tokenid}";
/*
 添加共享文档
 */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_AddQuoteShareFolderModel = @"api/resource/folder/quotedfolder/addmodel/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_AddResQuote = @"api/cooperationfile/addresquote/{tokenid}";
/*
 输入共享码时请求的api
 */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_GetSharedType = @"api/resource/folder/sharedfolder/getsharedtype/{rsfid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_IsEffectiveShare = @"api/cooperationfile/iseffective/{rpid}/{rsid}/{tokenid}";
/*
 获取资源引用文件夹(企业的) get
 */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_GetOrgModel = @"api/resource/folder/quotefolder/getorgmodel/{rsfid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_WhoQuote = @"api/cooperationfile/whoquote/{rsid}/{tokenid}";
/*
 删除引用的文件夹getapi/resource/folder/quotefolder/deletemodel/{rqfid}/{tokenid==>> api/cooperationfile/delresquote
 */
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_DeleteQuoteFolder = @"api/cooperationfile/delresquote/{rqid}/{tokenid}";
static NSString * const WebApi_CooperationBaseFile_QuoteFolder_DeleteModel = @"api/resource/folder/quotefolder/deletemodel/{rqfid}/{tokenid}";

/* 获取我的分享文件列表数据<##> */
static NSString * const WebApi_CooperationBaseFile_ShareFolder_GetNoRpidShare = @"api/basecooperationfile/getnorpidshare/{rpid}/{tokenid}";

///*
// 获取文件信息 post cid resourceid
// */
//static NSString * const WebApi_CooperationBaseFile_GalleryResourceMainInfo = @"api/basecooperationfile/galleryresourcemodelmaininfo/authority/{tokenid}";

///*
// 获取文简夹信息
// */
//static NSString * const WebApi_CooperationBaseFile_GetResourceInfo = @"api/BaseCooperation/getresourceinfo/authority/{tokend}";

