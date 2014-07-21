//
//  RecordVoiceView.m
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "RecordVoiceViewController.h"
#import "ChatCacheFileUtil.h"
#import "VoicePlayAnimationView.h"

@implementation RecordVoiceViewController

- (id)init;
{
    self = [super init];
    if (self) {
        // Initialization code
        [Common addImageName:@"square_background.png" onView:self.view frame:kScreen_Frame];
        
        [self loadVoiceView];

        [self loadContrlView];
    }
    return self;
}

- (void)loadVoiceView
{
    _contentVoiceView = [[VoicePlayAnimationView alloc] init];
    _contentVoiceView.frame = [Common RectMakex:0.1 y:0.3 w:0.8 h:0.4 onSuperBounds:self.view.bounds];
    [self.view addSubview:_contentVoiceView];
}

- (void)loadContrlView
{
    float btnOffset = 10;
    
    UIView * contrView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    [self.view addSubview:contrView];
    
    [Common addImageName:@"button_background_click.png" onView:contrView frame:contrView.bounds];
    
    float btnH = contrView.bounds.size.height * 0.9;
    float btnY = (contrView.bounds.size.height - btnH ) / 2;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnOffset / 2, btnY, btnH, btnH);
    [btn setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contrView addSubview:btn];
    
    _recordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordbtn.frame = CGRectMake(btnH + btnOffset, btnY, contrView.bounds.size.width - btnH * 2 - btnOffset * 2 , btnH);
    [_recordbtn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
    [_recordbtn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [_recordbtn addTarget:self action:@selector(recordStop:) forControlEvents:UIControlEventTouchUpInside];
    [_recordbtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [_recordbtn addTarget:self action:@selector(recordWillCancel:) forControlEvents:UIControlEventTouchDragOutside];
    
    [contrView addSubview:_recordbtn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(contrView.bounds.size.width - btnH - btnOffset / 2, btnY, btnH, btnH);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"picandvoice_cancel.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contrView addSubview:btn2];
    
    [self updateRecordState:E_RecordState_Stop];
}

- (void)dismissThis
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelBtnAction
{
    // Drawing code
    [self dismissThis];
}

#pragma mark - 录制语音
- (void)recordStart:(id)sender
{
    NSLog(@"recordStart");
    [self updateRecordState:E_RecordState_Start];
    
    if(recording)
        return;
    
    [_contentVoiceView playStop];
    //[audioPlayer pause];
    recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@_%@.wav",@"MY_USER_ID",[dateFormater stringFromDate:now]];
    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    pathURL = url;
    
    NSError *error;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
    audioRecorder.delegate = self;
    
    peakTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
    
    [audioRecorder prepareToRecord];
    [audioRecorder setMeteringEnabled:YES];
    [audioRecorder peakPowerForChannel:0];
    [audioRecorder record];
}

- (void)updatePeak:(NSTimer*)timer
{
    _timeLen = audioRecorder.currentTime;
    if(_timeLen>=60)
        [self recordStop:nil];
}

- (void)recordStop:(id)sender
{
    // Drawing code
    NSLog(@"recordStop");
    NSLog(@"to save get voice");
    [self updateRecordState:E_RecordState_Stop];
    
    if(!recording)
        return;
    [peakTimer invalidate];
    peakTimer = nil;
    
    _timeLen = audioRecorder.currentTime;
    [audioRecorder stop];
    
    if (_timeLen<1) {
        [Common alert4error:@"录的时间过短" tag:0 delegate:nil];
        return;
    }
    
    NSData *recordData = [NSData dataWithContentsOfFile:pathURL.path];    
    self.recordData = recordData;

    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
    
    recording = NO;
    [self recordPlay:recordData];
}

- (void)recordWillCancel:(id)sender
{
    NSLog(@"recordWillCancel");
    [self updateRecordState:E_RecordState_WillCancel];
}

- (void)recordCancel:(id)sender
{
    // Drawing code
    NSLog(@"recordCancel");
    [self updateRecordState:E_RecordState_Stop];
    
    if(!recording)
        return;
    [audioRecorder stop];
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
}

- (void)updateRecordState:(E_RecordState)state
{
    _recordState = state;

    if (state == E_RecordState_Start) {
        [_recordbtn setTitle:@"正在录音" forState:UIControlStateNormal];
        return;
    }
    if (state == E_RecordState_WillCancel) {
        [_recordbtn setTitle:@"取消录音" forState:UIControlStateNormal];
        return;
    }
    if (state == E_RecordState_Stop) {
        [_recordbtn setTitle:@"开始录音" forState:UIControlStateNormal];
        return;
    }
}

- (void)submitBtnAction
{
    // Drawing code
    if (self.recordData) {
        [self dismissThis];
        
        [self.delegate recordCtrViewDone:self.recordData];
    }
}

#pragma mark play

-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}

//-(void)recordPlay:(JXMessageObject*)msg{
- (void)recordPlay:(NSData *)msg{
    
    [_contentVoiceView setAudioData:msg];

//    NSLog(@"音频文件路径:%@",pathURL.path);
//
//    NSString *fileName = @"voice";
//    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
//    
//    [msg writeToFile:fullPath atomically:YES];
//    
//    //NSString *wavPath = [VoiceConverter amrToWav:fullPath];
//    NSString *wavPath = fullPath;
//    
//    NSError *error=nil;
//    [audioPlayer stop];
//    
//    [self initPlayer];
//    
//    NSData *data = [NSData dataWithContentsOfFile:wavPath];
//    //NSLog(@"data==%@", data);
//    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
//    
//    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:wavPath];
//    if (error) {
//        error=nil;
//    }
//    [audioPlayer setVolume:1];
//    [audioPlayer prepareToPlay];
//    [audioPlayer setDelegate:self];
//    [audioPlayer play];
//    
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audioPlayerDidFinishPlaying");
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
}

//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
