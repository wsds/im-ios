//
//  SquareSubView.m
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareSubView.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "SquareContentData.h"
#import "AccountManager.h"
#import "JXEmoji.h"

@implementation SquareSubView

- (id)initWithFrame:(CGRect)frame data:(SquareMessData *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.squareData = data;
        
        _contentView = [[UIView alloc] init];
        _contentView.frame = [Common RectMakex:0.025 y:0.025 w:0.95 h:0.95 onSuperBounds:self.bounds];
//        _contentView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_contentView];
        
        [Common addImageName:@"button_background_click.png" onView:_contentView frame:_contentView.bounds];

        for (int i=0; i<[data.content count]; i++) {
            SquareContentData *contentData = [data.content objectAtIndex:i];
            if ([contentData.type isEqualToString:@"text"]) {
                self.text = contentData.details;
            }
            else if ([contentData.type isEqualToString:@"image"]) {
                self.imageName = contentData.details;
            }
            else if ([contentData.type isEqualToString:@"voice"]) {
                self.voiceName = contentData.details;
            }
        }
        
        //text
        if ([self.text length] > 0) {
//            _textLb = [[UILabel alloc] init];
//            _textLb.frame = [Common RectMakex:0 y:0 w:0.9 h:0.1 onSuperBounds:_contentView.bounds];
//            _textLb.text = self.text;
//            _textLb.textColor = [UIColor whiteColor];
//            _textLb.textAlignment = NSTextAlignmentCenter;
//            [_contentView addSubview:_textLb];
            
            _messageConent=[[JXEmoji alloc]initWithFrame:[Common RectMakex:0 y:0 w:0.9 h:0.1 onSuperBounds:_contentView.bounds]];
            _messageConent.backgroundColor = [UIColor clearColor];
            _messageConent.textColor = [UIColor whiteColor];
            _messageConent.userInteractionEnabled = NO;
            _messageConent.numberOfLines = 0;
            _messageConent.lineBreakMode = NSLineBreakByWordWrapping;
            _messageConent.font = [UIFont systemFontOfSize:BaseFontSize_L];
            _messageConent.text = self.text;
            [_contentView addSubview:_messageConent];
            //_messageConent.offset = -12;
        }
        
        //image
        if ([self.imageName length] > 0) {
            _imageView = [Common initImageName:@"" onView:_contentView frame:[Common RectMakex:0 y:0.1 w:0.9 h:0.65 onSuperBounds:_contentView.bounds]];
            [_imageView setImageWithURL:[Common getUrlWithImageName:self.imageName] placeholderImage:[Common getDefaultBadImage]];
        }
        
        //voice
        if ([self.voiceName length] > 0) {
            _voiceIcon = [Common initImageName:@"selected_voice.png" onView:_contentView frame:[Common RectMakex:0.9 y:0 w:0.1 h:0.1 onSuperBounds:_contentView.bounds]];
        }
        
        //account
        [self loadAccountView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)loadAccountView
{
    _accountInfoView = [[UIView alloc] init];
    _accountInfoView.frame = [Common RectMakex:0.025 y:0.8 w:0.95 h:0.18 onSuperBounds:_contentView.bounds];
    [_contentView addSubview:_accountInfoView];
    
    CGRect imageframe = CGRectMake(0, 0, _accountInfoView.bounds.size.height, _accountInfoView.bounds.size.height);
    UIImageView *iconImageView = [Common initImageName:@"" onView:_accountInfoView frame:imageframe];
    [iconImageView setImageWithURL:[Common getUrlWithImageName:self.squareData.head] placeholderImage:[Common getDefaultAccountIcon]];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = iconImageView.bounds.size.width / 2.0;
    
    float x = iconImageView.frame.origin.x + iconImageView.frame.size.width +  10;
    UILabel *name_lb = [[UILabel alloc] init];
    name_lb.frame = CGRectMake(x, 0, _accountInfoView.bounds.size.width - x, _accountInfoView.bounds.size.height / 2);
    name_lb.text = self.squareData.nickName;
    name_lb.textColor = [UIColor whiteColor];
    name_lb.font = [UIFont systemFontOfSize:BaseFontSize_S];
    [_accountInfoView addSubview:name_lb];
    
    //
    
    //comment.png", @"praise.png
    CGRect commentframe = CGRectMake(_accountInfoView.bounds.size.width * 4 / 8, _accountInfoView.bounds.size.height / 2, _accountInfoView.bounds.size.width / 8, _accountInfoView.bounds.size.height / 2);
    [Common addImageName:@"comment.png" onView:_accountInfoView frame:commentframe];

    CGRect commentTitleFrame = CGRectMake(_accountInfoView.bounds.size.width * 5 / 8, _accountInfoView.bounds.size.height / 2, _accountInfoView.bounds.size.width / 8, _accountInfoView.bounds.size.height / 2);
    UILabel *comment_lb = [[UILabel alloc] init];
    comment_lb.frame = commentTitleFrame;
    comment_lb.text = @"0";
    comment_lb.textColor = [UIColor whiteColor];
    comment_lb.textAlignment = NSTextAlignmentCenter;
    [_accountInfoView addSubview:comment_lb];
    
    //
    CGRect praiseframe = CGRectMake(_accountInfoView.bounds.size.width * 6 / 8, _accountInfoView.bounds.size.height / 2, _accountInfoView.bounds.size.width / 8, _accountInfoView.bounds.size.height / 2);
    BOOL hadPraise = [AccountManager getCurUserPraiseYorN:self.squareData.praiseusers];
    NSString *name = @"praise.png";
    if (hadPraise) {
        name = @"praised.png";
    }
    UIImageView *praiseImageView = [[UIImageView alloc] init];
    praiseImageView.frame = praiseframe;
    praiseImageView.image = [UIImage imageNamed:name];
    [_accountInfoView addSubview:praiseImageView];
    
    CGRect praiseTitleFrame = CGRectMake(_accountInfoView.bounds.size.width * 7 / 8, _accountInfoView.bounds.size.height / 2, _accountInfoView.bounds.size.width / 8, _accountInfoView.bounds.size.height / 2);
    UILabel *praise_lb = [[UILabel alloc] init];
    praise_lb.frame = praiseTitleFrame;
    NSString *praiseusersCount = [NSString stringWithFormat:@"%lu", (unsigned long)[self.squareData.praiseusers count]];
    praise_lb.text = praiseusersCount;
    praise_lb.textColor = [UIColor whiteColor];
    praise_lb.textAlignment = NSTextAlignmentCenter;
    [_accountInfoView addSubview:praise_lb];
}

- (void)btnAction
{
    [self.delegate selectSquareWithId:self.squareData];
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
