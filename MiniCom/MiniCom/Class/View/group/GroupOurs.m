//
//  GroupOurs.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupOurs.h"
#import "GroupData.h"
#import "GroupSubView.h"

@implementation GroupOurs

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
        _sub_VVV = 2;
        
        _subView_w = self.scrollv.bounds.size.width / _sub_VVV;
        _subView_h = self.scrollv.bounds.size.height / _sub_HHH;
        
        [self updateOurGroupWithAry:nil];
        
    }
    return self;
}

- (void)updateOurGroupWithAry:(NSArray *)ary
{
    self.dataAry = ary;
        
    [self removeSubView];

    [self addSubviewWithAry:ary];
}

- (void)addSubviewWithAry:(NSArray *)ary
{
    int onePageCount = _sub_HHH * _sub_VVV;
    
    int page = 0;
    if ([ary count] == 0) {
        page = 1;
    }
    else
    {
        page = (int)([ary count] / onePageCount) + 1;
    }
    
    NSLog(@"page==%d", page);
    _pageController.numberOfPages = page;

    self.scrollv.contentSize = CGSizeMake(self.scrollv.bounds.size.width * page, self.scrollv.bounds.size.height);
    
    for (int i = 0; i <= [ary count]; i++) {
        float x = _sub_VVV * _subView_w * (i / onePageCount) + (i % _sub_VVV) * _subView_w;
        float y = _subView_h * ((i % onePageCount) / _sub_VVV);
        CGRect frame = CGRectMake(x, y, _subView_w, _subView_h);
        GroupSubView *groupV = [[GroupSubView alloc] initWithFrame:frame];
        [self.scrollv addSubview:groupV];
        groupV.tag = i;
        [groupV addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i < [ary count]) {
            [groupV setType:ENUM_GROUP_SHOW];
            GroupData *gData = [ary objectAtIndex:i];
            [groupV updateWithGroupData:gData];
        }
        else
        {
            [groupV setType:ENUM_GROUP_ADD];
            [groupV setAddTitle:@"创建群组"];
        }
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
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag==%ld", (long)btn.tag);
    if (btn.tag == [self.dataAry count]) {
        [self.groupDelegate ourGroupAdd];
    }
    else
    {
        GroupData *data = [self.dataAry objectAtIndex:btn.tag];
        [self.groupDelegate selectOursGroup:data];;
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
