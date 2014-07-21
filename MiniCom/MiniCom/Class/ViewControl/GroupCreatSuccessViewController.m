//
//  GroupCreatSuccessViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupCreatSuccessViewController.h"
#import "BaseTitleView.h"

@interface GroupCreatSuccessViewController ()

@end

@implementation GroupCreatSuccessViewController

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

    BaseTitleView *infoView = [[BaseTitleView alloc] initWithFrame:[Common RectMakex:0.05 y:0.1 w:0.9 h:0.3 onSuperBounds:self.view.bounds]
                                                             title:@"创建群组完成"
                                                          needBack:NO
                                                          delegate:nil
                                                               tag:0];
    [self.view addSubview:infoView];
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:infoView.contentView.bounds];
    infoLb.textColor = [UIColor whiteColor];
    infoLb.text = @"您的群组已经创建完成，1km范围内的用户可以查看到，您需要增加群的影响力和覆盖范围，请增加群的活跃度，提升群组等级。";
    infoLb.numberOfLines = 4;
    infoLb.backgroundColor = [UIColor clearColor];
    [infoView.contentView addSubview:infoLb];
    
    [self loadNavContrlView];
}


- (void)loadNavContrlView
{
    _navControlView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_navControlView];
    
    [Common addImageName:@"button_background_click.png" onView:_navControlView frame:_navControlView.bounds];
    
    float hhh = 0.7;
    float imgwh = _navControlView.bounds.size.height * hhh;
    float x = (_navControlView.bounds.size.width - imgwh) / 2;
  
    CGRect btnFrame2 = CGRectMake(x, 0, imgwh, imgwh);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame2;
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -_navControlView.bounds.size.height * (0.85 - hhh), 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
    [btn addTarget:self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_navControlView addSubview:btn];
}

- (void)doneBtnAction
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Group object:nil];

    [self.navigationController popToRootViewControllerAnimated:NO];
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
