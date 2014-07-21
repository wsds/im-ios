//
//  SquareMessViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareMessData.h"
//@class MyHttpRequest;
@class VoicePlayAnimationView;
@class SquareInfoView;

@protocol SquareInfoViewDelegate;
@protocol MyHttpDelegate;

@interface SquareMessViewController : UIViewController<UIScrollViewDelegate,SquareInfoViewDelegate, MyHttpDelegate>
{
    UIScrollView *_scrollv;
    
    float _yOffset;
    float _cur_y;
    
    VoicePlayAnimationView *_voiceView;
    
    SquareInfoView *_infoView;
}

@property(nonatomic, retain) SquareMessData *squareData;

@property(nonatomic, retain) UIImageView *tempImageView;
@end
