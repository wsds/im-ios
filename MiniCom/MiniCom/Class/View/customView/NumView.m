//
//  NumView.m
//  MiniCom
//
//  Created by wlp on 14-7-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "NumView.h"
#import "Header.h"

@implementation NumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImage = [UIImage imageNamed:@"number_hint.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:20.0];
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.image = bgImage;
        [self addSubview:_bgImageView];
        
        _numlb = [[UILabel alloc] init];
        _numlb.frame = self.bounds;
        _numlb.backgroundColor = [UIColor clearColor];
        _numlb.textColor = [UIColor whiteColor];
        _numlb.font = [UIFont boldSystemFontOfSize:[Common getCurFontSize:BaseFontSize_S]];
        _numlb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numlb];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _bgImageView.frame = self.bounds;
    _numlb.frame = self.bounds;
}

- (void)setNum:(int)num
{
    _numlb.text = [NSString stringWithFormat:@"%d", num];
//    CGSize fontSize =[_numlb.text sizeWithFont:_numlb.font
//                                      forWidth:_numlb.bounds.size.width
//                                 lineBreakMode:NSLineBreakByTruncatingTail];
//    _bgImageView.frame = CGRectMake(_bgImageView.frame.origin.x,
//                                    _bgImageView.frame.origin.y,
//                                    fontSize.width+ 80,
//                                    _bgImageView.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
