//
//  SquareInfoView.h
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SquareInfoViewDelegate <NSObject>

- (void)addSquarePraise:(BOOL)operation;

@end

@interface SquareInfoView : UIView
{
    NSMutableArray *_lbItems;
    NSMutableArray *_imageItems;
}

@property(nonatomic, assign) id <SquareInfoViewDelegate>delegate;

@property(nonatomic, assign) BOOL hadPraise;

- (void)updateTime:(NSString *)time
             local:(NSString *)local
         noteCount:(int)note
         niceCount:(int)nice
         markCount:(int)mark;
@end
