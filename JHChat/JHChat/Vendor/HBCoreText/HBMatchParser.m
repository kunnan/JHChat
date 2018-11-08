//
//  HBMatchParser.m
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "HBMatchParser.h"
#import "HBCoreLabel.h"



static CGFloat ascentCallback( void *ref ){
    return 0;
}
static CGFloat descentCallback( void *ref ){
    return 0;
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
//     return 26;
}
static void deallocCallback(void * ref){
    
}

@implementation HBMatchParser
@synthesize attrString,images,font,textColor,keyWorkColor,iconSize,ctFrame=_ctFrame,height=_height,width,line,paragraph,source=_source,miniWidth=_miniWidth,numberOfTotalLines=_numberOfTotalLines,heightOflimit=_heightOflimit,urlLink,phoneLink,mobieLink;

-(id)init
{
    self=[super init];
    if(self){
        _strs=[[NSMutableArray alloc]init];
        self.font=[UIFont systemFontOfSize:18]; //聊天界面字体大小
        self.textColor=[UIColor blackColor];
        self.keyWorkColor=[UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.000];
        self.iconSize=24.0f; //表情大小
        self.line=5.0f;
        self.paragraph=5.0f;
        self.MutiHeight=25.0f;
        self.fristlineindent=5.0f;
        self.mobieLink=YES;
        self.urlLink=YES;
        self.phoneLink=YES;
    }
    return self;
}

//是否是纯数字
- (BOOL)isNumText:(NSString *)string{
    //    NSString *string = @"1234abcd";
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

//替换表情1
-(void)match:(NSString*)source
{
    if (source==nil || [source isEqualToString:@""]) {
        return;
    }
    _source=source;
    NSMutableString * text=[[NSMutableString alloc]init];
    NSMutableArray * imageArr=[[NSMutableArray alloc]init];
    
    //  \\[\\/[a-zA-Z0-9.\\u4e00-\\u9fa5]+\\]
    NSRegularExpression * regular=[[NSRegularExpression alloc]initWithPattern:@"\\[\\/[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray * array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    
    NSInteger location=0;
    NSInteger count=[array count];
    for(int i=0;i<count;i++){
        NSTextCheckingResult * result=[array objectAtIndex:i];
        NSString * string=[source substringWithRange:result.range];
        //这里需要过滤一下[/笑]格式为 笑
        NSString *trueCharacter = [string substringWithRange:NSMakeRange(2, [string length]-3)];
//        if ([self isNumText:trueCharacter]) {   //判断是否为纯数字
//            trueCharacter = [NSString stringWithFormat:@"%@",[[HBMatchParser getFaceMap:@"ImageNameToDescription"] objectForKey:trueCharacter]];
//        }
//        NSString *icon = [NSString stringWithFormat:@"%@",[[HBMatchParser getFaceMap:@"DescriptionToImageName"] objectForKey:trueCharacter]];
//        NSString *icon = [[EmotionUtil getDescriptionToImageName] objectForKey:trueCharacter];
        
        NSString *icon = nil;
        if(_getFaceIconNameWithCharacter){
            icon = _getFaceIconNameWithCharacter(trueCharacter);
        }
        
        [text appendString:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
        if(icon!=nil){
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@@2x.png",icon];
            NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:iconStr,HBMatchParserImage,[NSNumber numberWithInteger:[text length]],HBMatchParserLocation,[NSNull null],HBMatchParserRects, nil];
            [imageArr addObject:dic];
            [text appendString:@" "];
        }else{
            [text appendString:string];
        }
        location=result.range.location+result.range.length;
    }
    [text appendString:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]initWithString:text attributes:attribute];
    
    for(NSDictionary * dic in imageArr){
        NSInteger location= [[dic objectForKey:HBMatchParserLocation] integerValue];
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.getDescent = descentCallback;
        callbacks.dealloc = deallocCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                 [NSNumber numberWithFloat:(self.iconSize+2)], @"width",
                                 nil] ;
        CTRunDelegateRef delegate=CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary* attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                //set the delegate
                                                (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                nil];
        
        [attStr addAttributes:attrDictionaryDelegate range:NSMakeRange(location, 1)];
        
        CFRelease(delegate);
    }
    [self matchLink:text attrString:attStr offset:0 link:nil];
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    CGFloat lineSpace=self.line;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //设置  段落间距
    CGFloat paragraphs = self.paragraph;
    CTParagraphStyleSetting paragraphStyle;
    paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphStyle.valueSize = sizeof(CGFloat);
    paragraphStyle.value = &paragraphs;
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,lineSpaceStyle,paragraphStyle
    };
    
    //设置样式
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [attStr addAttributes:attributes range:NSMakeRange(0, [text length])];
    CFRelease(fontRef);
    CFRelease(style);
    self.attrString=attStr;
    self.images=imageArr;
    [self buildFrames];
}

