//
//  ImageControlView.h
//  MiniCom
//
//  Created by wlp on 14-6-5.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageControlViewDelegate <NSObject>

- (void)photoCtrViewClickedButtonAtIndex:(int)tag;

@end

@interface PhotoControlView : UIView

@property (nonatomic, assign) id<ImageControlViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
