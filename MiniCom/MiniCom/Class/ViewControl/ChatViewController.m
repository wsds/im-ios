//
//  ChatViewController.m
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ChatViewController.h"
#import "GroupManagerViewController.h"
#import "MyInfoViewController.h"
#import "BaseKeyBoardContrlView.h"
#import "UserInfoViewController.h"
#import "ChoosePhotoViewController.h"
#import "RecordVoiceViewController.h"

#import "Header.h"

#import "NavView.h"
#import "ChatTableViewCell.h"

#import "DBHelper.h"
#import "MyHttpRequest.h"
#import "AccountManager.h"
#import "MyNetManager.h"

#import "AccountData.h"
#import "GroupData.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"

#import "JXEmoji.h"

#define TableRow 6
#define AnimationDur 0.3

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SessionEvent_MessageNotification object:nil];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatView) name:SessionEvent_MessageNotification object:nil];

        
        _chatAry = [[NSMutableArray alloc] init];
        _memberAry = [[NSMutableArray alloc] init];
        
        //_friendAccount = [[AccountData alloc] init];
        //_myAccount = [[AccountData alloc] init];
        self.myAccount = [AccountManager SharedInstance].userInfoData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bg
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];

    //
    [self loadChatView];
    
    [self loadInputView];
    
    _messageConent=[[JXEmoji alloc]initWithFrame:CGRectMake(0, 0, JXCELL_W, JXCELL_H)];
    _messageConent.backgroundColor = [UIColor clearColor];
    _messageConent.userInteractionEnabled = NO;
    _messageConent.numberOfLines = 0;
    _messageConent.lineBreakMode = UILineBreakModeWordWrap;
    _messageConent.font = [UIFont systemFontOfSize:15];
    //_messageConent.offset = -12;
    
    //nav
    _navView = [[GroupNavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]];
    [self.view addSubview:_navView];
    _navView.delegate = self;
}

- (void)loadChatView
{
    CGRect frame = [Common RectMakex:0 y:0.1 w:1.0 h:0.8 onSuperBounds:self.view.bounds];
    _chatTableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:_chatTableView];
    _chatTableView.backgroundColor = [UIColor clearColor];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    
    _chatTableView.hidden = YES;
}

