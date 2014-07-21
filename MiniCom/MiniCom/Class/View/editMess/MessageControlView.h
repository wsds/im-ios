//
//  MessageControlView.h
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKeyBoardContrlView.h"

typedef enum {
    E_MessState_Cancel  = 0,
    E_MessState_Voice   = 1,
    E_MessState_Emoji   = 2,
    E_MessState_Image   = 3,
    E_MessState_Done    = 4,
}E_MessState;

@protocol MessageControlViewDelegate <NSObject>

- (void)messCtrViewClickedButtonAtIndex:(E_MessState)tag;

@end

@interface MessageControlView : BaseKeyBoardContrlView

@property (nonatomic, assign) id<MessageControlViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
