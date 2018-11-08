//
//  LZChatGroupSingleView.m
//  LeadingCloud
//
//  Created by wang on 17/4/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatGroupSingleView.h"
#import "UIImageView+Icon.h"
#import "LZVideoAnimation.h"

@interface LZChatGroupSingleView (){
    UIView *layerView;
}

@end

@implementation LZChatGroupSingleView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        layerView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-60)/2, frame.size.height/2-30, 60, 60)];
        CALayer *layer = [LZVideoAnimation replicatorLayerWaveSize:CGSizeMake(60, 60)];
        
        [layerView.layer addSublayer:layer];
        
        [self addSubview:layerView];
		
		self.banView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-36, frame.size.height-36, 36, 36)];
    }
    return self;
}

- (void)setCoverImageView:(UIImageView *)coverImageView{
    
    _coverImageView = coverImageView;
    
    [self addSubview:_coverImageView];
}

- (void)setBanView:(UIImageView *)banView{
	_banView = banView;
	banView.image = [UIImage imageNamed:@"icon_smalban_default"];
	[self addSubview:banView];
	banView.hidden = YES;
}

- (void)upDataIcon:(NSString*)face Uid:(NSString*)uid isSingle:(NSInteger)isSingle{
    
    self.uid = uid;
    [_coverImageView loadFaceIcon:face isChangeToCircle:true];
    if(isSingle){
        self.backgroundColor = [UIColor colorWithRed:46/255.0 green:48/255.0 blue:53/255.0 alpha:1];

    }else{
        self.backgroundColor = [UIColor colorWithRed:45/255.0 green:47/255.0 blue:52/255.0 alpha:1];
        
    }


}

- (void)banSatae:(BOOL)isMuit{
	
	if (isMuit) {
		
		[self addSubview:_banView];
		_banView.hidden = NO;
	}else{
		_banView.hidden = YES;
	}
}
- (void)endWaitingView{
    
    [layerView removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
