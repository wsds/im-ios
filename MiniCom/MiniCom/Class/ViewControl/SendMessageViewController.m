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
#import "SquareFileData.h"

#import "SendSquareFileScrollView.h"
#import "SendSquareFileEditView.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.messType = @"全部";
        
        _imageFileArray = [[NSMutableArray alloc] init];
        _voiceFileArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bg
    [Common addImageName:@"background3.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    [self loadMessEditView];
    
    [self loadFileEditView];
    
    [self setEditFileViewHide: YES];
}

- (void)loadMessEditView
{
    _messEditView = [[UIView alloc] init];
    _messEditView.frame = self.view.bounds;
    [self.view addSubview:_messEditView];
    
    _messageView = [[UITextView alloc] initWithFrame:[Common RectMakex:0 y:0.04 w:1.0 h:0.3 onSuperBounds:kScreen_Frame]];
    _messageView.backgroundColor = [UIColor clearColor];
    _messageView.textColor = [UIColor whiteColor];
    _messageView.delegate = self;
    [_messEditView addSubview:_messageView];
    [_messageView becomeFirstResponder];
    
    //
    [self loadFileView];
    
    //
    [self loadInputView];
}

- (void)loadFileView
{
    _fileView = [[SendSquareFileScrollView alloc] initWithFrame:[Common RectMakex:0.025 y:0.35 w:0.95 h:0.1 onSuperBounds:kScreen_Frame]];
    _fileView.backgroundColor = [UIColor clearColor];
    _fileView.fileDelegate = self;
    [_messEditView addSubview:_fileView];
}

- (void)loadInputView
{
    _inputView = [[MessageControlView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame] delegate:self];
    _inputView.backgroundColor = [UIColor clearColor];
    [_messEditView addSubview:_inputView];

    _faceView = [[EmojiView alloc]initWithFrame:CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216)];
    [_messEditView addSubview:_faceView];
    _faceView.delegate = _messageView;
    _faceView.hidden = YES;
}

- (void)loadFileEditView
{
    _fileEditView = [[SendSquareFileEditView alloc] initWithFrame:self.view.bounds];
    _fileEditView.delegate = self;
    [self.view addSubview:_fileEditView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_faceView.hidden) {
        [_messageView becomeFirstResponder];
    }
}

- (void)fileBtnAction
{
    if ([self hadImage] || [self hadVoice]) {
        [_messageView resignFirstResponder];
        
        [self setEditFileViewHide: NO];
        
        [_fileEditView updateWithVoiceAry:_voiceFileArray andImageAry:_imageFileArray];
    }
}

- (void)editNavBtnAction
{
    [_messageView becomeFirstResponder];

    [_fileView updateWithVoiceAry:_voiceFileArray andImageAry:_imageFileArray];

    [self setEditFileViewHide: YES];
}

- (void)setEditFileViewHide:(BOOL)hide
{
    _messageView.hidden = !hide;
    [_fileEditView show:!hide];
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

    NSString *voiceFileName = [Common getFileNameResouceData:data type:@"aac"];
    
    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:voiceFileName];
    
    SquareFileData *fileData = [[SquareFileData alloc] init];
    fileData.fileType = ENUM_VOICE;
    fileData.fileName = voiceFileName;
    fileData.fileData = data;
    [_voiceFileArray addObject:fileData];
    
    [_fileView updateWithVoiceAry:_voiceFileArray andImageAry:_imageFileArray];
}

- (void)choosePhotoViewImage:(UIImage *)image
{
    NSData *data = [Common scaleAndTransImage:image];
    
    NSString *imageFileName = [Common getFileNameResouceData:data type:@"jpg"];

    [[MyNetManager SharedInstance] reqestUploadResouceData:data name:imageFileName];
    
    SquareFileData *fileData = [[SquareFileData alloc] init];
    fileData.fileType = ENUM_IMAGE;
    fileData.fileName = imageFileName;
    fileData.fileData = data;
    [_imageFileArray addObject:fileData];
    
    [_fileView updateWithVoiceAry:_voiceFileArray andImageAry:_imageFileArray];
}

- (NSString *)getContentType
{
    BOOL text = [self hadText];
    BOOL image = [self hadImage];
    BOOL voice = [self hadVoice];
    if (text && image && voice) {
        return @"vit";
    }
    else
    {
        if (text && image)
            return @"textandimage";
        
        if (text && voice)
            return @"textandvoice";
        
        if (voice && image)
            return @"voiceandimage";
        
        if (text)
            return @"text";
        
        if (image)
            return @"image";
        
        if (voice)
            return @"voice";
    }
    return @"vit";
}

- (BOOL)hadText
{
    if ([_messageView.text length] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hadImage
{
    if ([self.imageFileArray count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hadVoice
{
    if ([self.voiceFileArray count] > 0) {
        return YES;
    }
    return NO;
}

- (void)sendToSquare
{
    if ([self hadText] > 0 || [self hadImage] > 0 || [self hadVoice]) {
        NSMutableArray *contentAry = [[NSMutableArray alloc] init];
        if ([_messageView.text length] > 0) {
            NSDictionary *contentDic = @{@"type": @"text", @"details": _messageView.text};
            [contentAry addObject:contentDic];
        }
        if ([self.imageFileArray count] > 0) {
            for (int i=0; i<[self.imageFileArray count]; i++) {
                SquareFileData *data = [self.imageFileArray objectAtIndex:i];
                NSDictionary *contentDic = @{@"type": @"image", @"details": data.fileName};
                [contentAry addObject:contentDic];
            }
        }
        if ([self.voiceFileArray count] > 0) {
            for (int i=0; i<[self.imageFileArray count]; i++) {
                SquareFileData *data = [self.imageFileArray objectAtIndex:i];
                NSDictionary *contentDic = @{@"type": @"voice", @"details": data.fileName};
                [contentAry addObject:contentDic];
            }
        }
        
        //messagetype @"精华" @"活动"、、
//        NSArray *messageTypeAry = @[];
//        NSString *messageTypeStr = [messageTypeAry JSONString];

        NSString *messageTypeStr = self.messType;
        NSString *contentType = [self getContentType];
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
