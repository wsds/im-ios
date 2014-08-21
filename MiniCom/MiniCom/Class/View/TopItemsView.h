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
    
    UIView  *view1;
    UIView  *view2;
    UIView *view3;
    UIView  *MHview;
    UILabel *label;
    UILabel  *label1;
    UILabel  *label2;
    UILabel  *label3;
    UIView  *xxView;
    UIImageView *GBView;
    UIImageView  *joinView;
    UILabel *newGrouplabel;
    UIImageView *qrcodeView;
    UILabel *personlabel;
    UIImageView *LinkmanView;
    UIImageView *LinkmanView1;
    UIImageView *GroupView;
     UIImageView *GroupView1;
    UIImageView *SquareView;
    UIImageView *SquareView1;
    
    UIImageView *currentShowMenuView;
    UIImageView *currentShowMenuView1;
    UIImageView *currentShowMenuView2;
    //UIView *publicLabelView;
    UIView *BigSquareView;
    UIView *BigGroupView;
    UIView *BigLinkmanView;

    int a1;
    int b1;
    
    int c1;
    int c2;
    
    
    
   
 
}

@property(nonatomic, assign) id<TopItemsViewBtnSelectDelegate> delegate;

@property(nonatomic, assign) E_ShowView_Square   squareIndex;
@property(nonatomic, assign) E_ShowView_Group    groupIndex;
@property(nonatomic, assign) E_ShowView_Own      ownIndex;


- (void)setLocalTitle:(NSString *)loacl;

- (void)setDefaultShow;

@end
