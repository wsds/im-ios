//
//  MyButton.h
//  MiniCom
//
//  Created by wlp on 14-5-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    E_Changtiao,
    E_Sanjiao,
    E_None
};

@interface MyButton : UIButton
{
    UIImageView *_selectImageView;
}
- (void)setSelectedImageModel:(int)model;

@end
