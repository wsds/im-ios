//
//  GroupBaseView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseTitleView.h"

@interface GroupBaseView : BaseTitleView<UIScrollViewDelegate>
{
    UILabel *_footlabel;
    
    int _sub_HHH;
    int _sub_VVV;
    
    float _subView_w;
    float _subView_h;
    
    UIPageControl *_pageController;
}

@property(nonatomic, retain) UIScrollView *scrollv;

- (void)setFootTitle:(NSString *)title;

@end
