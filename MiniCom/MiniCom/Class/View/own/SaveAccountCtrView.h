//
//  SaveAccountCtrView.h
//  MiniCom
//
//  Created by wlp on 14-6-25.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseKeyBoardContrlView.h"

@protocol SaveAccountCtrViewDelegate <NSObject>

- (void)delegateSave;

- (void)delegateCancel;

@end

@interface SaveAccountCtrView : BaseKeyBoardContrlView

@property (nonatomic, assign) id<SaveAccountCtrViewDelegate>delegate;


@end
