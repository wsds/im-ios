//
//  SourceManager.h
//  MiniCom
//
//  Created by wlp on 14-7-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceManager : NSObject

@property(nonatomic, retain) NSMutableArray *imageArray;

@property(nonatomic, retain) NSMutableArray *faceArray;

+ (SourceManager *)SharedInstance;

- (void)loadGifFile;

@end
