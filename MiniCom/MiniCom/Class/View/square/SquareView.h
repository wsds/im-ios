//
//  SquareView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareManager.h"

@interface SquareView : UIView
{
    UIScrollView *_contentScrollV;
    
    float _subView_w;
    float _subView_h;
    
    E_ShowView_Square   _index;
}

@property(nonatomic, assign) id delegate;

- (void)updateSquareWith:(E_ShowView_Square)type;

@end
