//
//  GroupListView.m
//  MiniCom
//
//  Created by wlp on 14-7-2.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupListView.h"
//#import "UIButton+WebCache.h"
#import "IconView.h"
#import "GroupData.h"

@implementation GroupListView

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
        
    }
    return self;
}

- (void)updateGroupWithAry:(NSArray *)ary;
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
            GroupData *group = [ary objectAtIndex:i];
            
            float x = _sub_VVV * _subView_w * (i / onePageCount) + (i % _sub_VVV) * _subView_w;
            float y = _subView_h * ((i % onePageCount) / _sub_VVV);
            CGRect frame = CGRectMake(x, y, _subView_w, _subView_h);
            
            IconView *icon = [[IconView alloc] initWithFrame:frame image:group.icon title:group.name];
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
    GroupData *group = [self.dataAry objectAtIndex:icon.tag];
    [self.groupListDelegate selectGroup:group];
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
