//
//  MoreFriendViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MoreFriendViewController.h"
#import "NavView.h"
#import "UserInfoViewController.h"
#import "AnalyTools.h"
#import "AccountManager.h"

@interface MoreFriendViewController ()

@end


@implementation MoreFriendViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //bg
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //contentview
    [self loadScrollSubView];

    //
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:@"找到更多密友"
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
    
    [self nearFriendsRequest];
}

- (void)leftBtnAction:(int)viewTag
{
    
}

- (void)rightBtnAction:(int)viewTag
{
    
}

- (void)loadScrollSubView
{
    _okFrame = self.view.bounds;
    _upFrame = CGRectMake(_okFrame.origin.x, _okFrame.origin.y - 200, _okFrame.size.width, _okFrame.size.height);
    
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = _okFrame;
    _scrollv.delegate = self;
    [self.view addSubview:_scrollv];
    
    //
    float xoffset = 10.0;
    float yoffset = 20.0;
    CGRect friendFrame = CGRectMake(xoffset, 50, kScreen_Width - xoffset * 2, 300);
    _moreFriendView = [[MoreAccountView alloc] initWithFrame:friendFrame title:@"附近好友" needBack:NO delegate:self tag:0];
    _moreFriendView.accountListDelegate = self;
    [_scrollv addSubview:_moreFriendView];
    
//    [_moreFriendView updateAccountWithAry:nil];
    
    //
    CGRect findFriendFrame = CGRectMake(_moreFriendView.frame.origin.x, _moreFriendView.frame.origin.y + _moreFriendView.frame.size.height + yoffset, _moreFriendView.frame.size.width, 160);
    _findFriendView = [[BaseTitleView alloc] initWithFrame:findFriendFrame title:@"精确查找" needBack:NO delegate:self tag:0];
    [_scrollv addSubview:_findFriendView];
    
    //用户名
    _username_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.0 y:0.05 w:1.0 h:0.5 onSuperBounds:_findFriendView.contentView.bounds]];
    _username_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
    _username_tf.borderStyle = UITextBorderStyleNone;
    _username_tf.textAlignment = NSTextAlignmentLeft;
    _username_tf.placeholder = @"请输入手机号";
    _username_tf.delegate = self;
    _username_tf.returnKeyType = UIReturnKeyDone;
    _username_tf.keyboardType = UIKeyboardTypeNumberPad;
    _username_tf.textColor = [UIColor whiteColor];
    [_findFriendView.contentView addSubview:_username_tf];
    
    UIButton *find_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    find_btn.frame = [Common RectMakex:0.0 y:0.6 w:1.0 h:0.4 onSuperBounds:_findFriendView.contentView.bounds];
    [find_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
    [find_btn setTitle:@"查找" forState:UIControlStateNormal];
    [find_btn addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
    [_findFriendView.contentView  addSubview:find_btn];
    
    //扫描
    CGRect scanFrame = CGRectMake(_findFriendView.frame.origin.x, _findFriendView.frame.origin.y + _findFriendView.frame.size.height + yoffset, _findFriendView.frame.size.width, 40);
    UIButton *scan_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    scan_btn.frame = scanFrame;
    [scan_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
    [scan_btn setTitle:@"扫描" forState:UIControlStateNormal];
    [scan_btn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollv  addSubview:scan_btn];
    
    _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, scan_btn.frame.origin.y + scan_btn.frame.size.height + yoffset);
}

- (void)nearFriendsRequest
{
    NSDictionary *areaDic = @{@"longitude": [AccountManager SharedInstance].longitude,
                              @"latitude": [AccountManager SharedInstance].latitude,
                              @"radius": [AccountManager SharedInstance].radius};
    NSString *areaDicStr = [areaDic JSONString];
    NSDictionary *dic_params = @{@"area":areaDicStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_lbs_nearbyaccounts
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

- (void)findAction
{
    if ([_username_tf.text length] > 0) {
        NSString *phonetoAryString = [@[_username_tf.text] JSONString];
        NSDictionary *dic_params = @{@"target":phonetoAryString};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_get
                                                        params:dic_params
                                                           tag:1
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
}

- (void)scanAction
{
    
}

- (void)isSuccessEquals:(RequestResult *)result
{
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取附近用户成功"]) {
            NSLog(@"获取附近用户成功");
            //{phone: "NNN", mainBusiness: "XXX", head: "XXX", nickName: "XXX", location: {longitude: "NNN", latitude: "NNN"}, modify_time: "NNN", distance: "NNN"}
            NSMutableArray *memberAry = [[NSMutableArray alloc] init];
            NSArray *accAry = [dic valueForKey:@"accounts"];
            for (int i=0; i<[accAry count]; i++) {
                NSDictionary *accountDic = [accAry objectAtIndex:i];
                AccountData *acc = [AnalyTools analyAccount:accountDic];
                [memberAry addObject:acc];
            }
            [_moreFriendView updateAccountWithAry:memberAry];
            //[Common alert4error:[NSString stringWithFormat:@"附近好友%d个", [memberAry count]] tag:0 delegate:nil];
        }
        else if([response isEqualToString:@"获取附近用户失败"])
        {
            //NSString *error = [dic valueForKey:@"失败原因"];
            //[Common alert4error:error tag:0 delegate:nil];
        }
    }
    
    if (result.tag == 1) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取用户信息成功"]) {
            NSLog(@"获取用户信息成功");
            NSArray *ary = [dic valueForKey:@"accounts"];
            if (ary && [ary count] > 0) {
                NSDictionary *accountDic = [ary objectAtIndex:0];
                [self showAccountInfo:[AnalyTools analyAccount:accountDic]];
            }
        }
        else if([response isEqualToString:@"获取用户信息失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
    }

}

- (void)selectAccount:(AccountData *)account
{
    [self showAccountInfo:account];
}

- (void)showAccountInfo:(AccountData *)account
{
    UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
    userVC.account = account;
    [self presentViewController:userVC animated:YES completion:nil];
}

////

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_username_tf resignFirstResponder];
}

- (void)keyboardWillHide:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollv.frame = _okFrame;
    }];
}

- (void)keyboardWillShow:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollv.frame = _upFrame;
    }];
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
