//
//  MyInfoViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoChangeViewController.h"
#import "MainViewController.h"
#import "ChoosePhotoViewController.h"

#import "Common.h"
#import "AccountManager.h"
#import "MyNetManager.h"
#import "SessionEvent.h"

#import "NavView.h"
#import "UserInfoView.h"
#import "TwoDCodeView.h"
#import "UIImageView+WebCache.h"

#import "RSA.h"
#import "AnalyTools.h"

@interface MyInfoViewController ()

@end

#define f_allScroll_h 1.8

#define f_info_y    f_allScroll_h * 0.35
#define f_info_h    f_allScroll_h * 0.18
#define f_twoView_y f_allScroll_h * 0.55
#define f_twoView_h f_allScroll_h * 0.33
#define f_btn1_y    f_allScroll_h * 0.89
#define f_btn1_h    f_allScroll_h * 0.045
#define f_btn2_y    f_allScroll_h * 0.95
#define f_btn2_h    f_allScroll_h * 0.045


@implementation MyInfoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserinfoChangedNotification object:nil];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewAccount) name:UserinfoChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bg
     _bgImageView = [Common initImageName:@"background1.png"
                                   onView:self.view
                                    frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = self.view.bounds;
    _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, _scrollv.bounds.size.height * f_allScroll_h);
    [self.view addSubview:_scrollv];
    
    [self loadScrollSubView];
    
    //nav
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:@"个人资料"
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
    
    [self updateViewAccount];
}

- (void)loadScrollSubView
{
    UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backGroundBtn.frame = [Common RectMakex:0.05 y:0 w:0.9 h:f_info_y onSuperBounds:kScreen_Frame];
    [backGroundBtn addTarget:self action:@selector(backGroundBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollv addSubview:backGroundBtn];

    _userInfoView = [[UserInfoView alloc] initWithFrame:[Common RectMakex:0.05 y:f_info_y w:0.9 h:f_info_h onSuperBounds:kScreen_Frame]];
    [_scrollv addSubview:_userInfoView];

    _twoDCodeView = [[TwoDCodeView alloc] initWithFrame:[Common RectMakex:0.05 y:f_twoView_y w:0.9 h:f_twoView_h onSuperBounds:kScreen_Frame]
                                                  title:@"二维码"
                                               needBack:NO
                                               delegate:nil
                                                    tag:0
                                              imageName:@"qrcode.png"];
    [_scrollv addSubview:_twoDCodeView];
    
    UIButton *changeInfo_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeInfo_btn.frame = [Common RectMakex:0.05 y:f_btn1_y w:0.9 h:f_btn1_h onSuperBounds:kScreen_Frame];
    [changeInfo_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
    [changeInfo_btn setTitle:@"修改个人信息" forState:UIControlStateNormal];
    [changeInfo_btn addTarget:self action:@selector(changeInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollv addSubview:changeInfo_btn];
    
    UIButton *logout_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    logout_btn.frame = [Common RectMakex:0.05 y:f_btn2_y w:0.9 h:f_btn2_h onSuperBounds:kScreen_Frame];
    [logout_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
    [logout_btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout_btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollv addSubview:logout_btn];
}

- (void)backGroundBtnAction
{
    NSLog(@"backGroundBtnAction");
    ChoosePhotoViewController *choosePhotoVC = [[ChoosePhotoViewController alloc] init];
    choosePhotoVC.delegate = self;
    [self presentViewController:choosePhotoVC animated:YES completion:nil];
}

- (void)choosePhotoViewImage:(UIImage *)image
{
    _bgImageView.image = image;
    
    NSData *data = [Common scaleAndTransImage:image];
    
    self.imageFileName = [Common getFileNameResouceData:data type:@"jpg"];
    
    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:self.imageFileName];
    
    [self saveUserBackground:self.imageFileName];
}

- (void)updateViewAccount
{
    self.account = [AccountManager SharedInstance].userInfoData;
    
    //bg
    [_bgImageView setImageWithURL:[Common getUrlWithImageName:self.account.userBackground]placeholderImage:[UIImage imageNamed:@"background1.png"]];

    //user
    [_userInfoView updateUserImage:self.account.head
                          nickName:self.account.nickName
                               uid:self.account.ID
                               tel:self.account.phone
                               sex:self.account.sex
                          business:self.account.mainBusiness];
    
    //[_twoDCodeView setUrlImageName:self.account.head];
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeInfoAction
{
//    NSString *accessKey = @"0c6749a5b765a9604f27e78449cb074d9acddd0206275f5f5cb2a745bf8a214e08bb8b90d9133e49f4bae9f1d6e01db53043cfec6989508d01ada1d6007cc6d2";
//    //NSString *pbKey = @"5db114f97e3b71e1316464bd4ba54b25a8f015ccb4bdf7796eb4767f9828841#5db114f97e3b71e1316464bd4ba54b25a8f015ccb4bdf7796eb4767f9828841#3e4ee7b8455ad00c3014e82057cbbe0bd7365f1fa858750830f01ca7e456b659";
//    [self rsaAcc:accessKey pbKey:pbKey];
    
    MyInfoChangeViewController *myInfoChangeVC = [[MyInfoChangeViewController alloc] init];
    myInfoChangeVC.account = self.account;
    [self presentViewController:myInfoChangeVC animated:YES completion:nil];
}


- (void)rsaAcc:(NSString *)acckey pbKey:(NSString *)pbkey
{
    NSLog(@"acckey==%@", acckey);
    //NSLog(@"pbkey==%@", pbkey);

    RSA *rsa = [RSA shareInstance];
    [rsa generateKeyPairRSACompleteBlock:^{
        if (acckey) {
            //encrypt
            //NSData *encryptData = [acckey dataUsingEncoding:NSUTF8StringEncoding];
            NSData *encryptData = [acckey dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"encryptData==%@", encryptData);
            
            //decrypt
            NSData *decryptData = [rsa RSA_DecryptUsingPublicKeyWithData:encryptData];
            //NSData *decryptData = [rsa RSA_DecryptUsingPrivateKeyWithData:encryptData];
            
            NSLog(@"decryptData==%@", decryptData);

            NSString *newAcckey = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
            
            NSLog(@"newAcckey==%@", newAcckey);
        }
    }];
    
    //42b34908b9959f546fde97300640913ee664dfbd
}

-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

- (void)logoutAction
{
    NSString *mess = @"退出登录后您将接收不到任何消息，确定要退出登录吗？";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:mess
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //logout
        [self logoutRequest];
    }
}

- (void)logoutRequest
{
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_exit
                                                    params:nil
                                                       tag:1
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:self.view
                delegate:self];
}

- (void)saveUserBackground:(NSString *)background
{
    NSLog(@"saveUserBackground");

    NSDictionary *accountDic = @{@"userBackground":background};
    NSString *accountStr = [accountDic JSONString];
    
    NSString *oldpassword = @"";
    NSDictionary *dic_params = @{@"oldpassword":oldpassword,
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
    //更改信息
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改用户信息成功"]) {
            NSLog(@"修改用户信息成功成功");
        }
        else if([response isEqualToString:@"修改用户信息成功失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
    }
    //登出
    if (result.tag == 1) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"退出成功"]) {
            NSLog(@"退出登录成功");
            [Common alert4error:@"退出成功" tag:0 delegate:nil];
        }
        else if([response isEqualToString:@"退出失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
            
            [[AccountManager SharedInstance] setLogout];

            [self navAction];
            [self.mainVCdelegate presentLoginVC];
        }
    }
//    else if(result.tag == 1)
//    {
//        
//    }
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