- (void)loadMediaInput
{
    //mediaInput
    _mediaInputView = [[UIView alloc] init];
    _mediaInputView.frame = [Common RectMakex:-1.0 y:0.9 w:1.0 h:0.1 onSuperBounds:self.view.bounds];
    [self.view addSubview:_mediaInputView];
    
    UIImageView *inputBg = [Common initImageName:@"button_background_click.png" onView:_mediaInputView frame:_mediaInputView.bounds];
    
    //media
    UIView *mediaContrlView = [[UIView alloc] initWithFrame:[Common RectMakex:0.0 y:0.02 w:0.85 h:0.96 onSuperBounds:_mediaInputView.bounds]];
    [_mediaInputView addSubview:mediaContrlView];
    
    NSArray *nameAry = @[@"表情", @"图片", @"语音"];
    NSArray *imageNameAry = @[@"chat_emoji_normal.png", @"release_pic.png", @"chat_voice_normal.png"];
    
    float everyW = mediaContrlView.bounds.size.width / [nameAry count];
    float everyH = mediaContrlView.bounds.size.height;
    
    float hhh = 0.7;
    float xOffset = 20.0;
    float yOffset = 5.0;
    float imgwh = everyH * hhh;
    
    for (int i=0; i<[nameAry count]; i++) {
        NSString *name = [nameAry objectAtIndex:i];
        NSString *image = [imageNameAry objectAtIndex:i];
        CGRect btnFrame1 = CGRectMake(everyW * i + xOffset, 0, imgwh, imgwh);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnFrame1;
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height + yOffset, -xOffset, -everyH * (0.85 - hhh) - yOffset, -xOffset)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
        [btn addTarget:self action:@selector(contrlBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [mediaContrlView addSubview:btn];
    }

    //right btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = [Common RectMakex:0.85 y:0.2 w:0.15 h:0.6 onSuperBounds:_mediaInputView.bounds];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    [btn setImage:[UIImage imageNamed:@"chat_more.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(inputMediaNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_mediaInputView addSubview:btn];
}

- (void)loadTextInput
{
    _inputView = [[BaseKeyBoardContrlView alloc] init];
    _inputView.frame = [Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:self.view.bounds];
    [self.view addSubview:_inputView];
    
    UIImageView *inputBg = [Common initImageName:@"button_background_click.png" onView:_inputView frame:_inputView.bounds];
    
    _textView = [[UITextView alloc] initWithFrame:[Common RectMakex:0.15 y:0.1 w:0.7 h:0.8 onSuperBounds:_inputView.bounds]];
    _textView.backgroundColor = [UIColor colorWithRed:0.44 green:0.55 blue:0.66 alpha:1.0];
    _textView.textColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    [_inputView addSubview:_textView];
    [_textView becomeFirstResponder];
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lbtn.frame = [Common RectMakex:0.0 y:0.2 w:0.15 h:0.6 onSuperBounds:_inputView.bounds];
    lbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    [lbtn setImage:[UIImage imageNamed:@"chat_more.png"] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(inputNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:lbtn];

    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rbtn.frame = [Common RectMakex:0.85 y:0.2 w:0.15 h:0.6 onSuperBounds:_inputView.bounds];
    rbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [rbtn setImage:[UIImage imageNamed:@"chat_send.png"] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:rbtn];
}

- (void)loadInputView
{
    //mediaInput
    [self loadMediaInput];

    //textInput
    [self loadTextInput];
    
    _faceView = [[EmojiView alloc]initWithFrame:CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216)];
    [self.view addSubview:_faceView];
    _faceView.backgroundColor = [UIColor lightGrayColor];
    _faceView.delegate = _textView;
    _faceView.hidden = YES;
}

- (void)inputMediaNavBtnAction
{
    _inputView.hidden = NO;
    
    CGRect mediaFrame = CGRectMake(- self.view.bounds.size.width,
                                   _mediaInputView.frame.origin.y,
                                   _mediaInputView.frame.size.width,
                                   _mediaInputView.frame.size.height);
    CGRect inputFrame = CGRectMake(0.0,
                                   self.view.bounds.size.height - _inputView.frame.size.height,
                                   _inputView.frame.size.width,
                                   _inputView.frame.size.height);
    [UIView animateWithDuration:AnimationDur animations:^{
        _mediaInputView.frame = mediaFrame;
        _inputView.frame = inputFrame;
    } completion:^(BOOL finished) {
        _mediaInputView.hidden = YES;
    }];
}

- (void)inputNavBtnAction
{
    [_textView resignFirstResponder];

    _faceView.hidden =  YES;

    _mediaInputView.hidden = NO;
    
    CGRect mediaFrame = CGRectMake(0.0,
                                   _mediaInputView.frame.origin.y,
                                   _mediaInputView.frame.size.width,
                                   _mediaInputView.frame.size.height);
    CGRect inputFrame = CGRectMake(self.view.bounds.size.width,
                                   self.view.bounds.size.height - _inputView.frame.size.height,
                                   _inputView.frame.size.width,
                                   _inputView.frame.size.height);
    [UIView animateWithDuration:AnimationDur animations:^{
        _mediaInputView.frame = mediaFrame;
        _inputView.frame = inputFrame;
    } completion:^(BOOL finished) {
        _inputView.hidden = YES;
    }];
}

- (void)updateChatView
{
    self.myPhone = [AccountManager SharedInstance].username;

    if ([SendType_Point isEqualToString:self.sendType]) {
        _navView.chatType = self.sendType;
        [_navView updateWithMember:self.friendAccount.nickName
                               Ary:@[self.friendAccount]];
        //已读
        [[DBHelper sharedInstance] updateChatMessesHadReadCurPhone:self.myPhone andFriendPhone:self.friendAccount.phone];
        
        self.chatAry = (NSMutableArray *)[[DBHelper sharedInstance] getChatMessesCurPhone:self.myPhone
                                                                           andFriendPhone:self.friendAccount.phone];
    }
    else if ([SendType_Group isEqualToString:self.sendType]) {
        NSString *groupName = self.groupData.name;
        self.memberAry = self.groupData.members;
        _navView.chatType = self.sendType;
        [_navView updateWithMember:groupName Ary:(NSArray *) self.memberAry];
        //已读
        [[DBHelper sharedInstance] updateChatMessesHadReadCurGid:self.groupData.gid];

        self.chatAry = (NSMutableArray *)[[DBHelper sharedInstance] getChatMessesByGid:self.groupData.gid];

    }
    else if ([SendType_TempGroup isEqualToString:self.sendType]) {
        
    }
    else
    {
        
    }

    NSLog(@"chatAry==%@", self.chatAry);
    [_chatTableView reloadData];

    if ([self.chatAry count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatAry count] - 1 inSection:0];
        [_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (void)sendBtnAction
{
    NSLog(@"send==%@", _textView.text);
    if ([_textView.text length] > 0) {
        [self sendContentType:ContentType_Text content:_textView.text];
        _textView.text = @"";
    }
    else
    {
        return;
    }
}

- (void)sendContentType:(NSString *)contentType content:content
{
    NSString *phonetoAryString = @"";
    NSString *gid = @"";
    NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
    if ([self.sendType isEqualToString:@"point"]) {
        [phoneAry addObject:self.friendAccount.phone];
    }
    else if ([self.sendType isEqualToString:@"group"])
    {
        for (int i=0; i<[self.groupData.members count]; i++) {
            AccountData *account = [self.groupData.members objectAtIndex:i];
            [phoneAry addObject:account.phone];
        }
        gid = self.groupData.gid;
    }
    phonetoAryString = [phoneAry JSONString];
    
    NSDictionary *messageDic = @{@"contentType": contentType, @"content": content};
    NSString *messageDicStr = [messageDic JSONString];
    
    //save
    ChatMessData *data = [[ChatMessData alloc] init];
    data.contentType = contentType;
    data.sendType = self.sendType;
    data.phone = self.myPhone;
    if ([self.sendType isEqualToString:@"point"]) {
        data.phoneToOrFrom = self.friendAccount.phone;
    }
    data.content = content;
    data.time = [Common stringFromDate:[NSDate date]];
    data.isRead = 1;
    data.isSend = 1;
    data.gid = gid;
    
    [[DBHelper sharedInstance] insertChatMess:data];
    
    //update view
    [self updateChatView];
    
    //send
    NSDictionary *dic_params = @{@"phoneto":phonetoAryString,
                                 @"gid":gid,
                                 @"sendType":self.sendType,
                                 @"message":messageDicStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_message_send
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

- (void)isSuccessEquals:(RequestResult *)result
{
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"发送成功"]) {
            NSLog(@"发送成功");
            NSString *time = [dic valueForKey:@"time"];
            NSLog(@"time==%@", time);
            //更新 数据
        }
        else if([response isEqualToString:@"发送失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.chatAry count] > 0) {
        _chatTableView.hidden = NO;
    }
    return [self.chatAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = self.view.bounds.size.height / TableRow;
    
    ChatMessData *data = [self.chatAry objectAtIndex:indexPath.row];
    if ([data.contentType isEqualToString:ContentType_Text]) {
        _messageConent.frame = CGRectMake(0, 0, JXCELL_W, JXCELL_H);
        _messageConent.text   = data.content;
        float newheight =_messageConent.frame.size.height;
        NSLog(@"height IndexPath_%d,h=%f,content=%@",indexPath.row,newheight,_messageConent.text);
        if(newheight > height)
        {
            height = newheight + 80.0;
        }
    }
    return height;
}

//- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height / 5);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = self.view.bounds.size.height / TableRow ;
    
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    static NSString *flag = @"chats";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        //[cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width,  height)];
    }
    ChatMessData *data = [self.chatAry objectAtIndex:indexPath.row];
    //
    if ([data.contentType isEqualToString:ContentType_Text]) {
        _messageConent.frame = CGRectMake(0, 0, JXCELL_W, JXCELL_H);
        _messageConent.text   = data.content;
        float newheight =_messageConent.frame.size.height;
        NSLog(@"cell IndexPath_%d,h=%f,content=%@",indexPath.row,newheight,_messageConent.text);
        if(newheight > height)
        {
            height = newheight + 80.0;
        }
    }
    [cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width,  height)];

    //
    cell.mineData = self.myAccount;
    cell.friendData = [[DBHelper sharedInstance] getAccountByPhone:data.phoneToOrFrom];;
    cell.delegate = self;
    [cell setCellWithData:data];
    

    return cell;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
    
    _faceView.hidden =  YES;
    _inputView.frame = CGRectMake(0, kScreen_Height - _inputView.bounds.size.height, _inputView.bounds.size.width, _inputView.bounds.size.height);
}

- (void)showUserInfo:(AccountData *)account
{
    if ([account.phone isEqualToString:self.myAccount.phone]) {
        MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] init];
        [self presentViewController:myInfoVC animated:YES completion:nil];
    }
    else
    {
        UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
        userVC.account = account;
        [self presentViewController:userVC animated:YES completion:nil];
    }
}

