//
//  IconView.m
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "IconView.h"
#import "UIImageView+WebCache.h"
#import "Header.h"

@implementation IconView

- (id)initWithFrame:(CGRect)frame image:(NSString*)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if ([title length] == 0) {
            title = @"无名";
        }
                
        float titleH = 0.0;
        if (title && [title length] > 0) {
            titleH = 0.2;
        }
        float yOffset = 0.05;
        
        float titleHeight = self.bounds.size.height * titleH;
        float imageH = self.bounds.size.height * (1.0 - titleH - yOffset);
        float imageWH = imageH > self.bounds.size.width ? self.bounds.size.width : imageH;
        
        _iconView = [[UIView alloc] init];
        _iconView.frame = CGRectMake((self.bounds.size.width - imageWH) / 2, 0, imageWH, imageWH);
        [self addSubview:_iconView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = _iconView.bounds;
        [imageView setImageWithURL:[Common getUrlWithImageName:image] placeholderImage:[Common getDefaultAccountIcon]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2.0;
        [_iconView addSubview:imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, self.bounds.size.height - titleHeight, self.bounds.size.width, titleHeight);
        _titleLabel.font = [UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        _iconViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconViewBtn.frame = self.bounds;
        _iconViewBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconViewBtn];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _iconViewBtn.tag = tag;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_iconViewBtn addTarget:target action:action forControlEvents:controlEvents];
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
