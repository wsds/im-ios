//
//  ResoucesUploader.h
//  MiniCom
//
//  Created by wlp on 14-9-14.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol uploadFileDelegate <NSObject>

- (void)uploadSucess:(NSString *)fileName type:(NSString *)type;

- (void)uploadFail:(NSString *)fileName type:(NSString *)type;

@end

@interface ResoucesUploader : NSObject

@property(nonatomic, assign) id <uploadFileDelegate>delegate;

@property(nonatomic, retain) NSString *fileType;

@property(nonatomic, retain) NSString *fileName;

- (void)reqestUploadResouceData:(NSData *)data name:(NSString *)fileName type:(NSString *)type;

@end
