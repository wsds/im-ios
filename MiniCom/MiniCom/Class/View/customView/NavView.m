//
//  NavView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "NavView.h"
#import "Common.h"

@implementation NavView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           delegate:(id)delegate
                sel:(SEL)selector
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [Common addImageName:@"card_background_normal.png" onView:self frame:self.bounds];
        
        [Common addImageName:@"back.png" onView:self frame:[Common RectMakex:0.05 y:0.4 w:0.06 h:0.5 onSuperBounds:self.bounds]];

        _titleLb = [[UILabel alloc] init];
        _titleLb.frame = [Common RectMakex:0.15 y:0.3 w:0.8 h:0.7 onSuperBounds:self.bounds];
        _titleLb.text = title;
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLb];
        
        //
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:btn];
    }
    return self;
}

- (void)setTilte:(NSString *)title
{
    _titleLb.text = title;
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
