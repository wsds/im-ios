//
//  SquareSubView.h
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareMessData.h"
@class JXEmoji;

@protocol SquareSubViewDelegate <NSObject>

- (void)selectSquareWithId:(SquareMessData *)data;

@end

@interface SquareSubView : UIView
{
    UIView *_contentView;
    
    //UILabel *_textLb;
    JXEmoji *_messageConent;
    
    UIImageView *_imageView;
    
    UIImageView *_voiceIcon;

    //
    UIView *_accountInfoView;
}

@property(nonatomic, assign) id<SquareSubViewDelegate> delegate;

@property(nonatomic, assign) int squareId;

@property(nonatomic, retain) SquareMessData *squareData;

@property(nonatomic, retain) NSString *text;

@property(nonatomic, retain) NSString *imageName;

@property(nonatomic, retain) NSString *voiceName;

- (id)initWithFrame:(CGRect)frame data:(SquareMessData *)data;

@end
