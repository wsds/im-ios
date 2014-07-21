//
//  DbFileManager.h
//
//  Created by fox wang on 12-3-23.
//
//针对数据库文件的封装类
#import <Foundation/Foundation.h>

@interface DBFileManager : NSObject

+ (NSString *)documentPath;

+ (void)checkWithCreateDbFile:(NSString *)fullPath;

+ (NSString *)dbFilePath;

+ (BOOL)createFolderInDocment:(NSString *)folderName;



@end
