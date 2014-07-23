//
//  SourceManager.m
//  MiniCom
//
//  Created by wlp on 14-7-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SourceManager.h"
#import "SCGIFImageView.h"

@implementation SourceManager


static SourceManager *object = nil;

+ (SourceManager *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[SourceManager alloc] init];
        }
    }
    return object;
}

- (id)init
{
    self = [super init];
    if (self){
        _imageArray = [[NSMutableArray alloc] init];
        _faceArray = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)loadGifFile
{
    NSString* dir=[self imageFilePath];
    NSString* Path;
    NSString* ext;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:NULL];
    for (NSString *aPath in contentOfFolder) {
        Path = [dir stringByAppendingPathComponent:aPath];
        ext  = [aPath pathExtension];
        
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path isDirectory:&isDir] && !isDir)
        {
            if( [ext isEqualToString:@"gif"] ){
                SCGIFImageView* iv = [[SCGIFImageView alloc] initWithGIFFile:Path];
                [self.imageArray addObject:[iv getFrameAsImageAtIndex:0]];
                [self.faceArray addObject:[Path lastPathComponent]];
            }
        }
    }
}

- (NSString *)imageFilePath {
    NSString *s=[[NSBundle mainBundle] bundlePath];
    s = [s stringByAppendingString:@"/"];
    //NSLog(@"%@",s);
    return s;
}

@end
