//
//  TwoDCodeView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "TwoDCodeView.h"
#import "UIImageView+WebCache.h"

@implementation TwoDCodeView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
          imageName:(NSString *)imageName
{
    self = [super initWithFrame:(CGRect)frame
                          title:(NSString *)title
                       needBack:(BOOL)needBack
                       delegate:(id)delegate
                            tag:(int)tag];
    if (self) {
        // Initialization code
        CGSize size = self.contentView.bounds.size;

        float wh = (size.width / size.height) > 1.0 ? size.height : size.width;
        float x = (size.width - wh) / 2;
        //[Common addImageName:imageName onView:self.contentView frame:CGRectMake(x, 0, wh, wh)];
    
        icon = [Common initImageName:@"" onView:self.contentView frame:CGRectMake(x, 0, wh, wh)];
        [icon setImageWithURL:[Common getUrlWithImageName:imageName] placeholderImage:[UIImage imageNamed:@"qrcode.png"]];

    }
    return self;
}

- (void)setUrlImageName:(NSString *)imageName
{
    [icon setImageWithURL:[Common getUrlWithImageName:imageName] placeholderImage:[Common getDefaultBadImage]];
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
