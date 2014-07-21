//
//  SendMessageViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SendMessageViewController.h"
#import "Common.h"
#import "NavView.h"
#import "MyHttpRequest.h"
#import "MyNetManager.h"
#import "AccountManager.h"
#import "AccountData.h"


@interface SendMessageViewController ()

@end

@implementation SendMessageViewController

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
    
    //bg
    [Common addImageName:@"background3.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
//    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
//                                            title:@"发消息"
//                                         delegate:self
//                                              sel:@selector(navAction)];
//    [self.view addSubview:nav];
    
    _messageView = [[UITextView alloc] initWithFrame:[Common RectMakex:0 y:0.04 w:1.0 h:0.3 onSuperBounds:kScreen_Frame]];
    _messageView.backgroundColor = [UIColor clearColor];
    _messageView.textColor = [UIColor whiteColor];
    _messageView.delegate = self;
    [self.view addSubview:_messageView];
    [_messageView becomeFirstResponder];

    //
    [self loadFileView];
    
    //
    [self loadInputView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_faceView.hidden) {
        [_messageView becomeFirstResponder];
    }
}

- (void)loadFileView
{
    _fileView = [[UIView alloc] initWithFrame:[Common RectMakex:0.05 y:0.35 w:0.9 h:0.1 onSuperBounds:kScreen_Frame]];
    //_fileView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_fileView];
    
    _voiceImageView = [Common initImageName:@"selected_voice.png" onView:_fileView frame:CGRectMake(0, 0, _fileView.bounds.size.height, _fileView.bounds.size.height)];
    _voiceImageView.hidden = YES;

    _photoImageView = [Common initImageName:@"" onView:_fileView frame:CGRectMake(_fileView.bounds.size.width - _fileView.bounds.size.height, 0, _fileView.bounds.size.height, _fileView.bounds.size.height)];
}

- (void)loadInputView
{
    _inputView = [[MessageControlView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame] delegate:self];
    _inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_inputView];

    _faceView = [[EmojiView alloc]initWithFrame:CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216)];
    [self.view addSubview:_faceView];
    _faceView.delegate = _messageView;
    _faceView.hidden = YES;
}

- (void)setFaceViewHide:(BOOL)hide
{
    _inputView.canHide = hide;

    _faceView.hidden = hide;
    if (hide) {
        [_messageView becomeFirstResponder];
    }
    else
    {
        [_messageView resignFirstResponder];
        _inputView.frame = CGRectMake(_inputView.frame.origin.x, _faceView.frame.origin.y - _inputView.frame.size.height, _inputView.frame.size.width, _inputView.frame.size.height);
    }
}

- (void)messCtrViewClickedButtonAtIndex:(E_MessState)tag
{
    NSLog(@"tag==%d", (int)tag);
    switch (tag) {
        case E_MessState_Cancel:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case E_MessState_Voice:
            _recordVC = [[RecordVoiceViewController alloc] init];
            _recordVC.delegate = self;
            [self presentViewController:_recordVC animated:YES completion:nil];
            break;
        case E_MessState_Emoji:
            [self setFaceViewHide:!_faceView.hidden];

            break;
        case E_MessState_Image:
            _choosePhotoVC = [[ChoosePhotoViewController alloc] init];
            _choosePhotoVC.delegate = self;
            [self presentViewController:_choosePhotoVC animated:YES completion:nil];
            break;
        case E_MessState_Done:
            NSLog(@"to send");
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self sendToSquare];
            break;
        default:
            break;
    }
}

- (void)recordCtrViewDone:(NSData *)data
{
    NSLog(@"recordCtrViewDone");
    if (data) {
        _voiceImageView.hidden = NO;
    }
    else
    {
        _voiceImageView.hidden = YES;
    }
    
    self.voiceFileName = [Common getFileNameResouceData:data type:@"aac"];
    
    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:self.voiceFileName];
}

- (void)choosePhotoViewImage:(UIImage *)image
{
    [self setImageViewFrame:image];

    //
    NSData *data = [Common scaleAndTransImage:image];
    
    self.imageFileName = [Common getFileNameResouceData:data type:@"jpg"];

    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:self.imageFileName];
}

- (void)setImageViewFrame:(UIImage *)image
{
    float www = _photoImageView.bounds.size.width;
    float hhh = _photoImageView.bounds.size.height;
    
    float vvv = image.size.width / image.size.height;
    if (vvv > 1.0) {
        hhh = www / vvv;
    }
    else
    {
        www = hhh * vvv;
    }
    _photoImageView.frame = CGRectMake(_photoImageView.frame.origin.x + (_photoImageView.frame.size.width - www), _photoImageView.frame.origin.y + (_photoImageView.frame.size.height - hhh) / 2, www, hhh);
    
    _photoImageView.frame = CGRectMake(_fileView.bounds.size.width - www, 0, www, _photoImageView.bounds.size.height);
    _photoImageView.image = image;
    
}

- (void)sendToSquare
{
    if ([_messageView.text length] > 0 || [self.imageFileName length] > 0 || [self.voiceFileName length] > 0) {
        NSMutableArray *contentAry = [[NSMutableArray alloc] init];
        NSDictionary *contentDic1 = nil;
        NSDictionary *contentDic2 = nil;
        NSDictionary *contentDic3 = nil;
        if ([_messageView.text length] > 0) {
            contentDic1 = @{@"type": @"text", @"details": _messageView.text};
            [contentAry addObject:contentDic1];
        }
        if ([self.imageFileName length] > 0) {
            contentDic2 = @{@"type": @"image", @"details": self.imageFileName};
            [contentAry addObject:contentDic2];
        }
        if ([self.voiceFileName length] > 0) {
            contentDic3 = @{@"type": @"voice", @"details": self.voiceFileName};
            [contentAry addObject:contentDic3];
        }
        
        //messagetype @"精华" @"活动"、、
        NSArray *messageTypeAry = @[];
        NSString *messageTypeStr = [messageTypeAry JSONString];
        NSString *contentType = @"vit";
        NSDictionary *messageDic = @{@"messageType": messageTypeStr,
                                     @"contentType": contentType,
                                     @"content": contentAry};
        NSString *messageDicStr = [messageDic JSONString];
        
        //send
        NSString *head = [AccountManager SharedInstance].userInfoData.head;
        NSString *nickName = [AccountManager SharedInstance].userInfoData.nickName;
        NSString *cover = @"";
        NSString *gid = @"98";
        
        NSDictionary *dic_params = @{@"head":head,
                                     @"nickName":nickName,
                                     @"gid":gid,
                                     @"cover":cover,
                                     @"message":messageDicStr};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_square_sendsquaremessage
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
        NSLog(@"no mess to send");
    }
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSDictionary *dic = result.myData;
    if (result.tag == 1) {
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"发布广播成功"]) {
            NSLog(@"发布广播成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if([response isEqualToString:@"发布广播失败"])
        {
            NSLog(@"发布广播 失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
        return;
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
