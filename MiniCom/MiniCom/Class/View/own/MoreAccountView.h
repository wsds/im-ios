//
//  MoreAccountView.h
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupBaseView.h"
@class AccountData;

@protocol MoreAccountViewDelegate <NSObject>

- (void)selectAccount:(AccountData *)account;

- (void)leftBtnAction:(int)viewTag;

- (void)rightBtnAction:(int)viewTag;

@end

@interface MoreAccountView : GroupBaseView
{
}

@property (nonatomic, assign) int viewTag;

@property (nonatomic, retain) UIButton *leftBtn;

@property (nonatomic, retain) UIButton *rightBtn;

@property (nonatomic, retain) UILabel *pageLb;

@property (nonatomic, assign) id <MoreAccountViewDelegate>accountListDelegate;

@property (nonatomic, retain) NSArray *dataAry;

- (void)updateAccountWithAry:(NSArray *)ary;

@end
