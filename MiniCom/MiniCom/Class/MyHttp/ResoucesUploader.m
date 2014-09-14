//
//  ResoucesUploader.m
//  MiniCom
//
//  Created by wlp on 14-9-14.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ResoucesUploader.h"
#import "MyHttpRequest.h"
#import "GTMBase64.h"

@implementation ResoucesUploader

- (id)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)reqestUploadResouceData:(NSData *)data name:(NSString *)fileName type:(NSString *)type
{
    self.fileName = fileName;
    self.fileType = type;
    
    //base64
    NSData *base64Data = [GTMBase64 encodeData:data];
    NSString *dataString = [[NSString alloc] initWithBytes:[base64Data bytes] length:[base64Data length] encoding:NSUTF8StringEncoding];
    
    //check
    //[self reqestCheckFileName:fileName];
    
    //upload
    NSDictionary *dic_params = @{@"filename":fileName,
                                 @"imagedata":dataString};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_resources_upload
                                                    params:dic_params
                                                       tag:1
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
}

- (void)reqestCheckFileName:(NSString *)fileName
{
    //check
    NSDictionary *dic_params = @{@"filename":fileName};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_resources_check
                                                    params:dic_params
                                                       tag:0
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSLog(@"uploader isSuccessEquals");
    switch (result.tag) {
        case 0:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"查找成功"]) {
                NSLog(@"查找成功");
                BOOL exists = [[dic valueForKey:@"exists"] boolValue];
                if (exists) {
                    NSLog(@"had");
                }
                else
                {
                    NSLog(@"no have");
                }
            }
            else if([response isEqualToString:@"查找失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                //[Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case 1:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"图片上传成功"]) {
                NSLog(@"图片或者音频上传成功");
                [self.delegate uploadSucess:self.fileName type:self.fileType];
            }
            else if([response isEqualToString:@"图片上传失败"])
            {
                NSLog(@"图片或者音频图片上传失败");
                NSString *error = [dic valueForKey:@"失败原因"];
                NSLog(@"error==%@", error);
                
                [self.delegate uploadFail:self.fileName type:self.fileType];
            }
            break;
        }
        default:
            break;
    }
}

@end
