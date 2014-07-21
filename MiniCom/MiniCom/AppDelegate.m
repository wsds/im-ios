//
//  AppDelegate.m
//  MiniCom
//
//  Created by wlp on 14-5-14.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AccountManager.h"
#import "LocalData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.rootVC = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    
    [self initLocalService];
    
    return YES;
}

- (void)initLocalService
{
    if ([CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"locationServicesEnabled");
        
        // 检查定位服务是否可用
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation]; // 开始定位
    }
    else
    {
        NSLog(@"locationServicesEnabled no");
    }
}

// 定位成功时调用

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    static BOOL hasGetInfo = NO;
    if (!hasGetInfo) {
        /////////获取位置信息
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError *error)
         {
             if (placemarks.count >0  && !hasGetInfo )
             {
//                 CLPlacemark * plmark = [placemarks objectAtIndex:0];
//                 NSString * city    = plmark.locality;
//                 NSString * administrativeArea    = plmark.administrativeArea;
//                 if (city == NULL) {
//                     city = administrativeArea;
//                 }
                 CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
                 NSString *latStr = [NSString stringWithFormat:@"%f", mylocation.latitude];
                 NSString *longStr = [NSString stringWithFormat:@"%f", mylocation.longitude];
                 NSLog(@"latitude==%@,longitude==%@", latStr, longStr);

                 [[AccountManager SharedInstance] setLocalLat:latStr longitude:longStr];
                 
                 hasGetInfo = YES;
             }
             //NSLog(@"%@",placemarks);
         }];
    }
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken: %@", deviceToken);
    //deviceToken: <d005d91c acf74a3a 4f7091f6 aaabcf96 f9beb3f5 f05c32c4 85806ee2 f155d027>
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo:/n%@",userInfo);
    NSLog(@" 收到推送消息 ： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"To Penny"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
