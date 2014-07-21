//
//  LoadingViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingDelegate <NSObject>

- (void)loadingFinished;

@end

@protocol LoginDelegate;

@interface LoadingViewController : UIViewController<LoginDelegate>
{
    UIImageView *_starImageView;
    UIImageView *_cityImageView;
    UIImageView *_marImageView;
}

@property (assign, nonatomic) id <LoadingDelegate>delegate;

@end
