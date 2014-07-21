//
//  ImageControlView.m
//  MiniCom
//
//  Created by wlp on 14-6-5.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "PhotoControlView.h"
#import "Header.h"

@implementation PhotoControlView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        
        [Common addImageName:@"button_background_click.png" onView:self frame:self.bounds];

        NSArray *imgNameAry = @[@"picturs.png", @"camer.png", @"circlemenu_item2_4.png"];
        NSArray *titleAry = @[@"相册", @"拍照", @"取消"];

        float hhh = 0.7;
        float xOffset = kScreen_Width / 5;
        float everyW = (self.bounds.size.width / [imgNameAry count]);
        float imgwh = self.bounds.size.height * hhh;
        for (int i = 0 ; i < [titleAry count] ; i++) {
            
            CGRect btnFrame = CGRectMake(xOffset / 2 + everyW * i, 0, imgwh, imgwh);

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = btnFrame;
            btn.tag = i;
            [btn setBackgroundImage:[UIImage imageNamed:[imgNameAry objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [btn setTitle:[titleAry objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -self.bounds.size.height * (0.85 - hhh), 0)];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)btnAction:(id)sender
{
    //self.hidden = YES;
    
    UIButton *btn = (UIButton *)sender;
    [self.delegate photoCtrViewClickedButtonAtIndex:(int)btn.tag];
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
