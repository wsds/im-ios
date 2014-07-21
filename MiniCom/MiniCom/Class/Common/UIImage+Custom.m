//
//  UIImage+Custom.m
//  GuessGame
//
//  Created by wanglipeng on 13-9-2.
//  Copyright (c) 2013年 wanglipeng. All rights reserved.
//

#import "UIImage+Custom.h"
#import "UIImageView+WebCache.h"
#import "Common.h"

@implementation UIImage (Custom)

- (UIImage*)scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (UIImage *)getScreenImage
{
    //plan A.
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
    
    //plan B 私有
//    UIImage *snapshot = nil;
//    CGImageRef cgScreen = UIGetScreenImage();
//    if (cgScreen) {
//        snapshot = [UIImage imageWithCGImage:cgScreen];
//        CGImageRelease(cgScreen);
//    }
//    CGRect rect = CGRectMake(0,0, snapshot.size.width, snapshot.size.height);//创建要剪切的矩形框 这里你可以自己修改
//    struct CGImage *cgImg = CGImageCreateWithImageInRect([snapshot CGImage], rect);
//    UIImage *res = [UIImage imageWithCGImage:cgImg];
//    CGImageRelease(cgImg);
//    //self.chooseView.transform = CGAffineTransformMakeRotation(72*animateIndex *M_PI / 180.0);
//    return res;
}

+ (UIImage *)getImageFromView:(UIView *)view
{
    UIImage *snapshot = nil;
    for (UIView *subView in [view subviews]) {//遍历这个view的subViews
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(subView.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(subView.frame.size);
        }
        
        //获取图像
        [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return snapshot;
    }
    return snapshot;
}

- (UIImage*)cropRect:(CGRect)myImageRect
{
//    myImageRect.size.width *= 2;
//    myImageRect.size.height *= 2;

    CGSize size = myImageRect.size;
    
    CGImageRef imageRef = self.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    

    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    CGImageRelease(subImageRef);
    
    UIGraphicsEndImageContext();  
    
    return smallImage;  
    
}


@end
