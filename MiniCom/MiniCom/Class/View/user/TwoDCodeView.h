//
//  TwoDCodeView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseTitleView.h"

@interface TwoDCodeView : BaseTitleView
{
    UIImageView *icon;
}
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
          imageName:(NSString *)imageName;

- (void)setUrlImageName:(NSString *)name;

@end
