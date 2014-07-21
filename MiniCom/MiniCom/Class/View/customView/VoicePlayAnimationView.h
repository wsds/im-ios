//
//  MusicPlayAnimationView.h
//  GuessGame
//
//  Created by wanglipeng on 13-12-30.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#import "BaseAnimationView.h"
#import "MyButton.h"
@class SDWebImageDownloader;

@interface VoicePlayAnimationView : BaseAnimationView
{
    UIView *contentView;
    
    MyButton *_musicBtn;
    
    BOOL _isPlaying;
    
    SDWebImageDownloader *_downloader;
}

@property(nonatomic, retain) NSData *fileData;

- (void)setAudioFileName:(NSString *)fileName;

- (void)setAudioData:(NSData *)data;

- (void)playStart;

- (void)playStop;

@end
