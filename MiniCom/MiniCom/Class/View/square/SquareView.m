//
//  SquareView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareView.h"
#import "SquareSubView.h"

@implementation SquareView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SquareEvent_MessageNotification object:nil];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSquareView) name:SquareEvent_MessageNotification object:nil];

        
        _contentScrollV = [[UIScrollView alloc] init];
        _contentScrollV.frame = self.bounds;
        _contentScrollV.showsHorizontalScrollIndicator = YES;
        _contentScrollV.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollV];
        
        _subView_w = _contentScrollV.bounds.size.width / 2;
        _subView_h = _contentScrollV.bounds.size.height / 2;
        
        NSLog(@"%f, %f", _subView_w, _subView_h);

//        UILabel *label = [[UILabel alloc] init];
//        label.frame = [Common RectMakex:0 y:0.1 w:1.0 h:0.18 onSuperBounds:self.bounds];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
    }
    return self;
}

- (void)updateSquareView
{
    NSLog(@"notifi updateSquareView");
    [self updateSquareWith:_index];
}

- (void)updateSquareWith:(E_ShowView_Square)type
{
    _index = type;
    
    NSArray *squareAry = [[SquareManager SharedInstance] getSquareMessWithType:type];
    
    [self removeSubView];
    
    [self addSubviewWithAry:squareAry];
}

- (void)addSubviewWithAry:(NSArray *)ary
{
    if (ary) {
        int vvv = ([ary count] + 1 ) / 2 ;
        
        NSLog(@"vvv==%d", vvv);

        _contentScrollV.contentSize = CGSizeMake(_subView_w * vvv, _subView_h * 2);

        for (int i = 0; i < [ary count]; i++) {
            //数据倒序
            int index = [ary count] - 1 - i;
            SquareMessData *data = [ary objectAtIndex:index];
            CGRect frame = CGRectMake(_subView_w * (i / 2), _subView_h * (i % 2), _subView_w, _subView_h);
            SquareSubView *view = [[SquareSubView alloc] initWithFrame:frame data:data];
            view.delegate = self;
            [_contentScrollV addSubview:view];
        }
    }
    else
    {
        NSLog(@"square view ary nil");
    }
}


- (void)removeSubView
{
    for (UIView *subView in _contentScrollV.subviews) {
        if (subView) {
            [subView removeFromSuperview];
        }
    }
}

- (void)selectSquareWithId:(SquareMessData *)data
{
    [self.delegate selectSquareWithId:data];
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
