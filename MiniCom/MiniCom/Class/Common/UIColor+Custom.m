
//
//  UIColor+Custom.m
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "UIColor+Custom.h"

#define RGB(r, g, b)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation UIColor (Custom)

+ (UIColor *)myNavBarColor
{
    return RGB(211.0, 211.0, 211.0);
}

+ (UIColor *)myNavColor
{
    return RGB(0x00, 0x3a, 0x6c);
}

+ (UIColor *)myNavFloatColor
{
    return [UIColor colorWithRed:0.04 green:0.19 blue:0.51 alpha:1.0];
}

@end
