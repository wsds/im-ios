//
//  ChatCell.m
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ChatCell.h"
#import "UIImageView+WebCache.h"
#import "GroupManager.h"
#import "GroupData.h"
#import "NumView.h"

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor = [UIColor blueColor];
        
        _disView = [[UIView alloc] init];
        //_disView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_disView];
        
        _bgImageView = [Common initImageName:@"button_background_click.png" onView:_disView frame:_disView.bounds];
        
        //content
        _contentView = [[UIView alloc] init];
        //_contentView.backgroundColor = [UIColor lightGrayColor];
        [_disView addSubview:_contentView];
        
        //icon
        _iconImageView = [[UIImageView alloc] init];
        [_contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        [_contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        [_contentView addSubview:_contentLabel];
        
        //unread
        _unReadCountView = [[NumView alloc] init];
        [_disView addSubview:_unReadCountView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _disView.frame = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.9 onSuperBounds:self.bounds];
    _bgImageView.frame = _disView.bounds;
    
    //
    _contentView.frame = [Common RectMakex:0.05 y:0.05 w:0.79 h:0.9 onSuperBounds:_disView.bounds];
    
    float imageWH = _contentView.frame.size.height / 2;
    float xOffset = 5.0;
    _iconImageView.frame = CGRectMake(0, 0, imageWH, imageWH);
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = _iconImageView.bounds.size.width / 2.0;
    
    _nameLabel.frame = CGRectMake(imageWH + xOffset, 0, _contentView.bounds.size.width - imageWH - xOffset, imageWH);
    
    _contentLabel.frame = CGRectMake(0, imageWH, _contentView.bounds.size.width, imageWH);
    
    //
    float wh = 26.0;
    float numXoffset = 10.0;
    float x = _contentView.frame.origin.x + _contentView.frame.size.width + numXoffset;
    float y = (_contentView.frame.size.height - wh) / 2;
    _unReadCountView.frame = CGRectMake(x, y, wh, wh);
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
    if ([data.gid length] > 0) {
        //group
        GroupData * groupData= [[GroupManager SharedInstance] getGroupDataById:data.gid];
        //
        [_iconImageView setImageWithURL:[Common getUrlWithImageName:groupData.icon] placeholderImage:[Common getDefaultAccountIcon]];
        //
        _nameLabel.text = [NSString stringWithFormat:@"%@(群组)", groupData.name];
    }
    else
    {
        //friend
        NSString *iconName = self.friendData.head;
        [_iconImageView setImageWithURL:[Common getUrlWithImageName:iconName] placeholderImage:[Common getDefaultAccountIcon]];
        //
        _nameLabel.text = self.friendData.nickName;
    }
    
    //message
    if ([data.contentType isEqualToString:@"image"]) {
        _contentLabel.text = @"[图片]";
    }
    else if ([data.contentType isEqualToString:@"voice"]) {
        _contentLabel.text = @"[音频]";
    }
    else
    {
        _contentLabel.text = data.content;
    }
}

- (void)setUnreadCount:(int)num
{
    if (num > 0) {
        _unReadCountView.hidden = NO;
        [_unReadCountView setNum:num];
    }
    else
    {
        _unReadCountView.hidden = YES;
    }
}

@end
