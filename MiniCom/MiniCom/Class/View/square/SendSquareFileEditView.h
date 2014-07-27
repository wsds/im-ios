//
//  SendSquareFileEditView.h
//  MiniCom
//
//  Created by wlp on 14-7-27.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavView;

@protocol SendSquareFileEditViewDelegate <NSObject>

- (void)editNavBtnAction;

@end

@interface SendSquareFileEditView : UIView
{
    float _offset;
    float _w;
    float _h;
    float _vocieEndX;
    float _imageEndX;
    
    NavView *_nav;
    
    UIScrollView *_contentScrollView;
    
    int _pageSum;
    int _curPage;
}

@property (nonatomic, assign) id <SendSquareFileEditViewDelegate>delegate;

@property(nonatomic, retain) NSMutableArray *imageFileArray;

@property(nonatomic, retain) NSMutableArray *voiceFileArray;

- (void)show:(BOOL)show;

- (void)updateWithVoiceAry:(NSMutableArray *)voices
               andImageAry:(NSMutableArray *)images;

@end
