//
//  SquareFileData.h
//  MiniCom
//
//  Created by wlp on 14-7-27.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ENUM_VOICE,
    ENUM_IMAGE,
}ENUM_FILE_TYPE;

@interface SquareFileData : NSObject

@property(nonatomic, assign) ENUM_FILE_TYPE fileType;
@property(nonatomic, retain) NSString *fileName;
@property(nonatomic, retain) NSData *fileData;

@end
