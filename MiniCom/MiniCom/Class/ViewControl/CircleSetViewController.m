//
//  CircleSetViewController.m
//  MiniCom
//
//  Created by wlp on 14-7-4.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "CircleSetViewController.h"
#import "MainViewController.h"

#import "AccountData.h"
#import "AccountManager.h"
#import "GroupData.h"
#import "CircleData.h"

#import "IconView.h"
#import "MoreAccountView.h"

#import "GroupMemberSelectView.h"

@interface CircleSetViewController ()

@end

@implementation CircleSetViewController

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
    
    _myCircleAry = [[NSMutableArray alloc] initWithArray:[AccountManager SharedInstance].circleAry];
    
    _selectedFriendsAry = [[NSMutableArray alloc] init];
    
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    _myCircleView = [[UIScrollView alloc] initWithFrame:[Common RectMakex:0.0 y:0.05 w:1.0 h:0.6 onSuperBounds:self.view.bounds]];
    _myCircleView.showsHorizontalScrollIndicator = NO;
    _myCircleView.scrollEnabled = NO;
    [self.view addSubview:_myCircleView];
    
    _memberSelectView = [[GroupMemberSelectView alloc] initWithFrame:[Common RectMakex:0 y:0.8 w:1.0 h:0.2 onSuperBounds:kScreen_Frame]];
    _memberSelectView.delegate = self;
    [self.view addSubview:_memberSelectView];
    [_memberSelectView setControlShow:NO];
    
    [self loadContrlView];
    
    [self updateWithCircleAry:self.myCircleAry];
    
    [self setCirclePage:self.page];
}

- (void)loadContrlView
{
    _contrlView = [[UIView alloc] initWithFrame:[Common RectMakex:0.0 y:0.9 w:1.0 h:0.1 onSuperBounds:self.view.bounds]];
    [self.view addSubview:_contrlView];
    
    [Common addImageName:@"button_background_click.png" onView:_contrlView frame:_contrlView.bounds];
    
    NSArray *nameAry = @[@"保存",
                         @"修改组名",
                         @"删除该组",
                         @"复制",
                         @"新建分组"];
    NSArray *imageNameAry = @[@"save_up.png",
                              @"button_modifygroupname.png",
                              @"button_deletegroup.png",
                              @"choise_up.png",
                              @"button_newgroup.png"];
    
    float everyW = _contrlView.bounds.size.width / [nameAry count];
    float everyH = _contrlView.bounds.size.height;
    
    float hhh = 0.7;
    float xOffset = 20.0;
    float imgwh = everyH * hhh;
    float inSet = 5;
    
    for (int i=0; i<[nameAry count]; i++) {
        NSString *name = [nameAry objectAtIndex:i];
        NSString *image = [imageNameAry objectAtIndex:i];
        CGRect btnFrame1 = CGRectMake(everyW * i + xOffset, 0, imgwh, imgwh);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnFrame1;
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(inSet, inSet, inSet, inSet)];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height + inSet, -xOffset, -everyH * (0.85 - hhh) - inSet, -xOffset)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
        [btn addTarget:self action:@selector(contrlBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_contrlView addSubview:btn];
    }
}

