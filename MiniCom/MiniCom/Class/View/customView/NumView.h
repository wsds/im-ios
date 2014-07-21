//
//  NumView.h
//  MiniCom
//
//  Created by wlp on 14-7-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumView : UIView
{
    UIImageView *_bgImageView;
    
    UILabel *_numlb;
}
- (void)setNum:(int)num;

@end
