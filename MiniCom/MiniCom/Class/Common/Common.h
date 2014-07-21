//
//  Common.h
//  LittleWeather
//
//  Created by wlp on 14-4-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//Date
+ (NSString *)stringFromDate:(NSDate *)date model:(NSString *)model;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString model:(NSString *)model;
+ (NSDate *)dateFromString:(NSString *)dateString;

//
+ (BOOL)isNetWork;

+ (void)alert4error:(NSString *)msg tag:(NSInteger)tag delegate:(id)delegate;

//适配
+ (float)getCurFontSize:(float)size;

+ (CGRect)RectMakex:(float)x y:(float)y w:(float)w h:(float)h onSuperBounds:(CGRect)bounds;

+ (CGRect)getMidFrameFromBaseFrame:(CGRect)baseFrame;

//
+ (void)addImageName:(NSString *)imageName
              onView:(UIView *)view
               frame:(CGRect)frame;

+ (UIImageView *)initImageName:(NSString *)imageName
                        onView:(UIView *)view
                         frame:(CGRect)frame;

+ (NSURL *)getUrlWithImageName:(NSString *)name;

+ (UIImage *)getDefaultBadImage;

+ (UIImage *)getDefaultAccountIcon;

+ (NSString *)getFileNameResouceData:(NSData *)data type:(NSString *)fileType;

+ (NSData *)scaleAndTransImage:(UIImage *)image;

@end
