//
//  GroupListView.h
//  MiniCom
//
//  Created by wlp on 14-7-2.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupBaseView.h"

@class GroupData;

@protocol GroupListViewDelegate <NSObject>

- (void)selectGroup:(GroupData *)group;

@end

@interface GroupListView : GroupBaseView
{
    UIScrollView *_contentScrollV;
}

@property (nonatomic, assign) id <GroupListViewDelegate>groupListDelegate;

@property (nonatomic, retain) NSArray *dataAry;

- (void)updateGroupWithAry:(NSArray *)ary;

@end
