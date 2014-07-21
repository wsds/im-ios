//
//  UserInfoViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"
#import "GroupInfoViewController.h"

#import "Common.h"
#import "AccountManager.h"
#import "SessionEvent.h"
#import "DBHelper.h"
#import "UIImageView+WebCache.h"
#import "AnalyTools.h"

#import "NavView.h"
#import "UserInfoView.h"
#import "GroupListView.h"
#import "TwoDCodeView.h"

#import "GroupData.h"

#define f_allScroll_h 2.6

#define f_info_y    f_allScroll_h * 0.24
#define f_info_h    f_allScroll_h * 0.15
#define f_group_y   f_allScroll_h * 0.4
#define f_group_h   f_allScroll_h * 0.24
#define f_twoView_y f_allScroll_h * 0.65
#define f_twoView_h f_allScroll_h * 0.24
#define f_btn1_y    f_allScroll_h * 0.9
#define f_btn1_h    f_allScroll_h * 0.028
#define f_btn2_y    f_allScroll_h * 0.935
#define f_btn2_h    f_allScroll_h * 0.028
#define f_btn3_y    f_allScroll_h * 0.970
#define f_btn3_h    f_allScroll_h * 0.028

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

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
    
    AccountData *friend = [[DBHelper sharedInstance] getAccountByID:self.account.ID];
    _isFriend = [friend.friendStatus isEqualToString:@"success"];
    
    //bg
    //[Common addImageName:@"background1.png" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bg];
    [bg setImageWithURL:[Common getUrlWithImageName:self.account.userBackground] placeholderImage:[UIImage imageNamed:@"background1.png"]];
    
    //
    [self loadScrollSubView];
    
    //nav
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:self.account.nickName
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
    
    //he's group
    [self requestGroupWith:self.account.phone];
}

