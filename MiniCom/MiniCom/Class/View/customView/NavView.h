//
//  NavView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView
{
    UILabel *_titleLb;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           delegate:(id)delegate
                sel:(SEL)selector;

- (void)setTilte:(NSString *)title;

@end
