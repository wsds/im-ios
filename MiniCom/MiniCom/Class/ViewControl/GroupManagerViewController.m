//
//  GroupManagerViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupManagerViewController.h"
#import "GroupMemberSetController.h"

#import "NavView.h"
#import "MoreAccountView.h"
#import "GroupData.h"
#import "AccountData.h"
#import "AccountManager.h"

#import "GroupMemberSelectView.h"

@interface GroupManagerViewController ()

@end

@implementation GroupManagerViewController

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
    
    self.curGroupMembersAry = (NSMutableArray *)self.groupData.members;
    _selectedFriendsAry = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];

    [self loadCurGroupMembersView];
    
    [self loadSelectMembersView];
    
    [self loadContrlView];
    
//    //nav
//    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
//                                            title:@"返回"
//                                         delegate:self
//                                              sel:@selector(backAction)];
//    [self.view addSubview:nav];
}

- (void)leftBtnAction:(int)viewTag
{
    
}

-(void)rightBtnAction:(int)viewTag
{
    
}

- (void)loadCurGroupMembersView
{
    _curGroupAccountView = [[MoreAccountView alloc] initWithFrame:[Common RectMakex:0.05 y:0.05 w:0.9 h:0.5 onSuperBounds:self.view.bounds] title:self.groupData.name needBack:YES delegate:self tag:0];
    _curGroupAccountView.accountListDelegate = self;
    [self.view addSubview:_curGroupAccountView];
    
    [_curGroupAccountView updateAccountWithAry:self.curGroupMembersAry];
}

- (void)loadSelectMembersView
{
    _memberSelectView = [[GroupMemberSelectView alloc] initWithFrame:[Common RectMakex:0 y:0.8 w:1.0 h:0.2 onSuperBounds:kScreen_Frame]];
    _memberSelectView.delegate = self;
    [self.view addSubview:_memberSelectView];
    
    _memberSelectView.hidden = YES;
}

- (void)loadContrlView
{
    _contrlView = [[UIView alloc] initWithFrame:[Common RectMakex:0.0 y:0.9 w:1.0 h:0.1 onSuperBounds:self.view.bounds]];
    [self.view addSubview:_contrlView];
    
    [Common addImageName:@"button_background_click.png" onView:_contrlView frame:_contrlView.bounds];

    NSArray *nameAry = @[@"添加成员", @"移除成员", @"退出该群", @"修改组名"];
    NSArray *imageNameAry = @[@"button_addmembers.png", @"button_removemembers.png", @"button_quitegroup.png", @"button_modifygroupname.png"];
    
    float everyW = _contrlView.bounds.size.width / [nameAry count];
    float everyH = _contrlView.bounds.size.height;
    
    float hhh = 0.7;
    float xOffset = 20.0;
    float imgwh = everyH * hhh;
    
    for (int i=0; i<[nameAry count]; i++) {
        NSString *name = [nameAry objectAtIndex:i];
        NSString *image = [imageNameAry objectAtIndex:i];
        CGRect btnFrame1 = CGRectMake(everyW * i + xOffset, 0, imgwh, imgwh);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnFrame1;
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, -xOffset, -everyH * (0.85 - hhh), -xOffset)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
        [btn addTarget:self action:@selector(contrlBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_contrlView addSubview:btn];
    }
}

