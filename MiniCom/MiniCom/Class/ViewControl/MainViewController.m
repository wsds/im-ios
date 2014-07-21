//
//  MainViewController.m
//  LittleWeather
//
//  Created by wlp on 14-4-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MainViewController.h"
#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "MyInfoViewController.h"
#import "SendMessageViewController.h"
#import "SquareMessViewController.h"
#import "GroupMemberSetController.h"
#import "ChatViewController.h"
#import "MoreFriendViewController.h"
#import "NewFriendViewController.h"
#import "GroupInfoViewController.h"
#import "CircleSetViewController.h"

#import "Common.h"
#import "AnalyTools.h"

#import "MyNetManager.h"
#import "GroupManager.h"
#import "AccountManager.h"
#import "SquareManager.h"

#import "SessionEvent.h"
#import "SquareMessage.h"

#import "GroupData.h"
#import "CircleData.h"
#import "DBHelper.h"


#import <CoreLocation/CoreLocation.h>

@interface MainViewController ()

@end

//#define topHeight 0.18
#define topHeight 0.2

@implementation MainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SessionEvent_Group object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SessionEvent_Own object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NetChangeNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGroup) name:SessionEvent_Group object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOwn) name:SessionEvent_Own object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingFinished) name:NetChangeNotification object:nil];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewAry = [[NSMutableArray alloc] init];
    
    //bg
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //contentView
    [self loadContentView];
    
    //top btnitem
    [self loadViewContrlView];
    
    //
    [self pushLoading];
}

- (void)loadContentView
{
    _contentView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:topHeight w:1.0 h:1.0 - topHeight onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_contentView];
    
    //load Square
    [self loadSquareView];
    
    //load group
    [self loadGroupView];
    
    //load own
    [self loadOwnView];
}

- (void)loadViewContrlView
{
    _itemsView = [[TopItemsView alloc] initWithFrame:[Common RectMakex:0 y:0 w:1.0 h:topHeight onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_itemsView];
    _itemsView.delegate = self;
}

- (void)loadSquareView
{
    _squareView = [[SquareView alloc] initWithFrame:_contentView.bounds];
    _squareView.delegate = self;
    [_contentView addSubview:_squareView];
    
    [_viewAry addObject:_squareView];
}
- (void)loadGroupView
{
    _myGroupView = [[GroupOurs alloc] initWithFrame:[Common RectMakex:0.05 y:0.05 w:0.9 h:0.7 onSuperBounds:_contentView.bounds] title:@"我加入的群" needBack:NO delegate:self tag:0];
    [_myGroupView setFootTitle:@"群组设置"];
    _myGroupView.groupDelegate = self;
    [_contentView addSubview:_myGroupView];
    
    //
    _nearGroupView = [[GroupNear alloc] initWithFrame:[Common RectMakex:0.05 y:0.05 w:0.9 h:0.7 onSuperBounds:_contentView.bounds] title:@"附近活跃群组" needBack:NO delegate:self tag:0];
    [_nearGroupView setFootTitle:@"亦庄站"];
    _nearGroupView.groupDelegate = self;
    [_contentView addSubview:_nearGroupView];
    
    [_viewAry addObject:_myGroupView];
    [_viewAry addObject:_nearGroupView];
}

- (void)loadOwnView
{
    _myFriendsView = [[OwnFriendView alloc] initWithFrame:[Common RectMakex:0.02 y:0.01 w:0.96 h:0.98 onSuperBounds:_contentView.bounds]];
    _myFriendsView.delegate = self;
    [_contentView addSubview:_myFriendsView];
    
    _myMessageView = [[OwnMessageView alloc] initWithFrame:_contentView.bounds];
    _myMessageView.delegate = self;
    [_contentView addSubview:_myMessageView];
    
    [_viewAry addObject:_myFriendsView];
    [_viewAry addObject:_myMessageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadingFinished
{
    NSLog(@"loadingFinished");
    NSLog(@"phone==%@,uid==%@", [AccountManager SharedInstance].username, [AccountManager SharedInstance].uid);
    
    //开启接收聊天及广场信息循环
    [[SessionEvent SharedInstance] setSessionEventRequestStart:YES];
    [[SquareMessage SharedInstance] setSquareMessageRequestStart:YES];
    
    NSArray *squareAry = [[DBHelper sharedInstance] getSquareMessage];
    [[SquareMessage SharedInstance] setSquareDataWithMessAry:squareAry];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SquareEvent_MessageNotification object:nil];

    //获取用户资料
    [[AccountManager SharedInstance] getAccoutInfoRequest];
    
    //上传位置信息
    [[MyNetManager SharedInstance] reqestUploadLocationLat:[AccountManager SharedInstance].latitude longitude:[AccountManager SharedInstance].longitude];
    
    //group and own info
    [self requestGroup];
    
    [self requestOwn];
    
    //
    [_itemsView setLocalTitle:@"亦庄站"];
    [_itemsView setDefaultShow];
}

- (void)requestGroup
{
    [self getGroupsAndMembers];
    [self getNearGroups];
}

- (void)requestOwn
{
    [self getAskFriends];
    [self getCirclesAndFriends];
}

- (void)pushLoading
{
    LoadingViewController *loadVC = [[LoadingViewController alloc] init];
    loadVC.delegate = self;
    [self.navigationController pushViewController:loadVC animated:NO];
}

- (void)presentMyInfoVC
{
    MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] init];
    myInfoVC.mainVCdelegate = self;
    [self presentViewController:myInfoVC animated:YES completion:nil];
}

