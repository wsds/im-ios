//
//  SendSquareFileEditView.m
//  MiniCom
//
//  Created by wlp on 14-7-27.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SendSquareFileEditView.h"
#import "NavView.h"
#import "VoicePlayAnimationView.h"
#import "SquareFileData.h"

@implementation SendSquareFileEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [Common addImageName:@"background3.jpg" onView:self frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];

        _nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.bounds]
                                                title:@""
                                             delegate:self
                                                  sel:@selector(backAction)];
        [self addSubview:_nav];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"picandvoice_del.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(_nav.bounds.size.width - 30, 20, 41 * 0.5, 46 * 0.5);
        [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [_nav addSubview:delBtn];
        
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.frame = [Common RectMakex:0 y:0.1 w:1.0 h:0.9 onSuperBounds:self.bounds];
        //_contentScrollView.backgroundColor = [UIColor grayColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        [self addSubview:_contentScrollView];
        
        _w = _contentScrollView.frame.size.width;
        _h = _contentScrollView.frame.size.height;
    }
    return self;
}

- (void)show:(BOOL)show
{
    if (show) {
        _curPage = 0;
        [_contentScrollView scrollRectToVisible:CGRectMake(0, 0, _contentScrollView.bounds.size.width, _contentScrollView.bounds.size.height) animated:NO];
    }
    self.hidden = !show;
}

- (void)backAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editNavBtnAction)]) {
        [self.delegate editNavBtnAction];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)sender
{
    CGFloat pageWidth = _contentScrollView.frame.size.width;
    _curPage = floor((_contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self setPage:_curPage];
}

- (void)setPage:(int)page
{
    NSString *title = [NSString stringWithFormat:@"%d/%d", page + 1, _pageSum];
    [_nav setTilte:title];
}

- (void)delAction
{
    if ([self.voiceFileArray count] > 0 || [self.imageFileArray count] > 0) {
        
    }
    else
    {
        return;
    }
    
    if (_curPage + 1 <= [self.voiceFileArray count]) {
        //音频
        int index = _curPage;
        SquareFileData *data = [self.voiceFileArray objectAtIndex:index];
        [self.voiceFileArray removeObject:data];
        
        if(_curPage == _pageSum -1)
        _curPage--;
    }
    else
    {
        //图片
        int index = _curPage - [self.voiceFileArray count];
        SquareFileData *data = [self.imageFileArray objectAtIndex:index];
        [self.imageFileArray removeObject:data];
        
        if(_curPage == _pageSum -1)
        _curPage--;
    }
    
    [self updateWithVoiceAry:self.voiceFileArray andImageAry:self.imageFileArray];
}

- (void)updateWithVoiceAry:(NSMutableArray *)voices
               andImageAry:(NSMutableArray *)images
{
    _pageSum = [voices count] + [images count];
    if (_pageSum <= 0) {
        [self backAction];
    }
    else
    {
        [self setPage:_curPage];
    }
    
    //
    self.voiceFileArray = voices;
    self.imageFileArray = images;

    for (UIView *view in _contentScrollView.subviews) {
        if (![view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    _vocieEndX = 0.0;
    _imageEndX = 0.0;
    
    if (voices && [voices count] > 0) {
        for (int i=0; i<[voices count]; i++) {
            float curBeginX = (_w + _offset) * i;
            
            float wh = _w / 2;
            float x = curBeginX + (_contentScrollView.bounds.size.width - wh) / 2;
            float y = (_contentScrollView.bounds.size.height - wh) / 2;
            SquareFileData *sfiledata = [voices objectAtIndex:i];
            CGRect frame = CGRectMake(x, y, wh, wh);
            VoicePlayAnimationView *voiceView = [[VoicePlayAnimationView alloc] init];
            [voiceView setFrame:frame];
            [voiceView setAudioData:sfiledata.fileData];
            [_contentScrollView addSubview:voiceView];
            
            _vocieEndX = curBeginX + (_w + _offset);
        }
    }
    if (images && [images count] > 0) {
        for (int i=0; i<[images count]; i++) {
            SquareFileData *sfiledata = [images objectAtIndex:i];
            UIImage *image = [UIImage imageWithData:sfiledata.fileData];
            float x = _vocieEndX + (_w + _offset) * i;
            UIImageView *imageView = [Common initImageName:@"defaultimage.jpg" onView:_contentScrollView frame:CGRectMake(x, 0, _w, _h)];
            //voiceImageView.image = image;
            [self setImageViewFrame:imageView andImage:image];
            //[_contentScrollView addSubview:imageView];
            _imageEndX = x + (_w + _offset);
        }
    }
    
    _contentScrollView.contentSize = CGSizeMake(_imageEndX, _contentScrollView.bounds.size.height);
}

- (void)setImageViewFrame:(UIImageView *)imageView andImage:(UIImage *)image
{
    CGRect baseFrame = imageView.frame;
    
    float www = _w;
    float hhh = _h;
    
    float vvv = image.size.width / image.size.height;
    hhh = www / vvv;
    
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