#pragma mark input

- (void)contrlBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag==%d", btn.tag);
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"表情");
            _faceView.hidden =  NO;
            CGRect frame = CGRectMake(0,
                                      _inputView.frame.origin.y - _faceView.bounds.size.height,
                                      _inputView.frame.size.width,
                                      _inputView.frame.size.height);
            _mediaInputView.hidden = YES;
            _inputView.hidden = NO;
            _inputView.frame = frame;
        }
            break;
        case 1:
        {
            NSLog(@"图片");
            ChoosePhotoViewController *choosePhotoVC = [[ChoosePhotoViewController alloc] init];
            choosePhotoVC.delegate = self;
            [self presentViewController:choosePhotoVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            NSLog(@"语音");
            RecordVoiceViewController *recordVC = [[RecordVoiceViewController alloc] init];
            recordVC.delegate = self;
            [self presentViewController:recordVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)choosePhotoViewImage:(UIImage *)image
{
    NSLog(@"choosePhotoViewImage");
    NSData *data = [Common scaleAndTransImage:image];
    
    NSString *imageFileName = [Common getFileNameResouceData:data type:@"jpg"];
    
    //cache
    NSString *key = [[Common getUrlWithImageName:imageFileName] absoluteString];
    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
    
    //upload image
    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:imageFileName];
    
    //send mess
    [self sendContentType:ContentType_Image content:imageFileName];
}

- (void)recordCtrViewDone:(NSData *)data
{
    NSLog(@"recordCtrViewDone");
    NSString *voiceFileName = [Common getFileNameResouceData:data type:@"aac"];
    
    //upload voice
    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:voiceFileName];
    
    //send mess
    [self sendContentType:ContentType_Voice content:voiceFileName];
}

