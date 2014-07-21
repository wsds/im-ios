//
//  AddFriendViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "AddFriendViewController.h"
#import "BaseTitleView.h"
#import "NavView.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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

    
    CGRect findFriendFrame = CGRectMake(10, 70, self.view.frame.size.width - 20, 160);
    BaseTitleView *_findFriendView = [[BaseTitleView alloc] initWithFrame:findFriendFrame title:@"对方启用了朋友验证" needBack:NO delegate:self tag:0];
    [self.view addSubview:_findFriendView];
    
    //用户名
    _username_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.0 y:0.05 w:1.0 h:0.5 onSuperBounds:_findFriendView.contentView.bounds]];
    _username_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
    _username_tf.borderStyle = UITextBorderStyleNone;
    _username_tf.textAlignment = NSTextAlignmentLeft;
    _username_tf.placeholder = @"请输入验证消息";
    _username_tf.delegate = self;
    _username_tf.returnKeyType = UIReturnKeyDone;
    _username_tf.keyboardType = UIKeyboardTypeNumberPad;
    _username_tf.textColor = [UIColor whiteColor];
    [_findFriendView.contentView addSubview:_username_tf];
    
    [_username_tf becomeFirstResponder];
    
    UIButton *find_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    find_btn.frame = [Common RectMakex:0.0 y:0.6 w:1.0 h:0.4 onSuperBounds:_findFriendView.contentView.bounds];
    [find_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
    [find_btn setTitle:@"发送" forState:UIControlStateNormal];
    [find_btn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [_findFriendView.contentView  addSubview:find_btn];
    
    
    //nav
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:@"返回"
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction
{
    if ([_username_tf.text length] > 0) {
        NSLog(@"message==%@", _username_tf.text);
        
        NSDictionary *dic_params = @{@"phoneto":self.friendPhone,
                                     @"rid":@"rid",
                                     @"message":_username_tf.text};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_addfriend
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
    else
    {
        [Common alert4error:@"验证消息不能为空" tag:0 delegate:nil];
    }
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSDictionary *dic = result.myData;
    NSString *response = [dic valueForKey:ResponseMessKey];
    if ([response isEqualToString:@"添加成功"] || [response isEqualToString:@"发送请求成功"]) {
        NSLog(@"添加成功");
        [self navAction];
    }
    else if([response isEqualToString:@"添加失败"])
    {
        NSString *error = [dic valueForKey:@"失败原因"];
        [Common alert4error:error tag:0 delegate:nil];
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
