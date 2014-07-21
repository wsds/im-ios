//
//  DBHelper.h
//  t0705_refresh
//
//  Created by tt on 13-3-31.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "ChatMessData.h"
#import "AccountData.h"

@interface DBHelper : NSObject

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;

@property (strong, nonatomic) FMDatabase *db;

+ (DBHelper *)sharedInstance;

//square
- (BOOL)insertOrUpdateSquareStr:(NSString *)square gmid:(NSString *)gmid;

- (NSArray *)getSquareMessage;

//account
- (BOOL)insertOrUpdateAccount:(AccountData *)account;

- (AccountData *)getAccountByID:(NSString *)accountID;

- (AccountData *)getAccountByPhone:(NSString *)phone;

- (NSArray *)getAccountByGid:(NSString *)gid;

//chatmess
- (BOOL)insertChatMess:(ChatMessData *)mess;

- (NSArray *)getChatMessesCurPhone:(NSString *)curPhone
                    andFriendPhone:(NSString *)friendPhone;

- (NSArray *)getChatMessesByGid:(NSString *)gid;

- (BOOL)updateChatMessesHadReadCurGid:(NSString *)gid;

- (BOOL)updateChatMessesHadReadCurPhone:(NSString *)curPhone
                         andFriendPhone:(NSString *)friendPhone;

- (NSInteger)getSumUnReadByGid:(NSString *)gid;

- (NSInteger)getSumUnReadCurPhone:(NSString *)curPhone
                   andFriendPhone:(NSString *)friendPhone;

- (BOOL)deleteChatMessesById:(int)index;

- (BOOL)deleteChatMessesAll;

//当前用户的最新一条会话列表
- (NSArray *)getLastChatMessAryCurPhone:(NSString *)curPhone;

@end
