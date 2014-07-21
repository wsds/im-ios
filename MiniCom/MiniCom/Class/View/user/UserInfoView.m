//
//  UserInfoView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "UserInfoView.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "Header.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        icon = [Common initImageName:@"" onView:self frame:CGRectMake(0, 10, 40, 40)];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = icon.bounds.size.width / 2.0;
        
        nameLb = [[UILabel alloc] init];
        nameLb.frame = [Common RectMakex:0.2 y:0 w:0.8 h:0.3 onSuperBounds:self.bounds];
        nameLb.textColor = [UIColor whiteColor];
        nameLb.font = [UIFont boldSystemFontOfSize:[Common getCurFontSize:BaseFontSize_XL]];
        nameLb.numberOfLines = 2;
        [self addSubview:nameLb];
        
        uidLb = [[UILabel alloc] init];
        uidLb.frame = [Common RectMakex:0 y:0.3 w:1.0 h:0.1 onSuperBounds:self.bounds];
        uidLb.textColor = [UIColor whiteColor];
        [self addSubview:uidLb];
      
        telLb = [[UILabel alloc] init];
        telLb.frame = [Common RectMakex:0 y:0.4 w:1.0 h:0.1 onSuperBounds:self.bounds];
        telLb.textColor = [UIColor whiteColor];
        [self addSubview:telLb];
        
        sexLb = [[UILabel alloc] init];
        sexLb.frame = [Common RectMakex:0 y:0.5 w:1.0 h:0.1 onSuperBounds:self.bounds];
        sexLb.textColor = [UIColor whiteColor];
        [self addSubview:sexLb];
        
        busLb = [[UILabel alloc] init];
        busLb.frame = [Common RectMakex:0 y:0.6 w:1.0 h:0.4 onSuperBounds:self.bounds];
        busLb.textColor = [UIColor whiteColor];
        busLb.numberOfLines = 0;
        [self addSubview:busLb];
    }
    return self;
}

- (void)updateUserImage:(NSString *)imageName
               nickName:(NSString *)nickName
                    uid:(NSString *)uid
                    tel:(NSString *)tel
                    sex:(NSString *)sex
               business:(NSString *)business
{
    [icon setImageWithURL:[Common getUrlWithImageName:imageName] placeholderImage:[Common getDefaultAccountIcon]];
    nameLb.text = nickName;
    uidLb.text = [NSString stringWithFormat:@"ID:%@", uid];
    telLb.text = [NSString stringWithFormat:@"电话:%@", tel];
    sexLb.text = [NSString stringWithFormat:@"性别:%@", sex];
    busLb.text = [NSString stringWithFormat:@"主要业务:%@", business];
}

- (void)updateGroupImage:(NSString *)imageName
               groupName:(NSString *)groupName
                    uid:(NSString *)uid
            description:(NSString *)description
{
    [icon setImageWithURL:[Common getUrlWithImageName:imageName] placeholderImage:[Common getDefaultAccountIcon]];
    nameLb.text = groupName;
    uidLb.text = [NSString stringWithFormat:@"群组ID:%@", uid];
    telLb.text = [NSString stringWithFormat:@"群组描述:%@", description];
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
