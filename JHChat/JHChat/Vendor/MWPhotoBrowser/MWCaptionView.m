//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"

static const CGFloat labelPadding = 10;

// Private
@interface MWCaptionView ()<UITextViewDelegate> {
    id <MWPhoto> _photo;
    UILabel *_label;
    UITextView *_textView;
}
@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        self.userInteractionEnabled = YES;
        _photo = photo;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = nil;
        self.barStyle = UIBarStyleBlackTranslucent;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self setupCaption];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat maxHeight = 9999;
//    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
//    CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, 85)
//                                                options:NSStringDrawingUsesLineFragmentOrigin
//                                             attributes:@{NSFontAttributeName:_label.font}
//                                                context:nil].size;
//    return CGSizeMake(size.width, textSize.height + labelPadding * 3.5);
    CGSize textSize = [_textView.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, 80)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_textView.font}
                                                context:nil].size;
    if(textSize.height>65){
        [_textView setScrollEnabled:YES];
    }
    else{
        [_textView setScrollEnabled:NO];
    }

    return CGSizeMake(size.width, textSize.height + labelPadding*2+5 );
}

- (void)setupCaption {
//    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
//                                                       self.bounds.size.width-labelPadding*2,
//                                                       self.bounds.size.height))];
//    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _label.opaque = NO;
//    _label.backgroundColor = [UIColor clearColor];
//    _label.textAlignment = NSTextAlignmentLeft;
////    _label.lineBreakMode = NSLineBreakByWordWrapping;
//
//    _label.numberOfLines = 0;
//    _label.textColor = [UIColor whiteColor];
//    _label.font = [UIFont systemFontOfSize:15];
//    if ([_photo respondsToSelector:@selector(caption)]) {
//        _label.text = [_photo caption] ? [_photo caption] : @" ";
//    }
//    [self addSubview:_label];
    _textView = [[UITextView alloc]initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                           self.bounds.size.width-labelPadding*2,
                                                                           self.bounds.size.height))];
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = [UIFont fontWithName:@"Arial" size:15];
    [_textView setEditable:YES];
//    _textView.scrollEnabled = NO;
    _textView.userInteractionEnabled = YES;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.delegate = self;
    if ([_photo respondsToSelector:@selector(caption)]) {
        _textView.text = [_photo caption] ? [_photo caption] : @" ";
    }
    [self addSubview:_textView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    NSArray *subViewArray = [self subviews];
    
    for (id view in subViewArray) {
        if ([view isKindOfClass:(NSClassFromString(@"_UIToolbarContentView"))]) {
            UIView *testView = view;
            testView.userInteractionEnabled = NO;
        }
    }
    
}

@end
