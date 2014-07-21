//
//  MusicPlayAnimationView.m
//  GuessGame
//
//  Created by wanglipeng on 13-12-30.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#import "VoicePlayAnimationView.h"
#import "AudioPlayer.h"
#import "SDWebImageDownloader.h"
#import "ResoucesDownloader.h"

@implementation VoicePlayAnimationView

- (void)dealloc
{
    if (_downloader) {
        [_downloader cancel];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioPlayerFinished" object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myAudioPlayerPlaying:) name:@"AudioPlayerFinished" object:nil];

        contentView = [[UIView alloc] init];
        contentView.frame = [Common getMidFrameFromBaseFrame:self.bounds];
        [self addSubview:contentView];

        UIImageView *imageView = [Common initImageName:@"square_voice.png" onView:contentView frame:contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        _musicBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        _musicBtn.frame = contentView.bounds;
        [_musicBtn setImage:[UIImage imageNamed:@"head_voice_start.png"] forState:UIControlStateNormal];
        float offset = _musicBtn.bounds.size.width * 0.44;
        [_musicBtn setImageEdgeInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
        [contentView addSubview:_musicBtn];
        [_musicBtn addTarget:self action:@selector(musicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //_musicBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        _musicBtn.enabled = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    contentView.frame = [Common getMidFrameFromBaseFrame:self.bounds];
    _musicBtn.frame = contentView.bounds;
    float offset = _musicBtn.bounds.size.width * 0.44;
    [_musicBtn setImageEdgeInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
}

- (void)setAudioFileName:(NSString *)voiceName
{
    //    NSString *_path=[[NSBundle mainBundle] pathForResource:@"goldup" ofType:@"mp3"];
    //    NSURL *url=[NSURL fileURLWithPath:_path];
    //    NSData *voiceData = [NSData dataWithContentsOfURL:url];
    
    //voiceName = @"fc0251ecd882dc73181e28486a873ef48de21fb1.aac";
    
    _downloader = [SDWebImageDownloader downloaderWithURL:[Common getUrlWithImageName:voiceName] delegate:self];
    
    //    ResoucesDownloader *downloader = [[ResoucesDownloader alloc] init];
    //    downloader.delegate = self;
    //    [downloader downloadFile:voiceName];
}

- (void)imageDownloaderDidFinish:(SDWebImageDownloader *)downloader
{
    [self setAudioData:downloader.imageData];
}

//- (void)downloadFinish:(NSData *)data
//{
//    [_voiceView setAudioData:data];
//}

- (void)setAudioData:(NSData *)data
{
    _musicBtn.enabled = YES;

    self.fileData = data;
    
    //[[AudioPlayer SharedInstance] updateAudioData:data];
}

- (void)playStart
{
    [[AudioPlayer SharedInstance] updateAudioData:self.fileData];

    [[AudioPlayer SharedInstance] setAudioPlay:YES];

    [self setAnimation:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myAudioPlayerPlaying:) name:@"AudioPlayerFinished" object:nil];
}

- (void)playStop
{
    [[AudioPlayer SharedInstance] setAudioPlay:NO];
    
    [self setAnimation:NO];
}

- (void)setAnimation:(BOOL)start
{
    _isPlaying = start;
    if (_isPlaying) {
        [_musicBtn setImage:[UIImage imageNamed:@"head_voice_stop.png"] forState:UIControlStateNormal];

        self.times = 0;

        [super startAnimation];
    }
    else
    {
        [_musicBtn setImage:[UIImage imageNamed:@"head_voice_start.png"] forState:UIControlStateNormal];

        [super stopAnimation];
    }
}

- (void)animationUpdate
{
    //self.times++;
}

//music

- (void)myAudioPlayerPlaying:(NSNotification *)notification
{
    NSNumber *info = notification.object;
    BOOL play = [info boolValue];
    
    [self setAnimation:play];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioPlayerFinished" object:nil];
}

- (void)musicBtnAction:(id)sender
{
    if (_isPlaying) {
        [self playStop];
    }
    else
    {
        [self playStart];
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
