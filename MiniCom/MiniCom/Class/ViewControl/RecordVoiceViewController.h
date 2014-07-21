//
//  RecordVoiceView.h
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class VoicePlayAnimationView;

typedef enum {
    E_RecordState_Start         = 0,
    E_RecordState_WillCancel    = 1,
    E_RecordState_Stop          = 2,
}E_RecordState;

@protocol RecordVoiceViewDelegate <NSObject>

- (void)recordCtrViewDone:(NSData *)data;

@end

@interface RecordVoiceViewController : UIViewController
{
    VoicePlayAnimationView *_contentVoiceView;
    
    UIButton *_recordbtn;
    E_RecordState _recordState;
    
    //
    BOOL recording;
    NSTimer *peakTimer;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    
    NSURL *pathURL;
    NSTimeInterval _timeLen;
}

@property (nonatomic, assign) id<RecordVoiceViewDelegate>delegate;

@property (nonatomic, retain) NSData *recordData;

@end
