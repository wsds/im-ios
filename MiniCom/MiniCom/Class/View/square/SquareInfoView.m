//
//  SquareInfoView.m
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareInfoView.h"
#import "Header.h"

@implementation SquareInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _lbItems = [[NSMutableArray alloc] init];
        _imageItems = [[NSMutableArray alloc] init];

        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        NSArray *imgNameAry = @[@"time.png", @"distance.png", @"comment.png", @"praise.png", @"collect.png"];
        float h = self.bounds.size.height;
        float hhh = 0.4;
        float xOffset = 10;
        float everyW = (self.bounds.size.width / [imgNameAry count]);
        float imgwh = h * hhh;
        for (int i = 0 ; i < [imgNameAry count] ; i++) {
            
            CGRect imgframe = CGRectMake(xOffset / 2 + everyW * i, self.bounds.size.height * (1 - hhh) / 2, imgwh, imgwh);
            UIImageView *imageV = [Common initImageName:[imgNameAry objectAtIndex:i] onView:self frame:imgframe];
            [self addSubview:imageV];

            [_imageItems addObject:imageV];

            //
            CGRect lbFrame = CGRectMake(imgframe.origin.x + imgframe.size.width + xOffset / 2, imgframe.origin.y, everyW - xOffset - imgwh, imgwh);
            UILabel *infoLb = [[UILabel alloc] init];
            infoLb.frame = lbFrame;
            infoLb.backgroundColor = [UIColor clearColor];
            infoLb.textColor = [UIColor whiteColor];
            infoLb.font = [UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]];
            [self addSubview:infoLb];
            
            [_lbItems addObject:infoLb];
            
            //
            CGRect btnFrame = CGRectMake(everyW * i, 0, everyW, h);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = btnFrame;
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (void)updateTime:(NSString *)time
             local:(NSString *)local
         noteCount:(int)note
         niceCount:(int)nice
         markCount:(int)mark
{
    for (int i=0; i<[_lbItems count]; i++) {
        UILabel *infoLb = [_lbItems objectAtIndex:i];
        NSString *info = @"";
        switch (i) {
            case 0:
                info = time;
                break;
            case 1:
                info = local;
                break;
            case 2:
                info = [NSString stringWithFormat:@"%d", note];
                break;
            case 3:
                info = [NSString stringWithFormat:@"%d", nice];
                break;
            case 4:
                info = [NSString stringWithFormat:@"%d", mark];
                break;
            default:
                break;
        }
        infoLb.text = info;
    }
}

- (void)setHadPraise:(BOOL)hadPraise
{
    UIImageView *imageV = [_imageItems objectAtIndex:3];
    NSString *name = @"praise.png";
    if (hadPraise) {
        name = @"praised.png";
    }
    imageV.image = [UIImage imageNamed:name];
}

- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"SquareInfoView btn tag==%d", btn.tag);
    switch (btn.tag) {
        case 3:
            [self.delegate addSquarePraise: !self.hadPraise];
            break;
            
        default:
            break;
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
