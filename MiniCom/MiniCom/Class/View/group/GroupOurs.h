//
//  GroupOurs.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupBaseView.h"
@class GroupData;

@protocol GroupOursDelegate <NSObject>

- (void)selectOursGroup:(GroupData *)groupData;

- (void)ourGroupAdd;

@end

@interface GroupOurs : GroupBaseView
{
    UIScrollView *_contentScrollV;
}

@property (nonatomic, assign) id <GroupOursDelegate>groupDelegate;

@property (nonatomic, retain) NSArray *dataAry;

- (void)updateOurGroupWithAry:(NSArray *)ary;

@end