- (void)presentSendMessVC
{
    SendMessageViewController *sendMessVC = [[SendMessageViewController alloc] init];
    //sendMessVC.delegate = self;
    [self presentViewController:sendMessVC animated:YES completion:nil];
}

- (void)presentLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.delegate = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)loginSuccess
{
    NSLog(@"loginSuccess");
    [self loadingFinished];
}

- (void)hideAllSubContentView
{
    [_viewAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *)obj;
        view.hidden = YES;
    }];
}

//
#pragma mark topBtnItemsView callback

- (void)showSquareSelectViewByTag:(E_ShowView_Square)tag
{
    NSLog(@"Square==%d", tag);
    label.text = [NSString stringWithFormat:@"Square==%d", tag];
    
    [_squareView updateSquareWith:tag];

    [self hideAllSubContentView];
    _squareView.hidden = NO;
}

- (void)selectSquareWithId:(SquareMessData *)data
{
    SquareMessViewController *squareVC = [[SquareMessViewController alloc] init];
    squareVC.squareData = data;
    [self presentViewController:squareVC animated:YES completion:nil];
}

- (void)showGroupSelectViewByTag:(E_ShowView_Group)tag
{
    NSLog(@"Group==%d", tag);
    label.text = [NSString stringWithFormat:@"Group==%d", tag];
    UIView *view = nil;
    switch (tag) {
        case E_ShowView_Group_WoDe:
            view = _myGroupView;
            //[self getGroupsAndMembers];
            break;
        case E_ShowView_Group_FuJin:
            view = _nearGroupView;
            //[self getNearGroups];
            break;
        default:
            break;
    }
    if (view) {
        [self hideAllSubContentView];
        view.hidden = NO;
    }
}

- (void)showOwnSelectViewByTag:(E_ShowView_Own)tag
{
    NSLog(@"Own==%d", tag);
    label.text = [NSString stringWithFormat:@"Own==%d", tag];
    UIView *view = nil;
    switch (tag) {
        case E_ShowView_Own_MiYou:
            view = _myFriendsView;
            //[self getAskFriends];
            //[self getCirclesAndFriends];
            break;
        case E_ShowView_Own_XiaoXi:
            view = _myMessageView;
            [_myMessageView updateChatTable];
            break;
        case E_ShowView_Own_MingPian:
            [self presentMyInfoVC];
            break;
        default:
            break;
    }
    if (view) {
        [self hideAllSubContentView];
        view.hidden = NO;
    }
}



- (void)showChatView
{
    NSLog(@"showChatView");
    label.text = @"showChatView";
    [self presentSendMessVC];
}

