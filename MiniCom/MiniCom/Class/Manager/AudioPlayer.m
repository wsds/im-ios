//
//  AudioPlayer.m
//  GuessGame
//
//  Created by wanglipeng on 13-10-21.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

static AudioPlayer *sharedSingleton = nil;

- (void)dealloc
{
    [self clearAudioPlayer];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)clearAudioPlayer
{
    if (self.audioPlayer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        _audioPlayer = nil;
    }
}

+ (AudioPlayer *) SharedInstance
{
    @synchronized(self){
        if(sharedSingleton == nil){
            sharedSingleton = [[AudioPlayer alloc] init];
        }
    }
    return sharedSingleton;
}

- (void)updateAudioData:(NSData *)data
{
    [self clearAudioPlayer];

    NSError *error;
    if(self.audioPlayer==nil)
    {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
        self.audioPlayer.delegate = self;
        if(error)
        {
            NSLog(@"game audioPlayer error==%@",[error description]);
        }
    }
}

- (void)setAudioPlay:(BOOL)play
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayerFinished" object:[NSNumber numberWithBool:NO]];
    if (play)
    {
        [self.audioPlayer play];
    }
    else{
        [self.audioPlayer stop];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayerFinished" object:[NSNumber numberWithBool:play]];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
    [self setAudioPlay:NO];
}

@end