- (void)baseViewBack:(int)tag
{
    if ([self.selectedFriendsAry count] == 0) {
        [self cancelAction];
    }
    else
    {
        NSLog(@"打算将未分组的好友至于何地？");
    }
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateWithCircleAry:(NSArray *)ary
{
    for (UIView *view in _myCircleView.subviews) {
        [view removeFromSuperview];
    }
    float xOffset = 10.0;
    float www = _myCircleView.bounds.size.width;
    float w = www - xOffset * 2;
    float h = w - 20;
    
    for (int i=0; i<[ary count]; i++) {
        CircleData *circle = [ary objectAtIndex:i];
        
        CGRect circleFrame = CGRectMake(xOffset + www * i, 0, w, h);
        MoreAccountView *subCircleView = [[MoreAccountView alloc] initWithFrame:circleFrame title:circle.name needBack:YES delegate:self tag:0];
        subCircleView.accountListDelegate = self;
        subCircleView.backAutoHide = NO;
        subCircleView.viewTag = i;
        [_myCircleView addSubview:subCircleView];
        [subCircleView updateAccountWithAry:circle.accounts];
        
        subCircleView.leftBtn.hidden = NO;
        subCircleView.rightBtn.hidden = NO;
        if (i == 0) {
            subCircleView.leftBtn.hidden = YES;
        }
        if (i == [ary count] - 1) {
            subCircleView.rightBtn.hidden = YES;
        }
        subCircleView.pageLb.hidden = NO;
        subCircleView.pageLb.text = [NSString stringWithFormat:@"(%d/%d)", i + 1, (int)[ary count]];
    }
    
    //set frame
    _myCircleView.contentSize = CGSizeMake(www * [ary count], _myCircleView.bounds.size.height);
}

- (void)leftBtnAction:(int)viewTag
{
    NSLog(@"left viewTag==%d", viewTag);
    self.page = viewTag - 1;
    [self setCirclePage:self.page];
}

- (void)rightBtnAction:(int)viewTag
{
    NSLog(@"right viewTag==%d", viewTag);
    self.page = viewTag + 1;
    [self setCirclePage:self.page];
}

- (void)setCirclePage:(int)page
{
    self.curCircle = [self.myCircleAry objectAtIndex:page];
    
    CGRect frame = CGRectMake(_myCircleView.bounds.size.width * page,
                              _myCircleView.frame.origin.y,
                              _myCircleView.bounds.size.width,
                              _myCircleView.bounds.size.height);
    [_myCircleView scrollRectToVisible:frame animated:YES];
}

- (void)selectAccount:(AccountData *)account
{
    self.curAccount = account;
    
    [self movePhone:account.phone rid:self.curCircle.rid filter:@"REMOVE"];
}

#pragma mark GroupMemberSelectView callback

- (void)selectMember:(AccountData *)account
{
    self.curAccount = account;
    
    [self movePhone:account.phone rid:self.curCircle.rid filter:@"SHIFTIN"];
}

- (void)updateSelectFriend:(NSArray *)friends
{
    [_memberSelectView updateWithMembers:friends];
}


#pragma mark  contrl call

- (void)contrlBtnAction:(id)sender
{
    NSLog(@"curCircle.name==%@", self.curCircle.name);
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag==%d", btn.tag);
    switch (btn.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入新的密友圈名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 1;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            
            UITextField *tf=[alertView textFieldAtIndex:0];
            tf.text = self.curCircle.name;
        }
            break;
        case 2:
        {
            NSString *mess = @"确定要删除该组？删除该组后该组好友如果不在其它分组将被自动转移到默认分组中。";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:mess delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 2;
            [alertView show];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入分组名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 4;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if ([tf.text length] > 0) {
                if ([self.curCircle.name isEqualToString:tf.text]) {
                    
                }
                else
                {
                    [self changeCurCircleId:self.curCircle.rid name:tf.text];
                }
            }
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self deleteCurCircleId:self.curCircle.rid];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
    else if (alertView.tag == 4) {
        if (buttonIndex == 0) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if ([tf.text length] > 0) {
                [self newCircleName:tf.text];
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

- (void)movePhone:(NSString *)phone rid:(NSString *)rid filter:(NSString *)filter
{
    if (rid && [rid length] > 0 && [phone length] > 0) {
        NSLog(@"phone==%@", phone);
        NSLog(@"rid==%@", rid);
        NSLog(@"filter==%@", filter);
        NSDictionary *dic_params = @{@"rid":rid,
                                     @"phoneto":[@[phone] JSONString],
                                     @"filter":filter};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_circle_moveorout
                                                        params:dic_params
                                                           tag:0
                                                       needHud:NO
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
}

- (void)changeCurCircleId:(NSString *)rid name:(NSString *)name
{
    if ([name length] > 0) {
        NSDictionary *dic_params = @{@"rid":rid,
                                     @"circleName":name};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_circle_modify
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

- (void)deleteCurCircleId:(NSString *)rid
{
    if (rid > 0) {
        NSDictionary *dic_params = @{@"rid":rid};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_circle_delete
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

- (void)newCircleName:(NSString *)name
{
    if ([name length] > 0) {
        NSDictionary *dic_params = @{@"name":name};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_circle_addcircle
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
    if (result.tag == 0) {
        NSString *messKey = @"提示消息";
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:messKey];
        if ([response isEqualToString:@"移出成功"] || [response isEqualToString:@"移入成功"]) {
            if ([response isEqualToString:@"移出成功"]) {
                [self.curCircle.accounts removeObject:self.curAccount];
                [self updateWithCircleAry:self.myCircleAry];
                
                [self.selectedFriendsAry addObject:self.curAccount];
                [self updateSelectFriend:self.selectedFriendsAry];
            }
            else if([response isEqualToString:@"移入成功"])
            {
                [self.selectedFriendsAry removeObject:self.curAccount];
                [self updateSelectFriend:self.selectedFriendsAry];
                
                [self.curCircle.accounts addObject:self.curAccount];
                [self updateWithCircleAry:self.myCircleAry];
            }
            //update
            [self.mainVCdelegate getCirclesAndFriends];
        }
        else if([response isEqualToString:@"移出失败"] || [response isEqualToString:@"移入失败"])
        {
            NSLog(@"移出/移入 失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
        else
        {
            NSLog(@"移出 || 移入 not found");
        }
    }
    else if (result.tag == 100) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改成功"]) {
            NSLog(@"修改分组名称成功");
            [self dismissAndUpdateCircle];
        }
        else if([response isEqualToString:@"修改失败"])
        {
            NSLog(@"修改失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
    else if (result.tag == 200) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"删除成功"]) {
            NSLog(@"删除分组成功");
            [self dismissAndUpdateCircle];
        }
        else if([response isEqualToString:@"删除失败"])
        {
            NSLog(@"删除失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
    else if (result.tag == 300) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"添加成功"]) {
            NSLog(@"添加分组成功");
            [self dismissAndUpdateCircle];
        }
        else if([response isEqualToString:@"添加失败"])
        {
            NSLog(@"添加失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
    }
}

- (void)dismissAndUpdateCircle
{
    [self cancelAction];
    
    [self.mainVCdelegate getCirclesAndFriends];
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