/*
-(void)match:(NSString*)source    atCallBack:(BOOL(^)(NSString*))atString
{
    [self match:source atCallBack:atString title:nil];
}

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString*)title1
{
    [self match:source atCallBack:atString title:title1 link:nil];
}
-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title1   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    [self match:source atCallBack:atString title:title1 link:link buildImmediatel:YES];
}

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title1   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link buildImmediatel:(BOOL)Immediatel
{
    if(source==nil){
        if (title1!=nil&&[title1 isKindOfClass:[NSAttributedString class]]) {
            CGSize size=[title1.string sizeWithFont:self.font];
            _height=size.height;
            self.attrString=[[NSMutableAttributedString alloc]initWithAttributedString:title1];
            _titleOnly=YES;
        }
        return;
    }
    _title=title1;
    _source=source;
    NSMutableString * text=[[NSMutableString alloc]init];
    NSMutableArray * imageArr=[[NSMutableArray alloc]init];
    NSRegularExpression * regular=[[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray * array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    NSInteger offset=0;
    if(title1){
        offset=[title1 length];
    }
    NSInteger location=0;
    NSInteger count=[array count];
    for(NSInteger i=0;i<count;i++){
        NSTextCheckingResult * result=[array objectAtIndex:i];
        NSString * string=[source substringWithRange:result.range];
//        NSString * icon=[HBMatchParser faceKeyForValue:string map:[HBMatchParser getFaceMap:@"DescriptionToImageName"]];
        NSString *icon = @"22";
        [text appendString:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
        if(icon!=nil){
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
            NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:iconStr,HBMatchParserImage,[NSNumber numberWithInteger:[text length]+offset],HBMatchParserLocation,[NSNull null],HBMatchParserRects,[NSNull null],HBMatchParserLine, nil];
            [imageArr addObject:dic];
            [text appendString:@" "];
        }else{
            [text appendString:string];
        }
        location=result.range.location+result.range.length;
    }
    [text appendString:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]init];
    if(title1!=nil&&[title1 isKindOfClass:[NSAttributedString class]])
        [attStr appendAttributedString:title1];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attribute]];
    
    for(NSDictionary * dic in imageArr){
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.getDescent=descentCallback;
        callbacks.dealloc=deallocCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                 [NSNumber numberWithFloat:(self.iconSize+2)], @"width",
                                 nil] ;
        CTRunDelegateRef  delegate=CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary*attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                               //set the delegate
                                               (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                               nil];
        NSInteger location= [[dic objectForKey:HBMatchParserLocation] integerValue];
        [attStr addAttributes:attrDictionaryDelegate range:NSMakeRange(location, 1)];
    }
    regular=[[NSRegularExpression alloc]initWithPattern:@"@[^@\\s]+" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    array=[regular matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    for( NSTextCheckingResult * result in array){
        NSString * string =[text substringWithRange:result.range];
        if([string hasPrefix:@"@"]){
            string=[string substringFromIndex:1];
            if(atString){
                if(atString(string)){
                    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
                    [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
                }else{
                    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
                    [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
                }
            }else{
                NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
                [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
            }
        }
    }
    [self matchLink:text attrString:attStr offset:offset link:link];
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    CGFloat lineSpace=self.line;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //设置  段落间距
    CGFloat paragraphs = self.paragraph;
    CTParagraphStyleSetting paragraphStyle;
    paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphStyle.valueSize = sizeof(CGFloat);
    paragraphStyle.value = &paragraphs;
    
    //多行行高
    CGFloat MutiHeight =self.MutiHeight;
    CTParagraphStyleSetting Muti;
    Muti.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Muti.value = &MutiHeight;
    Muti.valueSize = sizeof(float);
    
    
    //首行缩进
    CGFloat fristlineindent =self.fristlineindent;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(float);
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,lineSpaceStyle,paragraphStyle,Muti,fristline
    };
    
    
    //设置样式
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [attStr addAttributes:attributes range:NSMakeRange(0, [text length]+offset)];
    CFRelease(fontRef);
    CFRelease(style);
    self.attrString=attStr;
    self.images=imageArr;
    [self buildFrames];
}
*/

