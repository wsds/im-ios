//
//  GroupMemberSetController.m
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupMemberSetController.h"
#import "GroupNewLocalViewController.h"

#import "AccountData.h"
#import "AccountManager.h"
#import "GroupData.h"
#import "CircleData.h"

#import "IconView.h"
#import "MoreAccountView.h"

#import "GroupMemberSelectView.h"

@interface GroupMemberSetController ()

@end

@implementation GroupMemberSetController

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
    
    _selectedFriendsAry = [[NSMutableArray alloc] init];
    
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    _myCircleView = [[UIScrollView alloc] initWithFrame:[Common RectMakex:0.0 y:0.05 w:1.0 h:0.6 onSuperBounds:self.view.bounds]];
    _myCircleView.showsHorizontalScrollIndicator = NO;
    _myCircleView.scrollEnabled = NO;
    [self.view addSubview:_myCircleView];
    
    _memberSelectView = [[GroupMemberSelectView alloc] initWithFrame:[Common RectMakex:0 y:0.8 w:1.0 h:0.2 onSuperBounds:kScreen_Frame]];
    _memberSelectView.delegate = self;
    [self.view addSubview:_memberSelectView];
    
    [self updateWithCircleAry:self.myCircleAry];
}

- (void)baseViewBack:(int)tag
{
    [self cancelAction];
}

- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateWithCircleAry:(NSArray *)ary
{
//    for (UIView *view in _circleView.subviews) {
//        [view removeFromSuperview];
//    }
    float xOffset = 10.0;
    float www = _myCircleView.bounds.size.width;
    float w = www - xOffset * 2;
    float h = w - 20;

    for (int i=0; i<[ary count]; i++) {
        CircleData *circle = [ary objectAtIndex:i];
        
        CGRect circleFrame = CGRectMake(xOffset + www * i, 0, w, h);
        MoreAccountView *subCircleView = [[MoreAccountView alloc] initWithFrame:circleFrame title:circle.name needBack:NO delegate:self tag:0];
        subCircleView.accountListDelegate = self;
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
    int page = viewTag - 1;
    [self setCirclePage:page];
}

- (void)rightBtnAction:(int)viewTag
{
    NSLog(@"right viewTag==%d", viewTag);
    int page = viewTag + 1;
    [self setCirclePage:page];
}

- (void)setCirclePage:(int)page
{
    CGRect frame = CGRectMake(_myCircleView.bounds.size.width * page,
                               _myCircleView.frame.origin.y,
                               _myCircleView.bounds.size.width,
                               _myCircleView.bounds.size.height);
    [_myCircleView scrollRectToVisible:frame animated:YES];
}

#pragma mark MoreAccountView callback

- (void)selectAccount:(AccountData *)account
{
    NSLog(@"selectAccount nickName==%@", account.nickName);
    
    BOOL inCurGroup = [self checkAccount:account inCurGroup:self.curGroup.members];
    if (inCurGroup) {
        [Common alert4error:@"群组中已存在" tag:0 delegate:nil];
    }
    else
    {
        if ([self.selectedFriendsAry containsObject:account]) {
            NSLog(@"had");
            [Common alert4error:@"用户已添加" tag:0 delegate:nil];
        }
        else{
            NSLog(@"no have to add");
            [self.selectedFriendsAry addObject:account];
        }
        [self updateSelectFriend:self.selectedFriendsAry];
    }
}

- (BOOL)checkAccount:(AccountData *)acc inCurGroup:(NSArray *)ary
{
    for (AccountData *data in ary) {
        if ([data.phone isEqualToString:acc.phone]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark GroupMemberSelectView callback

- (void)selectMember:(AccountData *)account
{
    [self.selectedFriendsAry removeObject:account];
    [self updateSelectFriend:self.selectedFriendsAry];
}

- (void)updateSelectFriend:(NSArray *)friends
{
    [_memberSelectView updateWithMembers:friends];
}

- (void)doneAction
{
    if ([self.selectedFriendsAry count] > 0) {
        if (self.groupManagerType == ENUM_GROUP_Type_New) {
            NSLog(@"to new group");
            GroupNewLocalViewController *groupLocalVC = [[GroupNewLocalViewController alloc] init];
            AccountData *myData = [AccountManager SharedInstance].userInfoData;
            [self.selectedFriendsAry addObject:myData];
            groupLocalVC.membersAry = self.selectedFriendsAry;
            [self.navigationController pushViewController:groupLocalVC animated:YES];
        }
        else if (self.groupManagerType == ENUM_GROUP_Type_Add) {
            NSLog(@"to add member");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要添加这些好友吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = ENUM_GROUP_Type_Add;
            [alertView show];
        }
        else
        {
            NSLog(@"set group member");
        }
    }
    else
    {
        [Common alert4error:@"请选择好友" tag:0 delegate:nil];
    }
}

#pragma mark

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ENUM_GROUP_Type_Add) {
        if (buttonIndex == 0) {
            NSLog(@"添加群成员");
            [self addCurGroupMembers:self.selectedFriendsAry];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"取消");
        }
    }
}

- (void)addCurGroupMembers:(NSArray *)ary
{
    NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
    for (AccountData *acc in ary) {
        [phoneAry addObject:acc.phone];
    }
    NSString *memebersStr = [phoneAry JSONString];
    NSDictionary *dic_params = @{@"gid":self.curGroup.gid,
                                 @"members":memebersStr};
    
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_addmembers
                                                    params:dic_params
                                                       tag:ENUM_GROUP_Type_Add
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
    if (result.tag == ENUM_GROUP_Type_Add) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"加入群组成功"]) {
            NSLog(@"加入群组成功");
            [self cancelAction];
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
