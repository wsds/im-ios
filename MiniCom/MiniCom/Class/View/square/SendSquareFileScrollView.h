//
//  SendSquareFileScrollView.h
//  MiniCom
//
//  Created by wlp on 14-7-27.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendSquareFileViewDelegate <NSObject>

- (void)fileBtnAction;

@end

@interface SendSquareFileScrollView : UIScrollView
{
    float _offset;
    float _wh;
    float _vocieEndX;
    float _imageEndX;
}

@property (nonatomic, assign) id <SendSquareFileViewDelegate>fileDelegate;

- (void)updateWithVoiceAry:(NSMutableArray *)voices
               andImageAry:(NSMutableArray *)images;

@end
