/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】插件运行的参数
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "JSNCParameter.h"

#pragma mark - 宏定义
//          插件编码
#define  JSNC_PluginCode @"PluginCode"
//          插件运行的方法名
#define  JSNC_MethodName @"MethodName"
//          插件运行时id
#define  JSNC_RunTimeId @"RunTimeId"
//          插件运行时传入的参数
#define  JSNC_Parameters @"Parameters"
//          插件运行结果数据
#define  JSNC_ResultData @"ResultData"
//          插件运行结果类型
#define  JSNC_ResultType @"ResultType"
//          插件运行是否结束了
#define  JSNC_IsFinished @"IsFinished"



#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件运行的参数对象
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件运行的参数对象
 */
@implementation JSNCRunParameter

/**
 *  字符串是否是空或者空字符串
 *  @param str
 *  @return
 */
+(Boolean)strIsNullOrEmpty:(NSString *)str{
    id tmpValue=str;
    if([NSNull null]==tmpValue) return YES;
    if(str==nil)return YES;
    return [@"" isEqualToString:str];
}

#pragma mark - 公共方法

/**
 *  【静态】构建运行参数对象
 *  @param jsonString JSON格式参数字符串
 *  @return 插件运行的参数对象
 */
+(JSNCRunParameter *)parameterWithJSONString:(NSString *)jsonString{
    JSNCRunParameter *runParameter=[[JSNCRunParameter alloc]init];
    if([self strIsNullOrEmpty:jsonString]==false){
        NSError *tmpError;
         id jsonObj=   [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&tmpError];
        if(tmpError==nil && [jsonObj isKindOfClass:[NSDictionary class]]){
            NSDictionary *tmpDict=(NSDictionary *)jsonObj;
            runParameter->_pluginCode=[tmpDict objectForKey:JSNC_PluginCode];
            runParameter->_methodName=[tmpDict objectForKey:JSNC_MethodName];
            runParameter->_runTimeId=[tmpDict objectForKey:JSNC_RunTimeId];
            runParameter->_parameters=[tmpDict objectForKey:JSNC_Parameters];
        }
    }
    return runParameter;
}

@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件运行结果的参数对象
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件运行结果的参数对象
 */
@implementation JSNCRunResult

#pragma mark - 公共方法
/**
 *  【静态】构建插件运行成功并结束当前运行的结果对象
 *  @param parameter  插件运行时参数对象
 *  @param resultData 插件运行结果数据
 *  @return 运行结果对象
 */
+(JSNCRunResult *)resultWithRunParameter:(JSNCRunParameter *)runParameter successResultData:(NSString *)resultData{
    return [self resultWithRunParameter:runParameter resultType:JSNCRunResultType_Success resultData:resultData isFinished:YES];
}
/**
 *  【静态】构建插件运行结果对象
 *  @param parameter  插件运行时参数对象
 *  @param resultType 插件运行结果类型枚举
 *  @param resultData 插件运行结果数据
 *  @param isFinished 插件此次运行是否结束了
 *  @return 运行结果对象
 */
+(JSNCRunResult *)resultWithRunParameter:(JSNCRunParameter * )parameter resultType:(JSNCRunResultType)resultType resultData:(NSString * )resultData isFinished:(Boolean)isFinished{
    JSNCRunResult *runResult=[[JSNCRunResult alloc]init];
    runResult->_pluginCode=parameter.pluginCode;
    runResult->_runTimeid=parameter.runTimeId;
    runResult->_resultType=resultType;
    runResult->_resultData=resultData;
    runResult->_isFinished=isFinished;
    return runResult;
}

/**
 *  将插件运行结果转换为字典对象
 *  @return
 */
-(NSDictionary *)result2Dictionary{
    return @{
             JSNC_PluginCode:self.pluginCode==nil?@"":self.pluginCode,
             JSNC_RunTimeId:self.runTimeid==nil?@"":self.runTimeid,
             JSNC_ResultType:[NSNumber numberWithInt:self.resultType],
             JSNC_ResultData:self.resultData==nil?@"JSNC_NullValue":self.resultData,
             JSNC_IsFinished:[NSNumber numberWithBool:self.isFinished]
             };
}
@end