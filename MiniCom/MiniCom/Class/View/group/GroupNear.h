//
//  GroupNear.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupBaseView.h"
@class GroupData;

@protocol GroupNearDelegate <NSObject>

- (void)selectNearGroup:(GroupData *)groupData;

- (void)moreNearGrop;

@end

@interface GroupNear : GroupBaseView
{
    UIScrollView *_contentScrollV;
}

@property (nonatomic, assign) id <GroupNearDelegate>groupDelegate;

@property (nonatomic, retain) NSArray *dataAry;

- (void)updateNearGroupWithAry:(NSArray *)ary;

@end
