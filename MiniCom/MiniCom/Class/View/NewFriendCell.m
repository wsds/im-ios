//
//  NewFriendCell.m
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "NewFriendCell.h"
#import "AccountData.h"
#import "UIImageView+WebCache.h"

@implementation NewFriendCell

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
        
        //
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.tag = 1;
        [_disView addSubview:_agreeBtn];
        
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectBtn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
        [_rejectBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rejectBtn.tag = 0;
        [_disView addSubview:_rejectBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //
    _disView.frame = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.9 onSuperBounds:self.bounds];
    _bgImageView.frame = _disView.bounds;
    
    //
    _contentView.frame = [Common RectMakex:0.05 y:0.05 w:0.7 h:0.9 onSuperBounds:_disView.bounds];
    
    float imageWH = _contentView.frame.size.height / 2;
    float xOffset = 5.0;
    _iconImageView.frame = CGRectMake(0, 0, imageWH, imageWH);
    
    _nameLabel.frame = CGRectMake(imageWH + xOffset, 0, _contentView.bounds.size.width - imageWH - xOffset, imageWH);
    
    _contentLabel.frame = CGRectMake(0, imageWH, _contentView.bounds.size.width, imageWH);
    
    //
    _agreeBtn.frame = [Common RectMakex:0.8 y:0.2 w:0.15 h:0.25 onSuperBounds:_disView.bounds];
    _rejectBtn.frame = [Common RectMakex:0.8 y:0.55 w:0.15 h:0.25 onSuperBounds:_disView.bounds];
}


- (void)setCellWithData:(AccountData *)data
{
    self.friendData = data;
    
    //friend
    NSString *iconName = data.head;
    [_iconImageView setImageWithURL:[Common getUrlWithImageName:iconName] placeholderImage:[Common getDefaultAccountIcon]];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = _iconImageView.bounds.size.width / 2.0;
    
    _nameLabel.text = data.nickName;
    
    //message
    _contentLabel.text = data.message;
    
    //
    if ([data.friendStatus isEqualToString:@"init"]) {
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    }
}

- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    BOOL status = btn.tag;
    
    [self.delegate selectMember:self.friendData status:status];
    
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

@end
