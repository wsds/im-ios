//
//  IconView.h
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconView : UIView
{
    UIView *_iconView;
    UILabel *_titleLabel;
    UIButton *_iconViewBtn;
}
- (id)initWithFrame:(CGRect)frame image:(NSString*)image title:(NSString *)title;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
