//
//  GroupInfoViewController.m
//  MiniCom
//
//  Created by wlp on 14-7-2.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupInfoViewController.h"

#import "Common.h"
#import "AccountManager.h"
#import "SessionEvent.h"

#import "NavView.h"
#import "UserInfoView.h"
#import "TwoDCodeView.h"

#define f_allScroll_h 1.8

#define f_info_y    f_allScroll_h * 0.35
#define f_info_h    f_allScroll_h * 0.2
#define f_twoView_y f_allScroll_h * 0.55
#define f_twoView_h f_allScroll_h * 0.33
#define f_btn1_y    f_allScroll_h * 0.89
#define f_btn1_h    f_allScroll_h * 0.045
#define f_btn2_y    f_allScroll_h * 0.95
#define f_btn2_h    f_allScroll_h * 0.045

@interface GroupInfoViewController ()

@end

@implementation GroupInfoViewController

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
    
    //NSLog(@"account==%@", self.account);
    
    //bg
    [Common addImageName:@"background1.png" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //
    [self loadScrollSubView];
    
    //nav
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:@"群组资料"
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
    
    //[self getMembersGroupId:self.group.gid];
}

- (void)loadScrollSubView
{
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = self.view.bounds;
    _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, _scrollv.bounds.size.height * f_allScroll_h);
    [self.view addSubview:_scrollv];
    
    UserInfoView *_userInfoView = [[UserInfoView alloc] initWithFrame:[Common RectMakex:0.05 y:f_info_y w:0.9 h:f_info_h onSuperBounds:kScreen_Frame]];
    [_userInfoView updateGroupImage:self.group.icon
                          groupName:self.group.name
                                uid:self.group.gid
                        description:self.group.description];
    [_scrollv addSubview:_userInfoView];
    
    //@"qrcode.png"
    TwoDCodeView *_twoDCodeView = [[TwoDCodeView alloc] initWithFrame:[Common RectMakex:0.05 y:f_twoView_y w:0.9 h:f_twoView_h onSuperBounds:kScreen_Frame]
                                                                title:@"二维码"
                                                             needBack:NO
                                                             delegate:nil
                                                                  tag:0
                                                            imageName:@"qrcode.png"];
    [_scrollv addSubview:_twoDCodeView];
    
    UIButton *add_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    add_btn.frame = [Common RectMakex:0.05 y:f_btn1_y w:0.9 h:f_btn1_h onSuperBounds:kScreen_Frame];
    [add_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
    [add_btn setTitle:@"加入群组" forState:UIControlStateNormal];
    [add_btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollv addSubview:add_btn];
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addAction
{
    NSArray *phoneAry = @[[AccountManager SharedInstance].username];
    NSString *memebersStr = [phoneAry JSONString];
    NSDictionary *dic_params = @{@"gid":self.group.gid,
                                 @"members":memebersStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_addmembers
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

- (void)isSuccessEquals:(RequestResult *)result
{
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"加入群组成功"]) {
            NSLog(@"加入群组成功");
            [self navAction];
        }
        else if([response isEqualToString:@"加入群组失败"])
        {
            NSLog(@"加入群组失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
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