//
#pragma mark OursGroupDelegate

- (void)selectOursGroup:(GroupData *)groupData;
{
    ChatViewController *groupVC = [[ChatViewController alloc] init];
    groupVC.sendType = SendType_Group;
    groupVC.groupData = groupData;
    
    [self presentViewController:groupVC animated:YES completion:^{
        [groupVC updateChatView];
    }];
}

- (void)ourGroupAdd
{
    GroupMemberSetController *addGroupVC = [[GroupMemberSetController alloc] init];
    addGroupVC.groupManagerType = ENUM_GROUP_Type_New;
    //addGroupVC.myFriendsAry = [AccountManager SharedInstance].friendsAry;
    addGroupVC.myCircleAry = [AccountManager SharedInstance].circleAry;
    [self.navigationController pushViewController:addGroupVC animated:YES];
}

- (void)selectNearGroup:(GroupData *)groupData
{
    NSLog(@"selectNearGroup==%@", groupData.gid);
    //show group info
    GroupInfoViewController *groupInfoVC = [[GroupInfoViewController alloc] init];
    groupInfoVC.group = groupData;
    [self presentViewController:groupInfoVC animated:YES completion:nil];
}

- (void)moreNearGrop
{
    NSLog(@"moreNearGrop");
    [self getNearGroups];
}

#pragma mark OursFrindDelegate

- (void)showNewFriend:(NSArray *)friendAry
{
    NewFriendViewController *newFriendVC = [[NewFriendViewController alloc] init];
    [self presentViewController:newFriendVC animated:YES completion:^{
        [newFriendVC updateTableAry:friendAry];
    }];
}

- (void)showChatViewFriend:(AccountData *)account
{
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.sendType = SendType_Point;
    chatVC.friendAccount = account;
    NSLog(@"friendAccount head==%@", chatVC.friendAccount.head);

//    [self presentViewController:chatVC animated:YES completion:^{
//        [chatVC updateChatView];
//    }];
    [self presentViewController:chatVC animated:YES completion:nil];
    [chatVC updateChatView];
}

- (void)showCircleSetViewPage:(int)page
{
    CircleSetViewController *circleVC = [[CircleSetViewController alloc] init];
    circleVC.mainVCdelegate = self;
    circleVC.page = page;
    [self presentViewController:circleVC animated:YES completion:nil];
}

- (void)moreFriend
{
    MoreFriendViewController *moreFriendVC = [[MoreFriendViewController alloc] init];
    [self presentViewController:moreFriendVC animated:YES completion:nil];
}

#pragma mark OursMessDelegate

- (void)showChatViewGroup:(NSString *)gid
{
//    GroupData *groupData = [[GroupData alloc] init];
//    groupData.gid = gid;
//    
//    AccountData *myAccount = [AccountManager SharedInstance].userInfoData;
//    NSMutableArray *members = [[NSMutableArray alloc] initWithArray:@[myAccount]];
//    NSArray *groupMember = [[DBHelper sharedInstance] getAccountByGid:gid];
//    [members addObjectsFromArray:groupMember];
//    groupData.members = members;
    
    GroupData * groupData= [[GroupManager SharedInstance] getGroupDataById:gid];
    [self selectOursGroup:groupData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
#pragma mark net request

//group
- (void)getGroupsAndMembers
{
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_getgroupsandmembers
                                                    params:nil
                                                       tag:210
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:_myGroupView
                delegate:self];
}

- (void)getNearGroups
{
    NSDictionary *areaDic = @{@"longitude": [AccountManager SharedInstance].longitude,
                              @"latitude": [AccountManager SharedInstance].latitude,
                              @"radius": [AccountManager SharedInstance].radius};
    NSString *areaDicStr = [areaDic JSONString];
    NSDictionary *dic_params = @{@"area":areaDicStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_lbs_nearbygroups
                                                    params:dic_params
                                                       tag:220
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:_nearGroupView
                delegate:self];
}

//- (void)getMembersGroupId:(NSString *)gid
//{
//    NSDictionary *dic_params = @{@"gid":gid};
//    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_group_getallmembers
//                                                    params:dic_params
//                                                       tag:230
//                                                   needHud:YES
//                                                   hudText:@""
//                                                 needLogin:YES];
//    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
//    [myHttp startRequest:params
//               hudOnView:_nearGroupView
//                delegate:self];
//}

//friend
- (void)getAskFriends
{
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_getaskfriends
                                                    params:nil
                                                       tag:310
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:_myFriendsView
                delegate:self];
}

