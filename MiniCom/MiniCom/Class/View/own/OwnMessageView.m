//
//  OwnMessageView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "OwnMessageView.h"
#import "Common.h"
#import "ChatCell.h"
#import "DBHelper.h"
#import "AccountManager.h"

#define ChatTableCellHeight 60.0

@implementation OwnMessageView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SessionEvent_MessageNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatTable) name:SessionEvent_MessageNotification object:nil];
        
        _chatAry = [[NSMutableArray alloc] init];
        
        float wh = 128.0;
        _noChatBg = [[UIImageView alloc] init];
        _noChatBg.image = [UIImage imageNamed:@"not_messages.png"];
        _noChatBg.frame = CGRectMake((self.bounds.size.width - wh) / 2, (self.bounds.size.height - wh) / 2, wh, wh);
        [self addSubview:_noChatBg];
        
        _chatTableView = [[UITableView alloc] init];
        _chatTableView.frame = self.bounds;
        _chatTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        [self addSubview:_chatTableView];
        
        [self updateChatTable];
    }
    return self;
}

- (void)updateChatTable
{
    NSString *phone = [AccountManager SharedInstance].username;
    self.chatAry = [[DBHelper sharedInstance] getLastChatMessAryCurPhone:phone];
    
    [_chatTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.chatAry count] > 0) {
        _noChatBg.hidden = YES;
    }
    else
    {
        _noChatBg.hidden = NO;
    }
    return [self.chatAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ChatTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"chats";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        [cell setFrame:CGRectMake(0, 0, self.bounds.size.width,  ChatTableCellHeight)];
    }
    ChatMessData *data = [self.chatAry objectAtIndex:indexPath.row];
    AccountData *friend = [[DBHelper sharedInstance] getAccountByPhone:data.phoneToOrFrom];
    int unReadNum = 0;
    if ([data.gid length] > 0) {
        NSLog(@"群组");
        unReadNum = [[DBHelper sharedInstance] getSumUnReadByGid:data.gid];
    }
    else
    {
        NSLog(@"单聊");
        unReadNum = [[DBHelper sharedInstance] getSumUnReadCurPhone:data.phone
                                         andFriendPhone:data.phoneToOrFrom];

    }
    NSLog(@"unReadNum==%d", unReadNum);
    
    cell.friendData = friend;
    [cell setCellWithData:data];
    [cell setUnreadCount:unReadNum];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessData *data = [self.chatAry objectAtIndex:indexPath.row];

    if ([data.gid length] > 0) {
        [self.delegate showChatViewGroup:data.gid];
    }
    else
    {
        AccountData *friend = [[DBHelper sharedInstance] getAccountByPhone:data.phoneToOrFrom];
        [self.delegate showChatViewFriend:friend];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
