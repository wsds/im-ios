//
//  ChoosePhotoView.h
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@protocol ChoosePhotoViewDelegate <NSObject>

- (void)choosePhotoViewImage:(UIImage *)image;

@end

@interface ChoosePhotoViewController : UIViewController
{
    UIButton *_lbtn;
    UIButton *_rbtn;
}
@property (nonatomic, assign) id<ChoosePhotoViewDelegate>delegate;

@end
