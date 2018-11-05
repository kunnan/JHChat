//
//  LZUILabel.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface LZUILabel : UILabel{
@private
//    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;  

@end
