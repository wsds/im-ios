//
//  NewFriendViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendViewController : UIViewController
{
    UITableView *_friendTableView;
}

@property(nonatomic, retain) NSArray *friendAry;

- (void)updateTableAry:(NSArray *)ary;

@end
