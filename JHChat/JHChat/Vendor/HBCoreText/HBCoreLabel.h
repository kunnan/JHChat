//
//  HBCoreLabel.h
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBMatchParser.h"
@class HBCoreLabel;
@protocol HBCoreLabelDelegate <NSObject>
@optional
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel nameClick:(NSString *)linkStr;

-(void)coreLabel:(HBCoreLabel *)coreLabel doubleClick:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  根据标识获取对应的表情图片
 */
//-(NSString *)getFaceIconNameWithCharacter:(NSString *)iconCharacter;
//-(NSString *)getFaceIconNameWithCharacter:(FaceIconNameWithText)text;
@end

@interface HBCoreLabel : UILabel<UIActionSheetDelegate,UIGestureRecognizerDelegate,HBMatchParserDelegate>
{
    HBMatchParser * _match;
    
    BOOL touch;
    
    id<HBMatchParserDelegate> _data;
    
    NSRange _range;
    
    NSString * _linkStr;
    
    NSString * _linkType;
    
    BOOL _copyEnableAlready;
    
    BOOL _attributed;
}
@property(nonatomic,strong ) HBMatchParser *match;
@property(nonatomic,weak) IBOutlet id<HBCoreLabelDelegate> delegate;
@property(nonatomic) BOOL linesLimit;
-(void)registerCopyAction;

@property (copy, nonatomic) GetFaceIconNameWithCharacter getFaceIconNameWithCharacter;

#pragma mark - Expand 

-(void)configCoreLabelWithText:(NSString *)text
                      maxWidth:(NSInteger)maxWidth
                   lineSpacing:(float)lineSpacing
                          font:(UIFont *)font;
@end
