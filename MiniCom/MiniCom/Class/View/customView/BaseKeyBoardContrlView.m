//
//  BaseKeyBoardContrlView.m
//  MiniCom
//
//  Created by wlp on 14-6-4.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseKeyBoardContrlView.h"

//#define animationDuration 0.5

@implementation BaseKeyBoardContrlView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _canHide = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [Common addImageName:@"button_background_click.png" onView:self frame:self.bounds];


    }
    return self;
}

//- (void)keyboardWillShow:(id)sender
//{
//    self.showFrame = CGRectMake(0, kScreen_Width - self.bounds.size.height, kScreen_Width, self.bounds.size.height);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = self.showFrame;
//    }];
//}
//
//- (void)keyboardWillHide:(id)sender
//{
//    self.hideFrame = CGRectMake(0, kScreen_Width - self.bounds.size.height, kScreen_Width, self.bounds.size.height);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = self.hideFrame;
//    }];
//}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (_canHide) {
        [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    }
}

- (void)moveInputBarWithKeyboardHeight:(float)height withDuration:(float)dur
{
    NSLog(@"height==%f", height);
    CGRect frame = CGRectMake(0, kScreen_Height - height - self.bounds.size.height, kScreen_Width, self.bounds.size.height);
    [UIView animateWithDuration:dur
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
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
