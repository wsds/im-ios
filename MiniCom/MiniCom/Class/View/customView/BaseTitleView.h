//
//  BaseTitleView.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "NSString+Tools.h"
#import "MyHttpRequest.h"
#import "Header.h"

//@protocol titleViewBackDelegate;

@protocol titleViewBackDelegate <NSObject>

- (void)baseViewBack:(int)tag;

- (void)longPressAction:(int)tag;

@end

@interface BaseTitleView : UIView<UITextFieldDelegate>
{
    id _object;
}

@property (assign, nonatomic) id <titleViewBackDelegate>delegate;

@property (assign, nonatomic) int myTag;

@property (assign, nonatomic) BOOL longPressEnable;

@property (assign, nonatomic) BOOL backAutoHide;

@property (retain, nonatomic) UIView *contentView;

@property (retain, nonatomic) UILabel *label;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag;

- (void)show;

- (void)hide;

- (void)setTopTitle:(NSString *)title;

@end

