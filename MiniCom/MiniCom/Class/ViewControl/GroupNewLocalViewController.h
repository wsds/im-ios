//
//  GroupNewLocalViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-28.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GroupNewLocalViewController : UIViewController
{
    UIView *_selectLocalView;
    
    MKMapView *_mapView;
    
    UIView *_navControlView;
}
@property (nonatomic, retain)NSMutableArray *membersAry;

@end
