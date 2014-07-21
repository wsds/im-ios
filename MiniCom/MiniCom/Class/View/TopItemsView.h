//
//  BtnItemsView.h
//  MiniCom
//
//  Created by wlp on 14-5-21.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SquareManager.h"

typedef enum {
    E_ShowView_Group_WoDe = 0,
    E_ShowView_Group_FuJin = 1,
}E_ShowView_Group;

typedef enum {
    E_ShowView_Own_MiYou = 0,
    E_ShowView_Own_XiaoXi = 1,
    E_ShowView_Own_MingPian = 2,
}E_ShowView_Own;

@protocol TopItemsViewBtnSelectDelegate <NSObject>

- (void)showSquareSelectViewByTag:(E_ShowView_Square)tag;

- (void)showGroupSelectViewByTag:(E_ShowView_Group)tag;

- (void)showOwnSelectViewByTag:(E_ShowView_Own)tag;

- (void)showChatView;

@end

@interface TopItemsView : UIView
{
    UIView *_baseView;
    UIView *_subView;
    
    UIView *_subView1;
    UILabel *_loaclLb;
    UIScrollView *_scrollv;
    UIView *_subView2;
    UIView *_subView3;
    
    NSArray *_titleAry;
    E_ShowView_Square   _squareIndex;
    E_ShowView_Group    _groupIndex;
    E_ShowView_Own      _ownIndex;
}

@property(nonatomic, assign) id<TopItemsViewBtnSelectDelegate> delegate;

- (void)setLocalTitle:(NSString *)loacl;

- (void)setDefaultShow;

@end
