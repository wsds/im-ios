//
//  GroupNewLocalViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-28.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupNewLocalViewController.h"
#import "GroupCreatSuccessViewController.h"

#import "MyHttpRequest.h"
#import "Header.h"
#import "AccountData.h"
#import "AccountManager.h"

@interface GroupNewLocalViewController ()

@end

@implementation GroupNewLocalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];

    [self loadSelectLocalView];

    [self loadNavContrlView];
}

- (void)loadSelectLocalView
{
    _selectLocalView = [[UIView alloc] initWithFrame:[Common RectMakex:0.05 y:0.1 w:0.9 h:0.5 onSuperBounds:self.view.bounds]];
    [self.view addSubview:_selectLocalView];
    
    [Common addImageName:@"button_background_click.png" onView:_selectLocalView frame:_selectLocalView.bounds];
    
    UILabel *localLb = [[UILabel alloc] init];
    localLb.frame = [Common RectMakex:0 y:0 w:1.0 h:0.1 onSuperBounds:_selectLocalView.bounds];
    localLb.text = @" 请选择地点";
    localLb.textColor = [UIColor whiteColor];
    [_selectLocalView addSubview:localLb];

    _mapView = [[MKMapView alloc] initWithFrame:[Common RectMakex:0 y:0.1 w:1.0 h:0.9 onSuperBounds:_selectLocalView.bounds]];
    [_selectLocalView addSubview:_mapView];
    _mapView.mapType = MKMapTypeStandard;
    //_mapView.showsUserLocation=YES;
    _mapView.delegate = self;
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[locationManager location] coordinate];
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    
    float www = 24;
    float hhh = 35;
    float x = (_mapView.bounds.size.width - www) / 2;
    float y = _mapView.bounds.size.height / 2 - hhh;
    UIImageView *localIcon = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, www, hhh)];
    localIcon.image = [UIImage imageNamed:@"lbs_point.png"];
    [_mapView addSubview:localIcon];
}

//当前坐标

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation

{
    NSString *latStr = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
    NSString *longStr = [NSString stringWithFormat:@"%f", userLocation.coordinate.longitude];
    NSLog(@"cur latitude==%@,longitude==%@", latStr, longStr);
}

- (void)loadNavContrlView
{
    _navControlView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_navControlView];
    
    [Common addImageName:@"button_background_click.png" onView:_navControlView frame:_navControlView.bounds];
    
    float hhh = 0.7;
    float xOffset = 20.0;
    float imgwh = _navControlView.bounds.size.height * hhh;
    
    //left
    CGRect btnFrame1 = CGRectMake(xOffset, 0, imgwh, imgwh);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame1;
    [btn setBackgroundImage:[UIImage imageNamed:@"circlemenu_item2_4.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -_navControlView.bounds.size.height * (0.85 - hhh), 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
    [btn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_navControlView addSubview:btn];
    
    //right
    float x = _navControlView.bounds.size.width - imgwh - xOffset;
    CGRect btnFrame2 = CGRectMake(x, 0, imgwh, imgwh);
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rbtn.frame = btnFrame2;
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal.png"] forState:UIControlStateNormal];
    [rbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rbtn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -_navControlView.bounds.size.height * (0.85 - hhh), 0)];
    [rbtn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
    [rbtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_navControlView addSubview:rbtn];
}

- (void)leftBtnAction
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction
{
//        {phone: "XXX", accessKey: "XXX", type: ["createTempGroup", "createGroup", "upgradeGroup"], tempGid: "XXX", name: "XXX", description: "XXX", members: ["XXX", "XXX", "XXX"], location: {longitude: "NNN", latitude: "NNN"}}

    //creat group
    if (self.membersAry && [self.membersAry count] > 0) {
        NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
        for (int i=0; i<[self.membersAry count]; i++) {
            AccountData *acc = [self.membersAry objectAtIndex:i];
            [phoneAry addObject:acc.phone];
        }
        NSDictionary *localDic = @{@"longitude":[AccountManager SharedInstance].latitude,
                                   @"latitude":[AccountManager SharedInstance].longitude};
        NSDictionary *dic_params = @{@"type":@"createGroup",
                                     @"tempGid":@"",
                                     @"name":@"新建群组",
                                     @"description":@"",
                                     @"members":[phoneAry JSONString],
                                     @"location":[localDic JSONString]};
        
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_create
                                                        params:dic_params
                                                           tag:0
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
    else
    {
        NSLog(@"no have member");
    }
}


- (void)isSuccessEquals:(RequestResult *)result
{
    NSDictionary *dic = result.myData;
    NSString *response = [dic valueForKey:ResponseMessKey];
    if ([response isEqualToString:@"创建群组成功"]) {
        NSLog(@"创建群组成功");
        //{"提示信息":"创建群组成功","group":{"name":"groupName","gid":314,"icon":"978b3e6986071e464fd6632e1fd864652c42ca27.png","description":"description","location":"{\"longitude\":\"39.984808\",\"latitude\":\"116.407335\"}","gtype":"group"}}
        GroupCreatSuccessViewController *succesVC = [[GroupCreatSuccessViewController alloc] init];
        [self.navigationController pushViewController:succesVC animated:YES];
    }
    else if([response isEqualToString:@"创建群组失败"])
    {
        NSLog(@"创建群组 失败");
        NSString *error = [dic valueForKey:@"失败原因"];
        NSLog(@"error==%@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