- (void)loadScrollSubView
{
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = self.view.bounds;
    _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, _scrollv.bounds.size.height * f_allScroll_h);
    [self.view addSubview:_scrollv];
    
    UserInfoView *_userInfoView = [[UserInfoView alloc] initWithFrame:[Common RectMakex:0.05 y:f_info_y w:0.9 h:f_info_h onSuperBounds:kScreen_Frame]];
    [_userInfoView updateUserImage:self.account.head
                          nickName:self.account.nickName
                               uid:self.account.ID
                               tel:self.account.phone
                               sex:self.account.sex
                          business:self.account.mainBusiness];
    [_scrollv addSubview:_userInfoView];
    
    _userGroupView = [[GroupListView alloc] initWithFrame:[Common RectMakex:0.05 y:f_group_y w:0.9 h:f_group_h onSuperBounds:kScreen_Frame] title:@"他的群组" needBack:NO delegate:self tag:0];
    _userGroupView.groupListDelegate = self;
    [_scrollv addSubview:_userGroupView];
    
    //@"qrcode.png"
    TwoDCodeView *_twoDCodeView = [[TwoDCodeView alloc] initWithFrame:[Common RectMakex:0.05 y:f_twoView_y w:0.9 h:f_twoView_h onSuperBounds:kScreen_Frame]
                                                                title:@"二维码"
                                                             needBack:NO
                                                             delegate:nil
                                                                  tag:0
                                                            imageName:@"qrcode.png"];
    [_scrollv addSubview:_twoDCodeView];
    
    if (_isFriend) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = [Common RectMakex:0.05 y:f_btn1_y w:0.9 h:f_btn1_h onSuperBounds:kScreen_Frame];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [btn1 setTitle:@"发起聊天" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = [Common RectMakex:0.05 y:f_btn2_y w:0.9 h:f_btn2_h onSuperBounds:kScreen_Frame];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [btn2 setTitle:@"修改备注" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(changeNameAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:btn2];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = [Common RectMakex:0.05 y:f_btn3_y w:0.9 h:f_btn3_h onSuperBounds:kScreen_Frame];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [btn3 setTitle:@"解除好友关系" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(removeFriendAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:btn3];
    }
    else
    {
        UIButton *add_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        add_btn.frame = [Common RectMakex:0.05 y:f_btn1_y w:0.9 h:f_btn1_h onSuperBounds:kScreen_Frame];
        [add_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [add_btn setTitle:@"加为好友" forState:UIControlStateNormal];
        [add_btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:add_btn];
        
        UIButton *chat_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        chat_btn.frame = [Common RectMakex:0.05 y:f_btn2_y w:0.9 h:f_btn2_h onSuperBounds:kScreen_Frame];
        [chat_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [chat_btn setTitle:@"临时会话" forState:UIControlStateNormal];
        //[chat_btn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:chat_btn];
    }
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectGroup:(GroupData *)group;
{
    NSLog(@"selectGroup==%@", group.gid);
    //show group info
    GroupInfoViewController *groupInfoVC = [[GroupInfoViewController alloc] init];
    groupInfoVC.group = group;
    [self presentViewController:groupInfoVC animated:YES completion:nil];
}

- (void)showChatViewFriend:(AccountData *)account
{
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.sendType = SendType_Point;
    chatVC.friendAccount = account;
    NSLog(@"friendAccount head==%@", chatVC.friendAccount.head);
    
    [self presentViewController:chatVC animated:YES completion:^{
        [chatVC updateChatView];
    }];
}

- (void)chatAction
{
    [self showChatViewFriend:self.account];
}

- (void)changeNameAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入好友的备注" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 1;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)removeFriendAction
{
    NSString *message = [NSString stringWithFormat:@"确定解除和%@的好友关系吗?", self.account.nickName];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 2;
    [alertView show];
}

- (void)addAction
{
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    addFriendVC.friendPhone = self.account.phone;
    [self presentViewController:addFriendVC animated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"修改备注");
            UITextField *tf=[alertView textFieldAtIndex:0];
            [self modifyAlisa:tf.text];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            NSLog(@"解除好友");
            [self deleteFriend:self.account.phone];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
}

- (void)modifyAlisa:(NSString *)alias
{
    if ([alias length] > 0) {
        NSDictionary *dic_params = @{@"friend":self.account.phone,
                                     @"alias":alias};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_modifyalias
                                                        params:dic_params
                                                           tag:100
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }

}

- (void)deleteFriend:(NSString *)friend
{
    if ([friend length] > 0) {
        NSDictionary *dic_params = @{@"phoneto":friend};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_deletefriend
                                                        params:dic_params
                                                           tag:200
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
}

- (void)requestGroupWith:(NSString *)phone
{
    if ([phone length] > 0) {
        NSDictionary *dic_params = @{@"target":phone};
        
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_getusergroups
                                                        params:dic_params
                                                           tag:300
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
}

- (void)isSuccessEquals:(RequestResult *)result
{
    if (result.tag == 100) {
        //
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改备注成功"]) {
            NSLog(@"修改备注成功");
            
        }
        else if([response isEqualToString:@"修改备注失败"])
        {
            NSLog(@"修改备注失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
    else if (result.tag == 200) {
        //
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"删除成功"]) {
            NSLog(@"删除成功");
            
        }
        else if([response isEqualToString:@"删除失败"])
        {
            NSLog(@"删除失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
    else if (result.tag == 300) {
        //
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取好友群组成功"]) {
            NSLog(@"获取好友群组成功");
            NSMutableArray *groupsAry = [[NSMutableArray alloc] init];
            NSArray *groups = [dic valueForKey:@"groups"];
            for (int i=0; i<[groups count]; i++) {
                NSDictionary *valueDic = [groups objectAtIndex:i];
                GroupData *data = [[GroupData alloc] init];
                data.icon = [valueDic valueForKey:@"icon"];
                data.gid = [NSString stringWithFormat:@"%@",[valueDic valueForKey:@"gid"]];
                data.gtype = [valueDic valueForKey:@"gtype"];
                data.name = [valueDic valueForKey:@"name"];
                data.description = [valueDic valueForKey:@"description"];
                NSDictionary *localDic = [[valueDic valueForKey:@"location"] objectFromJSONString];
                data.location = [AnalyTools analyLocal:localDic];
                [groupsAry addObject:data];
            }
            [_userGroupView updateGroupWithAry:groupsAry];
        }
        else if([response isEqualToString:@"获取好友群组失败"])
        {
            NSLog(@"获取好友群组失败");
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
