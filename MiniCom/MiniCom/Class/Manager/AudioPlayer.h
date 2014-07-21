//
//  AudioPlayer.h
//  GuessGame
//
//  Created by wanglipeng on 13-10-21.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>
{
    
}
@property(nonatomic,retain)AVAudioPlayer *audioPlayer;

@property(nonatomic,assign)BOOL canPlay;

+ (AudioPlayer *)SharedInstance;

- (void)updateAudioData:(NSData *)data;

- (void)setAudioPlay:(BOOL)play;

@end