#pragma -mark 私有方法

-(void)buildFrames
{
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(0,0, width, 10000);
    CGPathAddRect(path, NULL, textFrame );
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attrString length]), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    NSInteger count=[lines count];
    CGPoint *origins=alloca(sizeof(CGPoint)*count);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    
#pragma -mark 获得内容的总高度
    //获得内容的总高度
    if([lines count]>=1){
        float line_y = (float) origins[[lines count] -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineRef line1 = (__bridge CTLineRef) [lines lastObject];
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height =10000- line_y + descent+1 ;    //+1为了纠正descent转换成int小数点后舍去的值
        _height=total_height+2;
    }else{
        _height=0;
    }
    
    lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    CGPoint *Origins=alloca(sizeof(CGPoint)*count);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), Origins); //2
    
#pragma -mark 获取内容行数 以及 一行时，内容的宽度
    // 获取内容行数 以及 一行时，内容的宽度
    _numberOfTotalLines=[lines count];
    if(_numberOfTotalLines>1){
        _miniWidth=self.width;
    }else{
        CTLineRef lineOne=(__bridge CTLineRef)lines[0];
        _miniWidth=CTLineGetTypographicBounds(lineOne, nil, nil, nil);
    }
    
#pragma -mark 获取限定行数后内容的高度
    //  获取限定行数后内容的高度
    if(_numberOfTotalLines<=_numberOfLimitLines||_numberOfLimitLines==0){
        _heightOflimit=_height;
    }else{
        CTLineRef line1=(__bridge CTLineRef)(lines[_numberOfLimitLines-1]);
        float line_y = (float) origins[_numberOfLimitLines -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height =10000- line_y + descent+1 ;    //+1为了纠正descent转换成int小数点后舍去的值
        _heightOflimit=total_height+2;
    }
    
    
#pragma -mark  解析表情图片
    // 解析表情图片
    if([self.images count]>0){
        int imgIndex = 0; //3
        NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
        NSInteger imgLocation =[[nextImage objectForKey:HBMatchParserLocation] integerValue];
        NSInteger lineIndex = 0;
        for (id lineObj in lines) { //5
            CTLineRef line1 = (__bridge CTLineRef)lineObj;
            for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line1)) { //6
                CTRunRef run = (__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                if ( runRange.location==imgLocation) { //7
                    CGRect runBounds;
                    runBounds.size.width =iconSize; //8
                    runBounds.size.height =iconSize;
                    
                    CGPoint *point=alloca(sizeof(CGPoint));
                    CTRunGetPositions(run, CFRangeMake(0, 0), point);
                    runBounds.origin.x = (*point).x+Origins[lineIndex].x+1;
                    runBounds.origin.y = (*point).y-9+Origins[lineIndex].y;  //表情位置
                    
                    //      NSLog(@"poing x: %f, y:%f",point.x,point.y);
                    NSMutableDictionary * dic=[self.images objectAtIndex:imgIndex];
                    [dic setObject:[NSValue valueWithCGRect:runBounds] forKey:HBMatchParserRects];
                    [dic setObject:[NSNumber numberWithInteger:lineIndex] forKey:HBMatchParserLine];
                    //load the next image //12
                    
                    imgIndex++;
                    if (imgIndex < [self.images count]) {
                        nextImage = [self.images objectAtIndex: imgIndex];
                        imgLocation =[[nextImage objectForKey:HBMatchParserLocation] integerValue];
                    }else{
                        lineIndex=[lines count];
                        break;
                    }
                }
            }
            if(lineIndex>=[lines count])
                break;
            lineIndex++;
        }
    }
    
