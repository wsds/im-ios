//
//  GroupNavView.h
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//
#import <UIKit/UIKit.h>

#define SendType_Point @"point"
#define SendType_Group @"group"
#define SendType_TempGroup @"tempGroup"

@protocol GroupNavDelegate <NSObject>

- (void)navBack;

- (void)memberAction;

@end

@interface GroupNavView : UIView
{
    UILabel *_nameLb;
    UILabel *_countLb;

    UIScrollView  *_memberIconView;
}

@property (nonatomic, assign) id<GroupNavDelegate> delegate;

@property (nonatomic, retain) NSString *chatType;

- (void)updateWithMember:(NSString *)name Ary:(NSArray *)ary;

@end
