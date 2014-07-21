//
//  SaveAccountCtrView.m
//  MiniCom
//
//  Created by wlp on 14-6-25.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SaveAccountCtrView.h"
#import "Header.h"

@implementation SaveAccountCtrView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [Common addImageName:@"button_background_click.png" onView:self frame:self.bounds];
        
        float hhh = 0.7;
        float xOffset = 20.0;
        float imgwh = self.bounds.size.height * hhh;
        
        //left
        CGRect btnFrame1 = CGRectMake(xOffset, 0, imgwh, imgwh);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnFrame1;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal.png"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -self.bounds.size.height * (0.85 - hhh), 0)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
        [btn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //right
        float x = self.bounds.size.width - imgwh - xOffset;
        CGRect btnFrame2 = CGRectMake(x, 0, imgwh, imgwh);
        UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rbtn.frame = btnFrame2;
        [rbtn setBackgroundImage:[UIImage imageNamed:@"circlemenu_item2_4.png"] forState:UIControlStateNormal];
        [rbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rbtn setTitle:@"取消" forState:UIControlStateNormal];
        [rbtn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -self.bounds.size.height * (0.85 - hhh), 0)];
        [rbtn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
        [rbtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rbtn];
    }
    return self;
}

- (void)leftBtnAction
{
    if ([self.delegate respondsToSelector:@selector(delegateSave)]) {
        [self.delegate delegateSave];
    }
}

- (void)rightBtnAction
{
    if ([self.delegate respondsToSelector:@selector(delegateCancel)]) {
        [self.delegate delegateCancel];
    }
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
