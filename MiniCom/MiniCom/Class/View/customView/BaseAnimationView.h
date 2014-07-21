//
//  BaseAnimationView.h
//  GuessGame
//
//  Created by wanglipeng on 13-10-18.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#define BaseAnimationTimes 30

#import <UIKit/UIKit.h>
#import "Common.h"

@interface BaseAnimationView : UIView
{
}
@property (nonatomic, assign) id delegate;
@property (assign, nonatomic) BOOL runAnimation;

@property (assign, nonatomic) int times;
@property (retain, nonatomic) NSTimer *timer;

- (void)startAnimation;

- (void)stopAnimation;

- (void)animationUpdate;

@end