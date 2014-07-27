//
//  SendSquareFileScrollView.m
//  MiniCom
//
//  Created by wlp on 14-7-27.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SendSquareFileScrollView.h"
#import "SquareFileData.h"

@implementation SendSquareFileScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _offset = 5.0;
        _wh = self.bounds.size.height;
        
//        _voiceImageView = [Common initImageName:@"selected_voice.png" onView:_fileView frame:CGRectMake(0, 0, _fileView.bounds.size.height, _fileView.bounds.size.height)];
//        _voiceImageView.hidden = YES;
//        
//        _photoImageView = [Common initImageName:@"" onView:_fileView frame:CGRectMake(_fileView.bounds.size.width - _fileView.bounds.size.height, 0, _fileView.bounds.size.height, _fileView.bounds.size.height)];
        
        UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fileBtn.frame = self.bounds;
        [fileBtn addTarget:self action:@selector(maskBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fileBtn];
    }
    return self;
}

- (void)maskBtnAction
{
    if (self.fileDelegate && [self.fileDelegate respondsToSelector:@selector(fileBtnAction)]) {
        [self.fileDelegate fileBtnAction];
    }
}

- (void)updateWithVoiceAry:(NSMutableArray *)voices
               andImageAry:(NSMutableArray *)images
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _vocieEndX = 0.0;
    _imageEndX = 0.0;
    
    if (voices && [voices count] > 0) {
        for (int i=0; i<[voices count]; i++) {
            float x = (_wh + _offset) * i;
            UIImageView *voiceImageView = [Common initImageName:@"selected_voice.png" onView:self frame:CGRectMake(x, 0, _wh, _wh)];
            [self addSubview:voiceImageView];
            _vocieEndX = x + (_wh + _offset);
        }
    }
    if (images && [images count] > 0) {
        for (int i=0; i<[images count]; i++) {
            SquareFileData *sfiledata = [images objectAtIndex:i];
            UIImage *image = [UIImage imageWithData:sfiledata.fileData];
            float x = _vocieEndX + (_wh + _offset) * i;
            UIImageView *imageView = [Common initImageName:@"defaultimage.jpg" onView:self frame:CGRectMake(x, 0, _wh, _wh)];
            //voiceImageView.image = image;
            [self setImageViewFrame:imageView andImage:image];
            [self addSubview:imageView];
            _imageEndX = x + (_wh + _offset);
        }
    }
    
    self.contentSize = CGSizeMake(_imageEndX, self.bounds.size.height);
}

- (void)setImageViewFrame:(UIImageView *)imageView andImage:(UIImage *)image
{
    CGRect baseFrame = imageView.frame;
    
    float www = _wh;
    float hhh = _wh;
    
    float vvv = image.size.width / image.size.height;
    if (vvv > 1.0) {
        hhh = www / vvv;
    }
    else
    {
        www = hhh * vvv;
    }
    CGRect newFrame = CGRectMake(baseFrame.origin.x + (baseFrame.size.width - www) / 2, baseFrame.origin.y + (baseFrame.size.height - hhh) / 2, www, hhh);
    
    imageView.frame = newFrame;
    imageView.image = image;
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
