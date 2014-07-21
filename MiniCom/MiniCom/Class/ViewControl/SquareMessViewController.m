//
//  SquareMessViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareMessViewController.h"
#import "NavView.h"
#import "Header.h"
#import "SquareInfoView.h"
#import "SquareContentData.h"
#import "UIImageView+WebCache.h"
#import "VoicePlayAnimationView.h"
#import "MyNetManager.h"
#import "MyHttpRequest.h"
#import "AccountManager.h"
#import "JXEmoji.h"

@interface SquareMessViewController ()

@end

@implementation SquareMessViewController

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
    
    _yOffset = 5.0;
    
    //bg
    [Common addImageName:@"background3.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //contentview
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = [Common RectMakex:0.02 y:0.1 w:0.96 h:0.8 onSuperBounds:kScreen_Frame];
    _scrollv.showsHorizontalScrollIndicator = NO;
    _scrollv.backgroundColor = [UIColor clearColor];
    //_scrollv.pagingEnabled = YES;
    _scrollv.delegate = self;
    [self.view  addSubview:_scrollv];
    
    [self updateContentView:self.squareData];
    
    //
    CGRect infoFrame = [Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame];
    _infoView = [[SquareInfoView alloc] initWithFrame:infoFrame];
    _infoView.delegate = self;
    [self.view addSubview:_infoView];
    
    BOOL hadPraise = [AccountManager getCurUserPraiseYorN:self.squareData.praiseusers];
    _infoView.hadPraise = hadPraise;
    [_infoView updateTime:self.squareData.time
                    local:self.squareData.cover
                noteCount:100
                niceCount:(int)[self.squareData.praiseusers count]
                markCount:2];
    
    //
    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                            title:self.squareData.nickName
                                         delegate:self
                                              sel:@selector(navAction)];
    [self.view addSubview:nav];
}

- (void)updateContentView:(SquareMessData *)data
{
    NSLog(@"content count==%d", [data.content count]);
    for (int i=0; i<[data.content count]; i++) {
        SquareContentData *contentData = [data.content objectAtIndex:i];
        if ([contentData.type isEqualToString:@"text"]) {
            [self addTextView:contentData.details];
        }
        else if ([contentData.type isEqualToString:@"image"]) {
            [self addImageView:contentData.details];
        }
        else if ([contentData.type isEqualToString:@"voice"]) {
            [self addVoiceView:contentData.details];
        }
    }
    
    _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, _cur_y + _yOffset);
}

- (void)addTextView:(NSString *)text
{
//    UIFont *font = [UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_L]];
//    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(_scrollv.bounds.size.width, 2000.0f) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    UILabel *lb = [[UILabel alloc] init];
//    lb.numberOfLines = 0;
//    lb.font = font;
//    lb.text = text;
//    lb.lineBreakMode = NSLineBreakByWordWrapping;
//    lb.textColor = [UIColor whiteColor];
//    lb.backgroundColor = [UIColor clearColor];
//    [_scrollv addSubview:lb];
    
//    _cur_y += _yOffset;
//    CGRect frame = CGRectMake(0, _cur_y, size.width, size.height);
//    lb.frame = frame;
//    _cur_y += frame.size.height;
//    _cur_y += _yOffset;
    
    _cur_y += _yOffset;
    CGRect frame = CGRectMake(0, _cur_y, _scrollv.bounds.size.width, 20);
    
    JXEmoji *_messageConent=[[JXEmoji alloc]initWithFrame:frame];
    _messageConent.backgroundColor = [UIColor clearColor];
    _messageConent.textColor = [UIColor whiteColor];
    _messageConent.userInteractionEnabled = NO;
    _messageConent.numberOfLines = 0;
    _messageConent.lineBreakMode = NSLineBreakByWordWrapping;
    _messageConent.font = [UIFont systemFontOfSize:BaseFontSize_L];
    _messageConent.text = text;
    [_scrollv addSubview:_messageConent];
    
    frame = _messageConent.frame;
    _cur_y += frame.size.height;
    _cur_y += _yOffset;
}

- (void)addImageView:(NSString *)imageName
{
    CGRect frame = CGRectMake(0, _cur_y, _scrollv.frame.size.width, _scrollv.frame.size.width);
    self.tempImageView = [Common initImageName:@"" onView:_scrollv frame:frame];
    __block float www = self.tempImageView.bounds.size.width;
    __block float hhh = self.tempImageView.bounds.size.height;
    
    [self.tempImageView setImageWithURL:[Common getUrlWithImageName:imageName] success:^(UIImage *image) {
        float vvv = image.size.width / image.size.height;
        if (vvv > 1.0) {
            hhh = www / vvv;
        }
        else
        {
            www = hhh * vvv;
        }
        self.tempImageView.frame = CGRectMake((_scrollv.frame.size.width - www) / 2, _cur_y, www, hhh);
        _cur_y += self.tempImageView.frame.size.height;
        _cur_y += _yOffset;

        _scrollv.contentSize = CGSizeMake(_scrollv.bounds.size.width, _cur_y + _yOffset);
    } failure:^(NSError *error) {
        
    }];
}

- (void)addVoiceView:(NSString *)voiceName
{
    NSLog(@"voiceName==%@", voiceName);
    
    _cur_y += _yOffset;
    CGRect frame = CGRectMake(0, _cur_y, _scrollv.frame.size.width, _scrollv.frame.size.width / 1.5);
    _cur_y += frame.size.height;
    _cur_y += _yOffset;
    
    //VoicePlayAnimationView *voiceView = [[VoicePlayAnimationView alloc] initWithFrame:frame];
    VoicePlayAnimationView *voiceView = [[VoicePlayAnimationView alloc] init];
    [voiceView setFrame:frame];
    [voiceView setAudioFileName:voiceName];
    [_scrollv addSubview:voiceView];
}

#pragma mark 

- (void)addSquarePraise:(BOOL)operation
{
    [self addSquarePraiseNickName:self.squareData.nickName
                              gid:self.squareData.gid
                             gmid:self.squareData.gmid
                        operation:operation];
}

- (void)addSquarePraiseNickName:(NSString *)nickName
                            gid:(NSString *)gid
                           gmid:(NSString *)gmid
                      operation:(BOOL)operation
{
    NSString *statusStr = @"false";
    if (operation) {
        statusStr = @"true";
    }
    //                        typical: {phone: "XXX", accessKey: "XXX", nickName: "XXX", gid: "XXX", gmid: "NNN", operation: true || false}

    NSDictionary *dic_params = @{@"nickName":nickName,
                                 @"gid":gid,
                                 @"gmid":gmid,
                                 @"operation":statusStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_square_addsquarepraise
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

- (void)getSquareCommentsGid:(NSString *)gid
                        gmid:(NSString *)gmid
{
    
    NSDictionary *dic_params = @{@"gid":gid,
                                 @"gmid":gmid};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_square_getsquarecomments
                                                    params:dic_params
                                                       tag:2
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
    if (result.tag == 1) {
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"点赞广播成功"]) {
            NSLog(@"点赞广播成功");
        }
        else if([response isEqualToString:@"点赞广播失败"])
        {
            NSLog(@"点赞广播 失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
        return;
    }
    else if (result.tag == 2) {
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取广播评论成功"]) {
            NSLog(@"获取广播评论成功");
        }
        else if([response isEqualToString:@"获取广播评论失败"])
        {
            NSLog(@"获取广播评论 失败");
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"error==%@", error);
        }
        return;
    }
}


- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