#pragma -mark  解析网址链接
    // 解析网址链接
    if([self.links count]>0){
        int linkIndex = 0; //3
        NSDictionary* nextLink = [self.links objectAtIndex:linkIndex];
        NSRange linkRange =[[nextLink objectForKey:HBMatchParserRange] rangeValue];
        int lineIndex = 0;
        for (id lineObj in lines) { //5
            CTLineRef line1 = (__bridge CTLineRef)lineObj;
            for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line1)) { //6
                CTRunRef run = (__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                if ( runRange.location>=linkRange.location&&runRange.location<(linkRange.location+linkRange.length)) { //7
                    CGRect runBounds;
                    
                    CGFloat ascent;
                    CGFloat descent;
                    
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line1, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = Origins[lineIndex].x  + xOffset ;
                    runBounds.origin.y = Origins[lineIndex].y ;
                    runBounds.origin.y=10000-runBounds.origin.y-runBounds.size.height;
                    //      NSLog(@"poing x: %f, y:%f",point.x,point.y);
                    NSMutableDictionary * dic=[self.links objectAtIndex:linkIndex];
                    NSMutableArray * rects=[dic objectForKey:HBMatchParserRects];
                    [rects addObject:[NSValue valueWithCGRect:runBounds]];
                    //load the next image //12
                    if((runRange.location+runRange.length)>=(linkRange.location+linkRange.length)){
                        linkIndex++;
                        if (linkIndex < [self.links count]) {
                            nextLink = [self.links objectAtIndex: linkIndex];
                            linkRange = [[nextLink objectForKey: HBMatchParserRange] rangeValue];
                        }else{
                            _ctFrame=(__bridge id)frame;
                            CFRelease(frame);
                            CFRelease(path);
                            CFRelease(framesetter);
                            return;
                        }
                    }
                }
            }
            lineIndex++;
        }
    }
    _ctFrame=(__bridge id)frame;
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

-(void)matchLink:(NSString*)text attrString:(NSMutableAttributedString*)attStr offset:(NSInteger)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    _links=[[NSMutableArray alloc]init];
    
    //避免数字字体显示不一致的bug
    if(self.urlLink){
        [self matchUrlLink:text attrString:attStr offset:offset link:link];
    }
    if(self.phoneLink){
//        [self matchPhoneLink:text attrString:attStr offset:offset link:link];
    }
    if(self.mobieLink){
//        [self matchMobieLink:text attrString:attStr offset:offset link:link];
        [self matchLZMobieLink:text attrString:attStr offset:offset link:link];
    }
    
    [_links sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary * dic1=obj1;
        NSDictionary * dic2=obj2;
        NSRange range1=((NSValue *)[dic1 objectForKey:HBMatchParserRange]).rangeValue;
        NSRange range2=((NSValue *)[dic2 objectForKey:HBMatchParserRange]).rangeValue;
        if (range1.location<range2.location) {
            return  NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
}

#pragma mark - 匹配链接

//匹配网址
-(void)matchUrlLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(NSInteger)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,HBMatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],HBMatchParserRange,[[NSMutableArray alloc]init],HBMatchParserRects,HBMatchParserLinkTypeUrl,HBMatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

