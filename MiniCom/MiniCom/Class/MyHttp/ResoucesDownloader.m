//
//  ResoucesDownloader.m
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ResoucesDownloader.h"
#import "ASIHTTPRequest.h"
#import "UrlHeader.h"

@implementation ResoucesDownloader


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)downloadFile:(NSString *)fileName
{
    self.fileName = fileName;
    
    //download
    NSString *urlStr = [BaseURL_IMAGE stringByAppendingString:fileName];
    NSURL *url = [NSURL URLWithString:urlStr];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        //NSLog(@"responseString==%@", responseString);
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        //NSLog(@"responseData==%@", responseData);
        if (self.delegate) {
            [self.delegate downloadFinish:responseData];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
    }];
    [request startAsynchronous];
}


@end
