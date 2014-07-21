//
//  NewFriendViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NavView.h"
#import "NewFriendCell.h"
#import "MyHttpRequest.h"
#import "AccountData.h"
#import "DBHelper.h"
#import "AnalyTools.h"

#define FriendTableRow 6

@interface NewFriendViewController ()

@end

@implementation NewFriendViewController

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

    CGRect frame = [Common RectMakex:0 y:0.1 w:1.0 h:0.8 onSuperBounds:self.view.bounds];
    _friendTableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:_friendTableView];
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.delegate = self;
    _friendTableView.dataSource = self;
    _friendTableView.hidden = YES;
    
    //nav
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:@"返回"
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
    
    [self getAskFriends];
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTableAry:(NSArray *)ary
{
    self.friendAry = ary;
    if ([self.friendAry count] > 0) {
        _friendTableView.hidden = NO;
        [_friendTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height / FriendTableRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    static NSString *flag = @"chats";
    NewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[NewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        [cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height / FriendTableRow)];
    }
    AccountData *data = [self.friendAry objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell setCellWithData:data];
    return cell;
}

- (void)selectMember:(AccountData *)account status:(BOOL)status
{
    NSString *statusStr = @"false";
    if (status) {
        statusStr = @"true";
    }
    NSDictionary *dic_params = @{@"phoneask":account.phone,
                                 @"rid":account.rid,
                                 @"status":statusStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_addfriendagree
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

//friend
- (void)getAskFriends
{
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_relation_getaskfriends
                                                    params:nil
                                                       tag:310
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
            [self updateTableAry:frindsAry];
        }
        else if([response isEqualToString:@"获取好友请求失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
    }
    else if (result.tag == 100)
    {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"添加成功"]) {
            NSLog(@"添加成功");
            //刷新
            [self getAskFriends];
            
            [Common alert4error:@"添加成功" tag:0 delegate:nil];
        }
        else if([response isEqualToString:@"添加失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
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
