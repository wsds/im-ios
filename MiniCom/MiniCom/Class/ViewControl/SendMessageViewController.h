//
//  SendMessageViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageControlView.h"
#import "RecordVoiceViewController.h"
#import "ChoosePhotoViewController.h"
#import "EmojiView.h"

@interface SendMessageViewController : UIViewController<UIImagePickerControllerDelegate, ChoosePhotoViewDelegate, RecordVoiceViewDelegate>
{
    UITextView *_messageView;
    
    UIView *_fileView;
    UIImageView *_voiceImageView;
    UIImageView *_photoImageView;
    
    MessageControlView *_inputView;
    
    RecordVoiceViewController *_recordVC;
    ChoosePhotoViewController *_choosePhotoVC;
    EmojiView* _faceView;
}

@property(nonatomic, retain) NSString *imageFileName;

@property(nonatomic, retain) NSString *voiceFileName;

@end
