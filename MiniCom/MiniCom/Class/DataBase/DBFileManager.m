//
//  DbFileManager.m
//
//  Created by fox wang on 12-3-23.
//

#import "DBFileManager.h"
#define k_DB_NAME @"DB_Mini.sqlite"

@implementation DBFileManager

// Document路径
+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 拷贝数据库文件
+ (void)checkWithCreateDbFile:(NSString *)fullPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbFileName = k_DB_NAME;
    BOOL found = [fileManager fileExistsAtPath:fullPath];
    if(!found)
    {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *defaultDBFilePath =
        [resourcePath stringByAppendingPathComponent:dbFileName];
        
        found = [fileManager copyItemAtPath:defaultDBFilePath
                                     toPath:fullPath
                                      error:&error];
        if (!found)
        {
            NSAssert1(0,
                      @"创建数据库失败 '%@'.",
                      [error localizedDescription]);
        }
    }
}

// 数据库路径
+ (NSString *)dbFilePath
{
    NSString *dbFileName = k_DB_NAME;
    NSString *documentsDirectory = [DBFileManager documentPath];
    
    NSString *dbFilePath =
    [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    //[DbFileManager checkWithCreateDbFile:dbFilePath];
    NSLog(@"%@",dbFilePath);
    
    return dbFilePath;
}

// 创建文件夹
+ (BOOL)createFolderInDocment:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [DBFileManager documentPath];
    NSString *foldFullPath =  [documentsDirectory stringByAppendingPathComponent:folderName];
    return [fileManager createDirectoryAtPath:foldFullPath withIntermediateDirectories:YES attributes:nil error:nil];
}


@end
