/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】插件运行的参数
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@class JSNCWebView;

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件运行的参数对象
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件运行的参数对象
 */
@interface JSNCRunParameter : NSObject
/**
 *  插件Code
 */
@property(nonatomic,copy,readonly)NSString *pluginCode;
/**
 *  插件运行的方法名称
 */
@property(nonatomic,copy,readonly)NSString *methodName;
/**
 *  插件运行时id
 */
@property(nonatomic,copy,readonly)NSString *runTimeId;
/**
 *  JS调用时传入的对象
 *          如果是JSON格式，自动转成OC对应的数据格式对象了
 */
@property(nonatomic,strong,readonly)id parameters;

#pragma mark - 公共方法
/**
 *  【静态】构建运行参数对象
 *  @param jsonString JSON格式参数字符串
 *  @return 插件运行的参数对象
 */
+(JSNCRunParameter *)parameterWithJSONString:(NSString *)jsonString;

@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件运行结果的参数对象

/**
 * 【通用模块】-【JavaScript和Native通信通道】插件运行结果类型枚举
 */
typedef NS_ENUM(NSInteger,JSNCRunResultType){
    /**
     *  空消息，有的时候为了清空缓存发的一个假的消息
     */
    JSNCRunResultType_None=0,
    /**
     *  运行成功
     */
    JSNCRunResultType_Success,
    /**
     *  运行发生错误
     */
    JSNCRunResultType_Error,
    /**
     *  未注册当前插件
     */
    JSNCRunResultType_PluginNotRegist,
    /**
     *  不支持此方法
     */
    JSNCRunResultType_MethodNotSupport
};


/**
 *  【通用模块】-【JavaScript和Native通信通道】插件运行结果对象
 */
@interface JSNCRunResult : NSObject
//      运行结果中，必须的是插件的pluginCode，runTimeId,resultType,resultData
/**
 *  插件Code
 */
@property(nonatomic,copy,readonly)NSString *pluginCode;
/**
 *  插件运行时id
 */
@property(nonatomic,copy,readonly)NSString *runTimeid;
/**
 *  插件运行结果类型枚举
 */
@property(nonatomic,assign,readonly)JSNCRunResultType resultType;
/**
 *  插件运行结果数据
 */
@property(nonatomic,copy,readonly)NSString *resultData;
/**
 *  插件此次运行是否结束了
 */
@property(nonatomic,assign,readonly)Boolean   isFinished;

#pragma mark - 公共方法

/**
 *  【静态】构建插件运行成功并结束当前运行的结果对象
 *  @param parameter  插件运行时参数对象
 *  @param resultData 插件运行结果数据
 *  @return 运行结果对象
 */
+(JSNCRunResult *)resultWithRunParameter:(JSNCRunParameter *)runParameter successResultData:(NSString *)resultData;

/**
 *  【静态】构建插件运行结果对象
 *  @param parameter  插件运行时参数对象
 *  @param resultType 插件运行结果类型枚举
 *  @param resultData 插件运行结果数据
 *  @param isFinished 插件此次运行是否结束了
 *  @return 运行结果对象
 */
+(JSNCRunResult *)resultWithRunParameter:(JSNCRunParameter * )parameter resultType:(JSNCRunResultType)resultType resultData:(NSString * )resultData isFinished:(Boolean)isFinished;

/**
 *  将插件运行结果转换为字典对象
 *  @return
 */
-(NSDictionary *)result2Dictionary;

@end