- (void)baseViewBack:(int)tag
{
    [self backAction];
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAccount:(AccountData *)account
{
    NSLog(@"account==%@", account.nickName);
    if (_memberSelectView.hidden == NO) {
        if (self.tempGroupMembersAry && [self.tempGroupMembersAry count] > 0) {
            NSLog(@"tempGroupMembersAry count==%d", [self.tempGroupMembersAry count]);
            if ([account.phone isEqualToString:[AccountManager SharedInstance].username]) {
                [Common alert4error:@"不能移除自己" tag:0 delegate:nil];
            }
            else
            {
                [self.tempGroupMembersAry removeObject:account];
                [self.selectedFriendsAry addObject:account];
                
                [self updateGroupAndSelectView];
            }
        }
    }
}

#pragma mark GroupMemberSelectView callback

- (void)cancelAction
{
    _memberSelectView.hidden = YES;
    _contrlView.hidden = NO;
    
    self.tempGroupMembersAry = self.curGroupMembersAry;
    [self.selectedFriendsAry removeAllObjects];
    [self updateGroupAndSelectView];
}

- (void)doneAction
{
    NSLog(@"to remove count==%d", [self.selectedFriendsAry count]);
    if ([self.selectedFriendsAry count] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要移除这些成员吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        [Common alert4error:@"请选择要移除的好友" tag:0 delegate:nil];
    }
    
}

- (void)selectMember:(AccountData *)account
{
    if (self.selectedFriendsAry && [self.selectedFriendsAry count] > 0) {
        NSLog(@"selectedFriendsAry count==%d", [self.selectedFriendsAry count]);
        [self.selectedFriendsAry removeObject:account];
        [self.tempGroupMembersAry addObject:account];
        
        [self updateGroupAndSelectView];
    }
}

- (void)updateGroupAndSelectView
{
    [_curGroupAccountView updateAccountWithAry:self.tempGroupMembersAry];
    [_memberSelectView updateWithMembers:self.selectedFriendsAry];
}

- (void)contrlBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag==%d", btn.tag);
    switch (btn.tag) {
        case 0:
        {
            GroupMemberSetController *addGroupVC = [[GroupMemberSetController alloc] init];
            addGroupVC.groupManagerType = ENUM_GROUP_Type_Add;
            //addGroupVC.myFriendsAry = [AccountManager SharedInstance].friendsAry;
            addGroupVC.myCircleAry = [AccountManager SharedInstance].circleAry;
            addGroupVC.curGroup = self.groupData;
            [self.navigationController pushViewController:addGroupVC animated:YES];
        }
            break;
        case 1:
        {
            _memberSelectView.hidden = NO;
            _contrlView.hidden = YES;
            
            _tempGroupMembersAry = [[NSMutableArray alloc] initWithArray:self.groupData.members];
            [_selectedFriendsAry removeAllObjects];
            [self updateGroupAndSelectView];
        }
            break;
        case 2:
        {
            NSString *message = [NSString stringWithFormat:@"确定要退出%@吗?", self.groupData.name];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];       alertView.tag = 2;
            [alertView show];
        }
            break;
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入新的群组名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];       alertView.tag = 3;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"移除成员");
            [self exitCurGroupMembers:self.selectedFriendsAry];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            NSLog(@"退群");
            [self exitCurGroup];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
    else if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            NSLog(@"修改群名");
            UITextField *tf=[alertView textFieldAtIndex:0];
            NSLog(@"input==%@", tf.text);
            if ([tf.text length] > 0) {
                [self changeGroupName:tf.text];
            }
            else
            {
                
            }
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
}

- (void)exitCurGroupMembers:(NSArray *)ary
{
    NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
    for (AccountData *acc in ary) {
        [phoneAry addObject:acc.phone];
    }
    NSString *memebersStr = [phoneAry JSONString];
    NSDictionary *dic_params = @{@"gid":self.groupData.gid,
                                 @"members":memebersStr};
    
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_removemembers
                                                    params:dic_params
                                                       tag:2
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:self.view
                delegate:self];
}

- (void)exitCurGroup
{
    NSString *phone = [AccountManager SharedInstance].username;
    NSDictionary *dic_params = @{@"gid":self.groupData.gid,
                                 @"members":[@[phone] JSONString]};
    
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_removemembers
                                                    params:dic_params
                                                       tag:3
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:self.view
                delegate:self];
}

- (void)changeGroupName:(NSString *)groupName
{
    NSDictionary *localDic = @{@"longitude":[AccountManager SharedInstance].latitude,
                               @"latitude":[AccountManager SharedInstance].longitude};
    NSDictionary *dic_params = @{@"gid":self.groupData.gid,
                                 @"name":groupName,
                                 @"description":self.groupData.description,
                                 @"location":[localDic JSONString]};
    
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_modify
                                                    params:dic_params
                                                       tag:4
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
    if (result.tag == 2 || result.tag == 3) {
        //{"提示信息":"修改群组信息成功","group":{"icon":"978b3e6986071e464fd6632e1fd864652c42ca27.png","gtype":"group","gid":312,"location":"{\"longitude\":\"116.423295\",\"latitude\":\"39.995343\"}","description":"请输入群组描述信息","name":"aaa"}}
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"退出群组成功"]) {
            NSLog(@"退出群组成功");
            //自己退出||移除好友
            [self backAction];
        }
        else if([response isEqualToString:@"退出群组失败"])
        {
            NSLog(@"退出群组失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
    else if (result.tag == 4) {
        //{"提示信息":"修改群组信息成功","group":{"icon":"978b3e6986071e464fd6632e1fd864652c42ca27.png","gtype":"group","gid":312,"location":"{\"longitude\":\"116.423295\",\"latitude\":\"39.995343\"}","description":"请输入群组描述信息","name":"aaa"}}
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改群组信息成功"]) {
            NSLog(@"修改群组信息成功");

        }
        else if([response isEqualToString:@"修改群组信息失败"])
        {
            NSLog(@"修改群组信息失败");
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
