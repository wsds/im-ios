//
//  BaseTitleView.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseTitleView.h"


@implementation BaseTitleView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backAutoHide = YES;
        
        self.delegate = delegate;
        self.myTag = tag;
        
        float xoffset = 0.02;
        float yoffset = 0.01;
        
        //bg
        [Common addImageName:@"button_background_click.png"
                      onView:self
                       frame:[Common RectMakex: -xoffset y: -yoffset w:1.0 + xoffset * 2 h:1.0 + yoffset * 2 onSuperBounds:self.bounds]];
        
        //
        float titleX = 5.0;
        float titleHeight = 40.0;
        float backHeightAndWidth = 40.0;
        float imageEdge = backHeightAndWidth / 4;

        //title
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(titleX, 0, self.bounds.size.width - backHeightAndWidth - titleX, titleHeight);
        _label.text = title;
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
        
        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _label.frame.origin.y + _label.frame.size.height, self.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        //contentview
        float offset_y = 5;
        float content_y = lineView.frame.origin.y + lineView.frame.size.height + offset_y;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, content_y, self.bounds.size.width, self.bounds.size.height - content_y - offset_y)];
        [self addSubview:_contentView];
        
        //长按手势
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                        
                                                        initWithTarget:self action:@selector(handleLongPress:)];
        longPressReger.minimumPressDuration = 0.7;
        [self addGestureRecognizer:longPressReger];
        
        //backbtn
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(self.bounds.size.width - backHeightAndWidth, 0, backHeightAndWidth, backHeightAndWidth);
        [backBtn setImage:[UIImage imageNamed:@"card_back.png"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(imageEdge, imageEdge, imageEdge, imageEdge)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        if (needBack) {
            backBtn.hidden = NO;
        }
        else
        {
            backBtn.hidden = YES;
        }
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.longPressEnable) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(longPressAction:)]) {
                [self.delegate longPressAction:self.myTag];
            }
        }
    }
}

- (void)backAction
{
    if (self.backAutoHide) {
        [self hide];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseViewBack:)]) {
        [self.delegate baseViewBack:self.myTag];
    }
}

- (void)setTopTitle:(NSString *)title
{
    _label.text = title;
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
