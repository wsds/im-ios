//
//  GroupInfoViewController.h
//  MiniCom
//
//  Created by wlp on 14-7-2.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupData.h"

@interface GroupInfoViewController : UIViewController
{
    UIScrollView *_scrollv; 
}

@property (nonatomic, retain) GroupData *group;

@end