//匹配手机号(自定义修改)
-(void)matchLZMobieLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(NSInteger)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    //(1)\\d{10}$   (1)\\d{10}
//    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(((1)\\d{10})|((\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{4}|\\d{3})-?(\\d{7,8})|(\\d{7,8}))$)" options: NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(((1)\\d{10})|((0)(\\d{4}|\\d{3}|\\d{2})-?(\\d{7,8}))|((\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8}))$)" options: NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
//    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(((1)\\d{10})|((\\d{7,8})|(\\d{4}|\\d{3})-?(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})))" options: NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,HBMatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],HBMatchParserRange,[[NSMutableArray alloc]init],HBMatchParserRects,HBMatchParserLinkTypeMobie,HBMatchParserLinkType,nil];
        [_links addObject:dic];
    }
}


//匹配手机号
-(void)matchMobieLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(NSInteger)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,HBMatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],HBMatchParserRange,[[NSMutableArray alloc]init],HBMatchParserRects,HBMatchParserLinkTypeMobie,HBMatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

//匹配座机号
-(void)matchPhoneLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(NSInteger)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\d{11,12})|(\\d{7,8})|((\\d{4}|\\d{3})-(\\d{7,8}))|((\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|((\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        NSRegularExpression*regular1=[[NSRegularExpression alloc]initWithPattern:@"^(\\(86\\))?(13[0-9]|15[7-9]|152|153|156|18[7-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
        NSString * string=[source substringWithRange:result.range];
        NSUInteger numberOfMatches = [regular1 numberOfMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])];
        if (numberOfMatches>0) {
            return;
        }
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,HBMatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],HBMatchParserRange,[[NSMutableArray alloc]init],HBMatchParserRects,HBMatchParserLinkTypePhone,HBMatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

-(void)addLink:(NSRange)range string:(NSString*)string linkType:(NSString*)linkType   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    if (link) {
        link(self.attrString,range);
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,HBMatchParserString,[NSValue valueWithRange:range],HBMatchParserRange,[[NSMutableArray alloc]init],HBMatchParserRects,linkType,HBMatchParserLinkType,nil];
    [_links addObject:dic];
    [_links sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary * dic1=obj1;
        NSDictionary * dic2=obj2;
        NSRange range1=((NSValue *)[dic1 objectForKey:HBMatchParserRange]).rangeValue;
        NSRange range2=((NSValue *)[dic2 objectForKey:HBMatchParserRange]).rangeValue;
        if (range1.location<range2.location) {
            return  NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
}

#pragma mark - 刷新样式

/**
 *  更新样式
 */
-(void)updateMatchForLink:(NSRange)range isSelected:(BOOL)isSelected{
    CTFontRef fontRef2 = CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
//    NSDictionary *attributeSelected = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef2,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,[NSNumber numberWithFloat:1],kCTStrokeWidthAttributeName,nil];c     
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1],kCTStrokeWidthAttributeName,nil];
    if(isSelected){
        [self.attrString addAttributes:attribute range:range];
    } else {
        [self.attrString removeAttribute:(NSString*)kCTStrokeWidthAttributeName range:range];
    }
    
    CFRelease(fontRef2);
    
    [self refreshFrames];
}


-(void)refreshFrames
{
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(0,0, width, 10000);
    CGPathAddRect(path, NULL, textFrame );
    
    /* 需要重新添加表情大小，否则widthCallback中得不到图片大小 */
    for(NSDictionary * dic in self.images){
        NSInteger location= [[dic objectForKey:HBMatchParserLocation] integerValue];
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.getDescent = descentCallback;
        callbacks.dealloc = deallocCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                 [NSNumber numberWithFloat:(self.iconSize+2)], @"width",
                                 nil] ;
        CTRunDelegateRef delegate=CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary* attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                //set the delegate
                                                (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                nil];
        
        [self.attrString addAttributes:attrDictionaryDelegate range:NSMakeRange(location, 1)];
        
        CFRelease(delegate);
    }
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attrString length]), path, NULL);
    
    _ctFrame=(__bridge id)frame;
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}


@end
