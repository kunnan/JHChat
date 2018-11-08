//
//  MatchParser.h
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define BEGIN_TAG @"["
#define END_TAG @"]"

#define HBMatchParserString @"string"
#define HBMatchParserRange @"range"
#define HBMatchParserRects @"rects"
#define HBMatchParserImage @"image"
#define HBMatchParserLocation @"location"
#define HBMatchParserLine @"line"
#define HBMatchParserLinkType @"linkType"

#define  HBMatchParserLinkTypeUrl @"MatchParserLinkTypeUrl"
#define  HBMatchParserLinkTypePhone @"MatchParserLinkTypePhone"
#define  HBMatchParserLinkTypeMobie   @"MatchParserLinkTypeMobie"
#define  HBMatchParserLinkTypeName @"MatchParserLinkTypeName"
@class HBMatchParser;

typedef NSString * (^GetFaceIconNameWithCharacter)(NSString *character);

@protocol HBMatchParserDelegate <NSObject>
@optional
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;

-(HBMatchParser*)createMatch:(float)width;
@optional
@property(nonatomic,weak,getter = getMatch,setter = setMatch:) HBMatchParser * match;
-(void)setMatch;
-(void)setMatch:(HBMatchParser *)match;

-(HBMatchParser*)getMatch;
-(HBMatchParser*)getMatch:(void(^)(HBMatchParser *parser,id data))complete data:(id)data;

-(void)setMatchWithWidth:(float)width;
-(HBMatchParser*)getMatchWithWidth:(float)width;
-(HBMatchParser*)getMatchWithWidth:(float)width complete:(void(^)(HBMatchParser *parser,id data))complete data:(id)data;

/**
 *  根据标识获取对应的表情图片
 */
-(NSString *)getFaceIconNameWithCharacter:(NSString *)iconCharacter;

@end


@interface HBMatchParser : NSObject
{
    NSMutableArray * _strs;
    
    NSString * _source;
    
    float _height;
    
    id _ctFrame;
    
    float _miniWidth;
    
    NSInteger _numberOfTotalLines;
    
    float _heightOflimit;
    
}
@property(nonatomic,strong) NSMutableAttributedString * attrString;
@property(nonatomic,strong) NSArray * images;
@property(nonatomic,readonly) NSMutableArray * links;



@property(nonatomic,strong) UIFont * font;

@property(nonatomic,strong) UIColor * textColor;
@property(nonatomic,strong) UIColor * keyWorkColor;

@property(nonatomic) float line;            //行距
@property(nonatomic) float paragraph;   // 段落间距
@property(nonatomic) float MutiHeight;  //多行行高
@property(nonatomic) float fristlineindent; // 首行缩进
@property(nonatomic) float iconSize;    // 表情Size
@property(nonatomic) float width;       // 宽度
@property(nonatomic) NSInteger numberOfLimitLines;   // 行数限定 (等于0 代表 行数不限)
@property(nonatomic) BOOL phoneLink;
@property(nonatomic) BOOL mobieLink;
@property(nonatomic) BOOL urlLink;
@property(nonatomic,readonly) BOOL titleOnly;
@property(nonatomic,readonly) NSAttributedString * title;


@property(nonatomic,readonly) id ctFrame;
@property(nonatomic) float height;        // 总内容的高度
@property(nonatomic,readonly) float heightOflimit;   // 限定行数后的内容高度
@property(nonatomic,readonly) float miniWidth;       //只有一行时，内容宽度
@property(nonatomic,readonly) NSInteger numberOfTotalLines;         //内容行数
@property(nonatomic,readonly) NSString * source;      //原始内容

@property (copy, nonatomic) GetFaceIconNameWithCharacter getFaceIconNameWithCharacter;

-(void)match:(NSString*)text;

/*
-(void)match:(NSString*)text   atCallBack:(BOOL(^)(NSString*))atString;

-(void)match:(NSString *)source  atCallBack:(BOOL (^)(NSString *))atString title:(NSAttributedString*)title;

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link;

-(void)addLink:(NSRange)range string:(NSString*)string linkType:(NSString*)linkType  link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link;

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title1   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link buildImmediatel:(BOOL)Immediatel;
*/

#pragma mark - 刷新样式

/**
 *  更新样式
 */
-(void)updateMatchForLink:(NSRange)range isSelected:(BOOL)isSelected;

////获取表情字典
//+(NSDictionary*)getFaceMap:(NSString *)dicName;
////获取表情字典
//+(NSDictionary*)getFaceMapCN:(NSString *)dicName;
////内容过滤[/smile]替换为[/0] 发送服务器使用
//+(NSString*)sendTextFilter:(NSString *)source;


@end
