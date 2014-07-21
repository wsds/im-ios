//
//  MyInfoChangePasswordViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-4.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyInfoChangePasswordViewController.h"
#import "BaseKeyBoardContrlView.h"
#import "NavView.h"
#import "AccountManager.h"
#import "AccountData.h"
#import "MyHttpRequest.h"
#import "NSString+Tools.h"
#import "SaveAccountCtrView.h"

@interface MyInfoChangePasswordViewController ()

@end

@implementation MyInfoChangePasswordViewController

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
        
    _cellText_Ary = @[@"修改密码", @"原密码", @"修改密码", @"确认密码"];
    
    //bg
    [Common addImageName:@"background1.png" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgBtn.frame = kScreen_Frame;
    [_bgBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    //
    [self loadChangeInfoView];
    
    //control
    _ctrView = [[SaveAccountCtrView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_ctrView];
    _ctrView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_oldPassword_tf becomeFirstResponder];
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadChangeInfoView
{
    _okFrame = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.4 onSuperBounds:kScreen_Frame];
    _upFrame = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.4 onSuperBounds:kScreen_Frame];
    
    _infoView = [[UIView alloc] initWithFrame:_okFrame];
    [self.view addSubview:_infoView];
    
    [Common addImageName:@"button_background_click.png"
                  onView:_infoView
                   frame:_infoView.bounds];
    
    UITableView *table = [[UITableView alloc] initWithFrame:_infoView.bounds];
    table.contentSize = _infoView.bounds.size;
    [_infoView addSubview:table];
    table.backgroundColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    
//    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveBtn.frame = [Common RectMakex:0.0 y:0.81 w:1.0 h:0.18 onSuperBounds:_infoView.bounds];
//    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [saveBtn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
//    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [_infoView addSubview:saveBtn];
}

- (void)loadNavControlView
{
    BaseKeyBoardContrlView *navView = [[BaseKeyBoardContrlView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    //navView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = [Common RectMakex:0.85 y:0 w:0.15 h:1.0 onSuperBounds:navView.bounds];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellText_Ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row==%d", indexPath.row);
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changepassid"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    [Common addImageName:@"barometer.png" onView:cell frame:CGRectMake(10, cell.bounds.size.height - 1.0, tableView.bounds.size.width - 20, 1)];
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.frame = [Common RectMakex:0.02 y:0 w:0.38 h:1.0 onSuperBounds:cell.bounds];
    titleLb.text = [_cellText_Ary objectAtIndex:indexPath.row];
    titleLb.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:titleLb];
    
    switch (indexPath.row) {
        case 0:
        {

        }
            break;
        case 1:
        {
            _oldPassword_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds]];
            _oldPassword_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
            _oldPassword_tf.borderStyle = UITextBorderStyleNone;
            _oldPassword_tf.textAlignment = NSTextAlignmentRight;
            //_oldPassword_tf.placeholder = @"请输入原密码";
            [_oldPassword_tf setSecureTextEntry:YES];
            _oldPassword_tf.delegate = self;
            _oldPassword_tf.returnKeyType = UIReturnKeyDone;
            _oldPassword_tf.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:_oldPassword_tf];
        }
            break;
        case 2:
        {
            _newPassword_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds]];
            _newPassword_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
            _newPassword_tf.borderStyle = UITextBorderStyleNone;
            _newPassword_tf.textAlignment = NSTextAlignmentRight;
            //_newPassword_tf.placeholder = @"请输入新密码";
            [_newPassword_tf setSecureTextEntry:YES];
            _newPassword_tf.delegate = self;
            _newPassword_tf.returnKeyType = UIReturnKeyDone;
            _newPassword_tf.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:_newPassword_tf];
        }
            break;
        case 3:
        {
            _renewPassword_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds]];
            _renewPassword_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
            _renewPassword_tf.borderStyle = UITextBorderStyleNone;
            _renewPassword_tf.textAlignment = NSTextAlignmentRight;
            //_renewPassword_tf.placeholder = @"请确认输入新密码";
            [_renewPassword_tf setSecureTextEntry:YES];
            _renewPassword_tf.delegate = self;
            _renewPassword_tf.returnKeyType = UIReturnKeyDone;
            _renewPassword_tf.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:_renewPassword_tf];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [_oldPassword_tf resignFirstResponder];
    [_newPassword_tf resignFirstResponder];
    [_renewPassword_tf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ([_oldPassword_tf isFirstResponder]) {
//        return;
//    }
//    [UIView animateWithDuration:0.4 animations:^{
//        _infoView.frame = _upFrame;
//    }];
//}

//- (void)keyboardWillHide:(id)sender
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _infoView.frame = _okFrame;
//    }];
//}

//
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark save control

- (void)delegateSave
{
    NSString *old = _oldPassword_tf.text;
    NSString *password = _newPassword_tf.text;
    NSString *repassword = _renewPassword_tf.text;
    NSString *message = @"";
//    if ([old length] > 0 && [password length] > 0 && [repassword length] > 0) {
    if ([password length] > 0 && [repassword length] > 0) {
        if ([password isPassword] && [repassword isPassword]) {
            if ([password isEqualToString:repassword]) {
                [_oldPassword_tf resignFirstResponder];
                [_newPassword_tf resignFirstResponder];
                [_renewPassword_tf resignFirstResponder];
                
                [self changePasswordRequestOldPass:old newPass:repassword];
                
                return;
            }
            else
            {
                message = @"密码输入不一致";
            }
        }
        else
        {
            message = CheckPassword_Fail;
        }
    }
    else
    {
        if ([old length] == 0) {
            message = @"请输入原密码";
        }
        else if ([password length] == 0) {
            message = @"请输入新密码";
        }
        else if ([repassword length] == 0) {
            message = @"请确认输入新密码";
        }
    }
    [Common alert4error:message tag:0 delegate:nil];
}

- (void)changePasswordRequestOldPass:(NSString *)oldPass newPass:(NSString *)newPass
{
    NSString *nickName = [AccountManager SharedInstance].userInfoData.nickName;
    NSString *sex = [AccountManager SharedInstance].userInfoData.sex;
    NSString *phone = [AccountManager SharedInstance].userInfoData.phone;
    NSString *mainBusiness = [AccountManager SharedInstance].userInfoData.mainBusiness;
    NSString *head = [AccountManager SharedInstance].userInfoData.head;
    NSString *userBackground = [AccountManager SharedInstance].userInfoData.userBackground;
    
    self.passwordNew = newPass;
    
    NSString *shaOldPass = [oldPass sha1Str];
    NSString *shaPass = [newPass sha1Str];

    NSDictionary *accountDic = @{@"phone":phone,
                                 @"nickName":nickName,
                                 @"sex":sex,
                                 @"mainBusiness":mainBusiness,
                                 @"head":head,
                                 @"userBackground":userBackground,
                                 @"password":shaPass,};
    NSString *accountStr = [accountDic JSONString];
    
    NSDictionary *dic_params = @{@"oldpassword":shaOldPass,
                                 @"account":accountStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_modify
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
    //获取信息
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改用户信息成功"]) {
            NSLog(@"修改用户信息成功成功");
            [[AccountManager SharedInstance] setAndSavePassword:self.passwordNew];
            
            [self backAction];
        }
        else if([response isEqualToString:@"修改用户信息失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
    }
}

- (void)delegateCancel
{
    [self backAction];
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