#pragma mark nav callback

- (void)navBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_MessageNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)memberAction
{
    if ([SendType_Point isEqualToString:self.sendType]) {
        [self showUserInfo:self.friendAccount];
    }
    else
    {
        GroupDetailView *detail = [[GroupDetailView alloc] initWithFrame:self.view.bounds];
        detail.delegate = self;
        [self.view addSubview:detail];
        [detail updateWithMember:self.groupData.name Ary:(NSArray *) self.memberAry];
    }
}

#pragma mark groupdetail alert callback

- (void)selectMember:(AccountData *)account
{
    [self showUserInfo:account];
}

- (void)memberManagerAction
{
    GroupManagerViewController *groupManagerVC = [[GroupManagerViewController alloc] init];
    groupManagerVC.groupData = self.groupData;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupManagerVC];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark chatCell callback
- (void)selectChatMember:(AccountData *)account
{
    [self showUserInfo:account];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    _faceView.hidden =  YES;

    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(float)height withDuration:(float)dur
{
    NSLog(@"height==%f", height);
    CGRect frame = CGRectMake(0, kScreen_Height - height - _inputView.bounds.size.height, kScreen_Width, _inputView.bounds.size.height);
    [UIView animateWithDuration:dur
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _inputView.frame = frame;
                     } completion:^(BOOL finished) {
                         float hhh = _inputView.frame.origin.y - _chatTableView.frame.origin.y;
                         CGRect chatFrame = CGRectMake(_chatTableView.frame.origin.x, _chatTableView.frame.origin.y, _chatTableView.bounds.size.width, hhh);
                         _chatTableView.frame = chatFrame;
                     }];
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