- (void)getCirclesAndFriends
{
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_getcirclesandfriends
                                                    params:nil
                                                       tag:320
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:_myFriendsView
                delegate:self];
}

- (void)isSuccessEquals:(RequestResult *)result
{
    //group
    if (result.tag == 210) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取群组成功"]) {
            NSLog(@"获取群组请求成功");
            NSArray *ary = [dic valueForKey:@"groups"];
            //NSLog(@"groups ary==%@", ary);
            NSMutableArray *groupAry = [[NSMutableArray alloc] init];
            if (ary && [ary count] > 0) {
                for (int i = 0; i<[ary count]; i++) {
                    NSDictionary *valueDic = [ary objectAtIndex:i];
                    GroupData *data = [[GroupData alloc] init];
                    data.gid = [NSString stringWithFormat:@"%@",[valueDic valueForKey:@"gid"]];
                    data.gtype = [valueDic valueForKey:@"gtype"];
                    data.name = [valueDic valueForKey:@"name"];
                    data.description = [valueDic valueForKey:@"description"];
                    data.icon = [valueDic valueForKey:@"icon"];
                    NSDictionary *localDic = [[valueDic valueForKey:@"location"] objectFromJSONString];
                    data.location = [AnalyTools analyLocal:localDic];
                    NSMutableArray *memberAry = [[NSMutableArray alloc] init];
                    NSArray *accAry = [valueDic valueForKey:@"members"];
                    for (int i=0; i<[accAry count]; i++) {
                        NSDictionary *accountDic = [accAry objectAtIndex:i];
                        AccountData *acc = [AnalyTools analyAccount:accountDic];
                        acc.gid = [NSString stringWithFormat:@"%@",[valueDic valueForKey:@"gid"]];
                        [memberAry addObject:acc];
                    }
                    data.members = memberAry;
                    [groupAry addObject:data];
                }
            }
            [GroupManager SharedInstance].groupAry = groupAry;
            
            [_myGroupView updateOurGroupWithAry:groupAry];
        }
        else if([response isEqualToString:@"获取群组失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
        return;
    }
    if (result.tag == 220) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取附近群组成功"]) {
            NSLog(@"获取附近群组请求成功");
            NSArray *ary = [dic valueForKey:@"groups"];
            NSLog(@"near groups ary==%@", ary);
            NSMutableArray *groupAry = [[NSMutableArray alloc] init];
            if (ary && [ary count] > 0) {
                for (int i = 0; i<[ary count]; i++) {
                    NSDictionary *valueDic = [ary objectAtIndex:i];
                    GroupData *data = [[GroupData alloc] init];
                    data.gid = [NSString stringWithFormat:@"%@", [valueDic valueForKey:@"gid"]];
                    data.name = [valueDic valueForKey:@"name"];
                    data.description = [valueDic valueForKey:@"description"];
                    NSDictionary *localDic = [valueDic valueForKey:@"location"];
                    data.location = [AnalyTools analyLocal:localDic];

//                    data.gtype = [valueDic valueForKey:@"gtype"];
//                    data.icon = [valueDic valueForKey:@"icon"];
//                    NSMutableArray *memberAry = [[NSMutableArray alloc] init];
//                    NSArray *accAry = [valueDic valueForKey:@"members"];
//                    for (int i=0; i<[accAry count]; i++) {
//                        NSDictionary *accountDic = [accAry objectAtIndex:i];
//                        AccountData *acc = [AnalyTools analyAccount:accountDic];
//                        [memberAry addObject:acc];
//                    }
//                    data.members = memberAry;
                    [groupAry addObject:data];
                }
            }
            [_nearGroupView updateNearGroupWithAry:groupAry];
        }
        else if([response isEqualToString:@"获取附近群组失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            //[Common alert4error:error tag:0 delegate:nil];
        }
        return;
    }
    if (result.tag == 230) {
//        NSDictionary *dic = result.myData;
//        NSString *response = [dic valueForKey:ResponseMessKey];
//        if ([response isEqualToString:@"获取群组成员成功"]) {
//            NSLog(@"获取群组成员成功");
//            GroupData *data = [[GroupData alloc] init];
//            NSMutableArray *memberAry = [[NSMutableArray alloc] init];
//            NSArray *accAry = [dic valueForKey:@"members"];
//            for (int i=0; i<[accAry count]; i++) {
//                NSDictionary *accountDic = [accAry objectAtIndex:i];
//                AccountData *acc = [AnalyTools analyAccount:accountDic];
//                [memberAry addObject:acc];
//            }
//            data.members = memberAry;
//            [self selectOursGroup:data];
//        }
//        else if([response isEqualToString:@"获取群组成员失败"])
//        {
//            NSString *error = [dic valueForKey:@"失败原因"];
//            [Common alert4error:error tag:0 delegate:nil];
//        }
//        return;
    }
    
    //friend
    if (result.tag == 310) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取好友请求成功"]) {
            NSLog(@"获取好友请求成功");
            //[Common alert4error:@"获取好友请求成功" tag:0 delegate:nil];
            NSArray *ary = [dic valueForKey:@"accounts"];
            //NSLog(@"accounts ary==%@", ary);
            //存储用户信息
            NSMutableArray *frindsAry = [[NSMutableArray alloc] init];
            for (int i=0; i<[ary count]; i++) {
                NSDictionary *accountDic = [ary objectAtIndex:i];
                AccountData *data = [AnalyTools analyAccount:accountDic];
                [frindsAry addObject:data];
                [[DBHelper sharedInstance] insertOrUpdateAccount:data];
            }
            //更新视图
            [_myFriendsView updateNewFriendAry:frindsAry];
        }
        else if([response isEqualToString:@"获取好友请求失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            //[Common alert4error:error tag:0 delegate:nil];
        }
        return;
    }
    if(result.tag == 320)
    {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取密友圈成功"]) {
            NSLog(@"获取密友圈成功");
            //[Common alert4error:@"获取密友圈成功" tag:0 delegate:nil];
            NSArray *circlesAry = [dic valueForKey:@"circles"];
            if (circlesAry && [circlesAry count] > 0) {
                NSMutableArray *myCircleAry = [[NSMutableArray alloc] init];
                for (int i=0; i<[circlesAry count]; i++) {
                    CircleData *circle = [[CircleData alloc] init];
                    
                    NSDictionary *circles = [circlesAry objectAtIndex:i];
                    
                    NSString *rid = [NSString stringWithFormat:@"%@", [circles valueForKey:@"rid"]];
                    NSString *circleName = [circles valueForKey:@"name"];
                    NSArray *ary = [circles valueForKey:@"accounts"];
                    //存储用户信息
                    NSMutableArray *frindsAry = [[NSMutableArray alloc] init];
                    for (int i=0; i<[ary count]; i++) {
                        NSDictionary *accountDic = [ary objectAtIndex:i];
                        AccountData *data = [AnalyTools analyAccount:accountDic];
                        [frindsAry addObject:data];
                        [[DBHelper sharedInstance] insertOrUpdateAccount:data];
                    }
                    circle.rid = rid;
                    circle.name = circleName;
                    circle.accounts = frindsAry;
                    
                    [myCircleAry addObject:circle];
                }
                //保存我密友及分组
                [AccountManager SharedInstance].circleAry = myCircleAry;
                
                [_myFriendsView updateWithCircleAry:myCircleAry];
            }
            else
            {
                return;
            }
        }
        else if([response isEqualToString:@"获取密友圈失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
        return;
    }
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
