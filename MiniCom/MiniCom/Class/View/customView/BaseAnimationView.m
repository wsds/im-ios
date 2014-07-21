//
//  BaseAnimationView.m
//  GuessGame
//
//  Created by wanglipeng on 13-10-18.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#import "BaseAnimationView.h"


@implementation BaseAnimationView

- (void)dealloc{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)startAnimation
{
    //self.times = 0;
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / BaseAnimationTimes target:self selector:@selector(animationUpdate) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    //self.times = 0;
}

- (void)animationUpdate
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
