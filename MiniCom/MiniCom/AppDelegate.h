//
//  AppDelegate.h
//  MiniCom
//
//  Created by wlp on 14-5-14.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@class CLLocationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *rootVC;

@end
