//
//  Common.m
//  LittleWeather
//
//  Created by wlp on 14-4-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Common.h"
#import "UrlHeader.h"
#import "Header.h"
#import "GTMBase64.h"
#import "NSString+Tools.h"
#import "UIImage+Custom.h"


@implementation Common

+ (void)alert4error:(NSString *)msg tag:(NSInteger)tag delegate:(id)delegate{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:delegate cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    alertView.tag = tag;
    [alertView show];
}

+ (float)getCurFontSize:(float)size
{
    float curSize = size;
    if (isPad) {
        curSize = size * (float)(1024 / 960);
    }
    return curSize;
}

+ (CGRect)RectMakex:(float)x y:(float)y w:(float)w h:(float)h onSuperBounds:(CGRect)bounds
{
    float r_x = bounds.size.width * x;
    float r_y = bounds.size.height * y;
    float r_w = bounds.size.width * w;
    float r_h = bounds.size.height * h;
    return CGRectMake(r_x, r_y, r_w, r_h);
}

+ (CGRect)getMidFrameFromBaseFrame:(CGRect)baseFrame
{
    float www = baseFrame.size.width;
    float hhh = baseFrame.size.height;
    
    float vvv = www / hhh;
    if (vvv > 1.0) {
        www = hhh;
    }
    else
    {
        hhh = www;
    }
    return CGRectMake(baseFrame.origin.x + (baseFrame.size.width - www) / 2,
                      baseFrame.origin.y + (baseFrame.size.height - hhh) / 2,
                      www,
                      hhh);
}

+ (void)addImageName:(NSString *)imageName
              onView:(UIView *)view
               frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [view addSubview:imageView];
}

+ (UIImageView *)initImageName:(NSString *)imageName
               onView:(UIView *)view
                frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [view addSubview:imageView];
    return imageView;
}

+ (NSURL *)getUrlWithImageName:(NSString *)name
{
    if (name) {
        return [[NSURL alloc] initWithString:[BaseURL_IMAGE stringByAppendingString:name]];
    }
    else
    {
        return nil;
    }
}

+ (UIImage *)getDefaultBadImage
{
    return [UIImage imageNamed:DefaultBadImageName];
}

+ (UIImage *)getDefaultAccountIcon
{
    return [UIImage imageNamed:DefaultIconName];
}

+ (NSString *)getFileNameResouceData:(NSData *)data type:(NSString *)fileType
{
    //base64
    NSData *base64Data = [GTMBase64 encodeData:data];
    NSString *dataString = [[NSString alloc] initWithBytes:[base64Data bytes] length:[base64Data length] encoding:NSUTF8StringEncoding];

    //sha1 name
    NSString *dataShaStr = [dataString sha1Str];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", dataShaStr, fileType];
    NSLog(@"fileName==%@", fileName);
    return fileName;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
        scaleFactor = widthFactor; // scale to fit height
        else
        scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
    NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)scaleAndTransImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    float w = 800*(image.size.width/image.size.height);
    float h = 800;
    UIImage* thumb = nil;
    
    int size = 256;
    //循环使缩略图大小<sizeK为止
    while (data.length >= size*1024) {
        w *= 0.5;
        h *= 0.5;
        thumb = [image scaledToSize:CGSizeMake(w, h)];
        data = UIImageJPEGRepresentation(thumb, 1.0);
    }
    return data;
}

//date
//
+ (NSString *)stringFromDate:(NSDate *)date model:(NSString *)model{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    if ([model length] == 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else{
        [dateFormatter setDateFormat:model];
    }
    //@"yyyy-MM-dd HH:mm:ss"
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString model:(NSString *)model
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([model length] == 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else{
        [dateFormatter setDateFormat:model];
    }
    //[dateFormatter setDateFormat: @"HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];

    return destDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat: @"HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];

    return destDate;
}

@end
