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
@class SendSquareFileScrollView;
@class SendSquareFileEditView;

@interface SendMessageViewController : UIViewController<UIImagePickerControllerDelegate, ChoosePhotoViewDelegate, RecordVoiceViewDelegate>
{
    UIView *_messEditView;
    
    UITextView *_messageView;
    SendSquareFileScrollView *_fileView;
    MessageControlView *_inputView;
    
    RecordVoiceViewController *_recordVC;
    ChoosePhotoViewController *_choosePhotoVC;
    EmojiView* _faceView;
    
    //
    SendSquareFileEditView *_fileEditView;
}

@property(nonatomic, retain) NSString *messType;

@property(nonatomic, retain) NSMutableArray *imageFileArray;

@property(nonatomic, retain) NSMutableArray *voiceFileArray;

@end
