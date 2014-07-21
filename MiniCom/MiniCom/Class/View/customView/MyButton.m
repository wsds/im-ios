//
//  MyButton.m
//  MiniCom
//
//  Created by wlp on 14-5-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyButton.h"
#import "Common.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectImageView = [[UIImageView alloc] init];
        [self addSubview:_selectImageView];
        _selectImageView.hidden = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setSelectedImageModel:(int)model
{
    switch (model) {
        case E_Changtiao:
            [_selectImageView setFrame:[Common RectMakex:0.0 y:0.9 w:1.0 h:0.1 onSuperBounds:self.bounds]];
            [_selectImageView setImage:[UIImage imageNamed:@"line_blue.png"]];
            break;
        case E_Sanjiao:
            [_selectImageView setFrame:[Common RectMakex:0.4 y:0.8 w:0.2 h:0.2 onSuperBounds:self.bounds]];
            [_selectImageView setImage:[UIImage imageNamed:@"menu_selected.png"]];
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected
{
    _selectImageView.hidden = !selected;
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
