//
//  MessageControlView.m
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MessageControlView.h"

@implementation MessageControlView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        
        [Common addImageName:@"button_background_click.png" onView:self frame:self.bounds];
        
        NSArray *imgNameAry = @[@"", @"chat_voice_normal.png", @"chat_emoji_normal.png", @"release_pic.png", @""];
        NSArray *titleAry = @[@"取消", @"", @"", @"", @"完成"];
        
        float hhh = 0.8;
        //float xOffset = kScreen_Width / 5;
        float everyW = (self.bounds.size.width / [imgNameAry count]);
        float imgwh = self.bounds.size.height * hhh;
        float xOffset = (everyW - imgwh) / 2;
        float yOffset = (self.bounds.size.height - imgwh) / 2;

        for (int i = 0 ; i < [titleAry count] ; i++) {
            
            CGRect btnFrame = CGRectMake(xOffset + everyW * i, yOffset, imgwh, imgwh);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = btnFrame;
            btn.tag = i;
            NSString *imageName = [imgNameAry objectAtIndex:i];
            if ([imageName length] > 0) {
                [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                //[btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            NSString *titleName = [titleAry objectAtIndex:i];
            if ([titleName length] > 0) {
                [btn setTitle:titleName forState:UIControlStateNormal];
                //[btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -self.bounds.size.height * (0.85 - hhh), 0)];
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)btnAction:(id)sender
{    
    UIButton *btn = (UIButton *)sender;
    [self.delegate messCtrViewClickedButtonAtIndex:(E_MessState)btn.tag];
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
