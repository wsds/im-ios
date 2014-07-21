//
//  GroupBaseView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupBaseView.h"

@implementation GroupBaseView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
{
    self = [super initWithFrame:(CGRect)frame
                          title:(NSString *)title
                       needBack:(BOOL)needBack
                       delegate:(id)delegate
                            tag:(int)tag];
    if (self) {
        // Initialization code
        
        float footLintHeight = 1.0;
        float pageH = 10.0;
        float offset = 5.0;
        
        //title
        float ly = self.contentView.bounds.size.height - 40;
        _footlabel = [[UILabel alloc] init];
        _footlabel.frame = CGRectMake(0, ly, self.contentView.frame.size.width, 40);
        _footlabel.textColor = [UIColor whiteColor];
        _footlabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_footlabel];
        
        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _footlabel.frame.origin.y - footLintHeight, self.contentView.frame.size.width, footLintHeight)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lineView];
        
        //page
        _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _footlabel.frame.origin.y - pageH - offset, self.contentView.frame.size.width, pageH)];
        [self.contentView addSubview:_pageController];
        _pageController.backgroundColor = [UIColor clearColor];
        _pageController.currentPage = 0;
        _pageController.enabled = NO;
        
        //
        _scrollv = [[UIScrollView alloc] init];
        _scrollv.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, _pageController.frame.origin.y - offset);
        _scrollv.contentSize = _scrollv.bounds.size;
        _scrollv.showsHorizontalScrollIndicator = NO;
        _scrollv.backgroundColor = [UIColor clearColor];
        _scrollv.pagingEnabled = YES;
        _scrollv.delegate = self;
        [self.contentView  addSubview:_scrollv];
    }
    return self;
}

- (void)setFootTitle:(NSString *)title
{
    _footlabel.text = title;
}

- (void)scrollViewDidScroll:(UIScrollView*)sender
{
    CGFloat pageWidth = _scrollv.frame.size.width;
    int page = floor((_scrollv.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageController.currentPage = page;
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
