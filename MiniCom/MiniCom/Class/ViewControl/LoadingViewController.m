//
//  LoadingViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "LoadingViewController.h"
#import "Common.h"
#import "AccountManager.h"
#import "LoginViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

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

    //bg
    [Common addImageName:@"app_start.png" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //mar
    _marImageView = [Common initImageName:@"app_start_mar.png" onView:self.view frame:[Common RectMakex:0 y:0.8 w:1.0 h:0.2 onSuperBounds:kScreen_Frame]];

    //title
    [Common addImageName:@"app_start_text.png" onView:self.view frame:[Common RectMakex:0.5 y:0.9 w:0.45 h:0.05 onSuperBounds:kScreen_Frame]];
    
    //city
    _cityImageView = [Common initImageName:@"app_start_space_city.png" onView:self.view frame:[Common RectMakex:0.5 y:0.35 w:0.5 h:0.3 onSuperBounds:kScreen_Frame]];

    //star
    _starImageView = [Common initImageName:@"app_start_star.png" onView:self.view frame:[Common RectMakex:1.0 y:0.0 w:0.5 h:0.15 onSuperBounds:kScreen_Frame]];
    
    [UIView animateWithDuration:1.0 animations:^{
        _marImageView.frame = [Common RectMakex:0 y:0.8 w:1.05 h:0.21 onSuperBounds:kScreen_Frame];
        _cityImageView.frame = [Common RectMakex:0.8 y:0.35 w:0.5 h:0.3 onSuperBounds:kScreen_Frame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            _starImageView.frame = [Common RectMakex:-0.6 y:0.3 w:0.4 h:0.12 onSuperBounds:kScreen_Frame];
        } completion:^(BOOL finished) {
            [self loadSome];
        }];
    }];
}

- (void)loadSome
{
    //loading
    NSLog(@"loading username ==%@",[AccountManager SharedInstance].username);
    if ([[AccountManager SharedInstance].username length] > 0 && [[AccountManager SharedInstance].accessKey length] > 0)
    {
        NSLog(@"有账号 去登录?");
        //[self.navigationController popToRootViewControllerAnimated:NO];
#warning temp
        [self loginSuccess];
    }
    else
    {
        NSLog(@"没有账号 弹出登陆界面");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.delegate = self;
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)loginSuccess
{
    //loaded
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadingFinished)]) {
        [self.delegate loadingFinished];
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
