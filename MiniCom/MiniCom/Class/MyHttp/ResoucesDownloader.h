//
//  ResoucesDownloader.h
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResoucesDownloaderDelegate <NSObject>

- (void)downloadFinish:(NSData *)data;

@end

@interface ResoucesDownloader : NSObject

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, assign) id<ResoucesDownloaderDelegate> delegate;

- (void)downloadFile:(NSString *)fileName;

@end
