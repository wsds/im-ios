//
//  ChatTableViewCell.m
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "VoicePlayAnimationView.h"
#import "NSString+Tools.h"
#import "SCGIFImageView.h"
#import "JXEmoji.h"

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor = [UIColor blueColor];
        
        _disView = [[UIView alloc] init];
        //_disView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_disView];
        
        _bgImageView = [Common initImageName:@"button_background_click.png" onView:_disView frame:_disView.bounds];
        
        //icon
        _icon_left = [[UIImageView alloc] init];
        [_disView addSubview:_icon_left];
        
        _iconBtn_left = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn_left addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_disView addSubview:_iconBtn_left];
        
        _icon_right = [[UIImageView alloc] init];
        [_disView addSubview:_icon_right];
        
        _iconBtn_right = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn_right addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_disView addSubview:_iconBtn_right];
        
        //content
        _contentView = [[UIView alloc] init];
        //_contentView.backgroundColor = [UIColor greenColor];
        [_disView addSubview:_contentView];
        
        //
//        _contentTextView = [[UITextView alloc] init];
//        [_contentView addSubview:_contentTextView];
//        _contentTextView.backgroundColor = [UIColor clearColor];
//        _contentTextView.textColor = [UIColor whiteColor];
//        _contentTextView.editable = NO;
//        _contentTextView.hidden = YES;
        
        _messageConent=[[JXEmoji alloc]initWithFrame:CGRectMake(0, 0, JXCELL_W, JXCELL_H)];
        _messageConent.backgroundColor = [UIColor clearColor];
        _messageConent.textColor = [UIColor whiteColor];
        _messageConent.userInteractionEnabled = NO;
        _messageConent.numberOfLines = 0;
        _messageConent.lineBreakMode = NSLineBreakByWordWrapping;
        //_messageConent.font = [UIFont systemFontOfSize:15];
        //_messageConent.offset = -120;
        [_contentView addSubview:_messageConent];
        
        _contentImageView = [[UIImageView alloc] init];
        [_contentView addSubview:_contentImageView];
        _contentImageView.hidden = YES;
        
        _contentVoiceView = [[VoicePlayAnimationView alloc] init];
        [_contentView addSubview:_contentVoiceView];
        _contentVoiceView.hidden = YES;
        
        _gifView = [[UIView alloc] init];
        [_contentView addSubview:_gifView];
        _gifView.hidden = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _disView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20.0);
    _bgImageView.frame = _disView.bounds;
    
    float imageWH = 40.0;
    float imageXoffset = imageWH * 0.1;
    float imageY = (_disView.bounds.size.height - imageWH) / 2;
    
    //icon
    iconFrame_L = CGRectMake(imageXoffset, imageY, imageWH, imageWH);
    iconFrame_R = CGRectMake(_disView.bounds.size.width - imageWH - imageXoffset, imageY, imageWH, imageWH);
    _icon_left.frame = iconFrame_L;
    _icon_left.layer.masksToBounds = YES;
    _icon_left.layer.cornerRadius = _icon_left.bounds.size.width / 2.0;
    _icon_right.frame = iconFrame_R;
    _icon_right.layer.masksToBounds = YES;
    _icon_right.layer.cornerRadius = _icon_right.bounds.size.width / 2.0;
    
    _iconBtn_left.frame = iconFrame_L;
    _iconBtn_right.frame = iconFrame_R;
    
    float contentH = _disView.bounds.size.height * 0.9;
    float contentY = (_disView.bounds.size.height - contentH) / 2;;
    float contentW = _disView.bounds.size.width - (imageXoffset*2 + imageWH) * 2  + imageWH;

    contentFrame_L = CGRectMake(imageXoffset*2, contentY, contentW, contentH);
    contentFrame_R = CGRectMake(imageXoffset*2 + imageWH, contentY, contentW, contentH);

    //content
//    _contentTextView.frame = _contentView.bounds;
//    _contentTextView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    _messageConent.frame = CGRectMake(0, 0, contentW, contentH);
    //_messageConent.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    
    
    float cImageWH = contentH;
    CGRect imageFrame = CGRectMake((contentW - cImageWH) / 2, 0, cImageWH, cImageWH);
    _contentImageView.frame = imageFrame;
    _contentImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    _contentVoiceView.frame = CGRectMake(0, 0, contentW, contentH);
    _contentVoiceView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    _gifView.frame = imageFrame;
    _gifView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    _gifv.frame = _gifView.bounds;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithData:(ChatMessData *)data
{
    //[self updateFrame];
    
    //_iconImageView f000.png
    NSString *iconName = DefaultIconName;
    if (data.isSend == 1) {
        //我
        _icon_left.hidden = YES;
        _icon_right.hidden = NO;
        _iconBtn_left.hidden = YES;
        _iconBtn_right.hidden = NO;
        iconName = self.mineData.head;
        //NSLog(@"mineData iconName==%@", iconName);
        [_icon_right setImageWithURL:[Common getUrlWithImageName:iconName] placeholderImage:[Common getDefaultAccountIcon]];
  
        //content
        _contentView.frame = contentFrame_L;
    }
    else
    {
        _icon_left.hidden = NO;
        _icon_right.hidden = YES;
        _iconBtn_left.hidden = NO;
        _iconBtn_right.hidden = YES;
        iconName = self.friendData.head;
        //NSLog(@"iconName==%@", iconName);
        [_icon_left setImageWithURL:[Common getUrlWithImageName:iconName] placeholderImage:[Common getDefaultAccountIcon]];
        
        //content
        _contentView.frame = contentFrame_R;
    }

    //content
    if ([data.contentType isEqualToString:ContentType_Text]) {
        _contentImageView.hidden = YES;
        _contentVoiceView.hidden = YES;
        if ([data.content isGifFileName]) {
            //_contentTextView.hidden = YES;
            _messageConent.hidden = YES;
            _gifView.hidden = NO;
            for (UIView *view in _gifView.subviews) {
                [view removeFromSuperview];
            }
            NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[data.content lastPathComponent]];
            _gifv = [[SCGIFImageView alloc] initWithGIFFile:path];
            _gifv.frame = _gifView.bounds;
            [_gifView addSubview:_gifv];
        }
        else
        {
            _gifView.hidden = YES;
//            _contentTextView.hidden = NO;
//            _contentTextView.text = data.content;
            _messageConent.hidden = NO;
            _messageConent.text = data.content;
        }
        
        return;
    }
    if ([data.contentType isEqualToString:ContentType_Image]) {
        //_contentTextView.hidden = YES;
        _messageConent.hidden = YES;

        _contentImageView.hidden = NO;
        _contentVoiceView.hidden = YES;
        
        [_contentImageView setImageWithURL:[Common getUrlWithImageName:data.content] placeholderImage:[Common getDefaultBadImage]];
        return;
    }
    if ([data.contentType isEqualToString:ContentType_Voice]) {
        //_contentTextView.hidden = YES;
        _messageConent.hidden = YES;

        _contentImageView.hidden = YES;
        _contentVoiceView.hidden = NO;
        
        [_contentVoiceView setAudioFileName:data.content];
        return;
    }
}

- (void)leftBtnAction
{
    [self.delegate selectChatMember:self.friendData];
}

- (void)rightBtnAction
{
    [self.delegate selectChatMember:self.mineData];
}

@end
