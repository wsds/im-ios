//
//  GroupDetailView.h
//  MiniCom
//
//  Created by wlp on 14-6-11.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountData.h"

@protocol GroupDetailViewDelegate <NSObject>

- (void)selectMember:(AccountData *)account;

- (void)memberManagerAction;

@end

@interface GroupDetailView : UIView
{
    UILabel *_nameLb;
    UIScrollView  *_memberIconView;
}

@property (nonatomic, assign) id<GroupDetailViewDelegate> delegate;

@property (nonatomic, retain) NSArray *memberAry;

- (void)updateWithMember:(NSString *)name Ary:(NSArray *)ary;

@end
