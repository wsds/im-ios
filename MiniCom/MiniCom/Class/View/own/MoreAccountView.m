//
//  MoreAccountView.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MoreAccountView.h"
#import "UIButton+WebCache.h"
#import "IconView.h"
#import "AccountData.h"

@implementation MoreAccountView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
{
    self = [super initWithFrame:(CGRect)frame
                          title:(NSString *)title
                       needBack:(BOOL)needBack
                       delegate:(id)delegate
                            tag:(int)tag];
    if (self) {
        // Initialization code
        //self.scrollv.backgroundColor = [UIColor blackColor];
        
        _sub_HHH = 2;
        _sub_VVV = 3;

        _subView_w = self.scrollv.bounds.size.width / _sub_VVV;
        _subView_h = self.scrollv.bounds.size.height / _sub_HHH;
        
        //backbtn
        float xOffset = 5.0;
        float w = 60;
        float h = 40;
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(xOffset, self.bounds.size.height - h, w, h);
        [self.leftBtn setTitle:@"上一组" forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(self.bounds.size.width - xOffset - w, self.bounds.size.height - h, w, h);
        [self.rightBtn setTitle:@"下一组" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        float pageX = self.leftBtn.frame.origin.x + self.leftBtn.frame.size.width;
        self.pageLb = [[UILabel alloc] init];
        self.pageLb.frame = CGRectMake(pageX, self.leftBtn.frame.origin.y, self.rightBtn.frame.origin.x - pageX, self.leftBtn.frame.size.height);
        self.pageLb.backgroundColor = [UIColor clearColor];
        self.pageLb.textColor = [UIColor whiteColor];
        self.pageLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.pageLb];
        
        self.pageLb.hidden = YES;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)updateAccountWithAry:(NSArray *)ary
{
    self.dataAry = ary;
    
    [self removeSubView];
    
    [self addSubviewWithAry:ary];
}

- (void)addSubviewWithAry:(NSArray *)ary
{
    if (ary && [ary count] > 0) {
        int onePageCount = _sub_HHH * _sub_VVV;
        int page = 0;
        if ([ary count] == 0) {
            page = 1;
        }
        else
        {
            page = (int)(([ary count] - 1 )/ onePageCount) + 1;
        }
        NSLog(@"page==%d", page);
        _pageController.numberOfPages = page;
        
        self.scrollv.contentSize = CGSizeMake(self.scrollv.bounds.size.width * page, self.scrollv.bounds.size.height);

        for (int i = 0; i < [ary count]; i++) {
            AccountData *acc = [ary objectAtIndex:i];

            float x = _sub_VVV * _subView_w * (i / onePageCount) + (i % _sub_VVV) * _subView_w;
            float y = _subView_h * ((i % onePageCount) / _sub_VVV);
            CGRect frame = CGRectMake(x, y, _subView_w, _subView_h);
            
            IconView *icon = [[IconView alloc] initWithFrame:frame image:acc.head title:acc.nickName];
            [icon addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            icon.tag = i;
            [self.scrollv addSubview:icon];
        }
    }
    else
    {
        NSLog(@"square view ary nil");
    }
}


- (void)removeSubView
{
    for (UIView *subView in self.scrollv.subviews) {
        if (subView) {
            [subView removeFromSuperview];
        }
    }
}

- (void)btnAction:(id)sender
{
    IconView *icon = (IconView *)sender;
    NSLog(@"tag==%d", icon.tag);
    AccountData *acc = [self.dataAry objectAtIndex:icon.tag];
    [self.accountListDelegate selectAccount:acc];
}

- (void)leftBtnAction
{
    [self.accountListDelegate leftBtnAction:self.viewTag];
}

- (void)rightBtnAction
{
    [self.accountListDelegate rightBtnAction:self.viewTag];
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
