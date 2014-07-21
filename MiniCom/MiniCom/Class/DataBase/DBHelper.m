//
//  DBHelper.m
//  t0705_refresh
//
//  Created by tt on 13-3-31.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import "DBHelper.h"
#import "DBFileManager.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

// /Users/wanglipeng/Library/Application Support/iPhone Simulator/7.1/Applications/093EBDBD-7E44-446F-8C72-EBB64D03AC40/Documents/

static DBHelper *gSharedInstance = nil;

@implementation DBHelper

+ (DBHelper *)sharedInstance
{
    @synchronized(self)
    {
        if (gSharedInstance == nil)
			gSharedInstance = [[DBHelper alloc] init];
    }
    return gSharedInstance;
}

- (id)init
{
    self = [super init];
    if (self){
        // 创建数据库
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[DBFileManager dbFilePath]];
        //self.db = [FMDatabase databaseWithPath:[DBFileManager dbFilePath]];
        
        [self createTable4ChatLog];
        [self createTable4Account];
        [self createTable4Square];
    }
    return  self;
}

//////////////////////////////////////// tab_Square
- (BOOL)createTable4Square{
    __block BOOL f = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        f = [db executeUpdate:@"create table if not exists tab_square"
             "(gmid text primary key,"
             "squareDicStr text not null)"
             ];
    }];
    [self.dbQueue close];
    return f;
}

- (BOOL)insertOrUpdateSquareStr:(NSString *)square gmid:(NSString *)gmid
{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"REPLACE into tab_square(gmid, squareDicStr) values (? ,?)";
        f = [db executeUpdate:sql,
             gmid,
             square];
        if (f) {
            //NSLog(@"REPLACE true");
        }
        else
        {
            NSLog(@"REPLACE false");
        }
    }];
    [self.dbQueue close];
    return f;
}

- (NSArray *)getSquareMessage
{
    NSMutableArray *ary = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select squareDicStr from tab_square";
        //NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            NSString *dicStr = [set stringForColumnIndex:0];
            if (dicStr) {
                [ary addObject:dicStr];
            }
        }
    }];
    [self.dbQueue close];
    return ary;
}

//////////////////////////////////////// tab_Account
- (BOOL)createTable4Account{
    __block BOOL f = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        f = [db executeUpdate:@"create table if not exists tab_account"
             "(_id integer primary key autoincrement,"
             "ID text not null,"
             "byPhone text,"
             "friendStatus text,"
             "head text,"
             "mainBusiness text,"
             "nickName text,"
             "phone text not null,"
             "sex text not null,"
             "userBackground text,"
             "gid text)"
             ];
    }];
    [self.dbQueue close];
    return f;
}

- (BOOL)insertOrUpdateAccount:(AccountData *)account{
    
    AccountData *dbAccount = [self getAccountByID:account.ID];

    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([dbAccount.ID isEqualToString:account.ID]) {
            NSString *sql = @"update tab_account set byPhone = ?, friendStatus = ?, head = ?, mainBusiness = ?, nickName = ?, phone = ?, sex = ?, userBackground = ?, gid = ? where ID = ?";
            f = [db executeUpdate:sql,
                 account.byPhone,
                 account.friendStatus,
                 account.head,
                 account.mainBusiness,
                 account.nickName,
                 account.phone,
                 account.sex,
                 account.userBackground,
                 account.gid,
                 account.ID];
            if (f) {
                //NSLog(@"updateAccount true");
            }
            else
            {
                NSLog(@"updateAccount false");
            }
        }
        else
        {
            NSString *sql = @"insert into tab_account(ID, byPhone, friendStatus, head, mainBusiness ,nickName ,phone, sex, userBackground, gid) values (? ,? ,?, ?, ?, ?, ?, ?, ?, ?)";
            f = [db executeUpdate:sql,
                 account.ID,
                 account.byPhone,
                 account.friendStatus,
                 account.head,
                 account.mainBusiness,
                 account.nickName,
                 account.phone,
                 account.sex,
                 account.userBackground,
                 account.gid];
            if (f) {
                //NSLog(@"insertAccount true");
            }
            else
            {
                NSLog(@"insertAccount false");
            }
        }
    }];
    [self.dbQueue close];
    return f;
}

- (AccountData *)getAccountByID:(NSString *)accountID
{
    AccountData *account = [[AccountData alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from tab_account where ID = %@", accountID];
        //NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            account.ID = [set stringForColumnIndex:1];
            account.byPhone = [set stringForColumnIndex:2];
            account.friendStatus = [set stringForColumnIndex:3];
            account.head = [set stringForColumnIndex:4];
            account.mainBusiness = [set stringForColumnIndex:5];
            account.nickName = [set stringForColumnIndex:6];
            account.phone = [set stringForColumnIndex:7];
            account.sex = [set stringForColumnIndex:8];
            account.userBackground = [set stringForColumnIndex:9];
            account.gid = [set stringForColumnIndex:10];
        }
    }];
    [self.dbQueue close];
    return account;
}

- (AccountData *)getAccountByPhone:(NSString *)phone
{
    AccountData *account = [[AccountData alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from tab_account where phone = %@", phone];
        //NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            account.ID = [set stringForColumnIndex:1];
            account.byPhone = [set stringForColumnIndex:2];
            account.friendStatus = [set stringForColumnIndex:3];
            account.head = [set stringForColumnIndex:4];
            account.mainBusiness = [set stringForColumnIndex:5];
            account.nickName = [set stringForColumnIndex:6];
            account.phone = [set stringForColumnIndex:7];
            account.sex = [set stringForColumnIndex:8];
            account.userBackground = [set stringForColumnIndex:9];
            account.gid = [set stringForColumnIndex:10];
        }
    }];
    [self.dbQueue close];
    return account;
}

- (NSArray *)getAccountByGid:(NSString *)gid
{
    NSMutableArray *ary = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from tab_account where gid = %@", gid];
        //NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            AccountData *account = [[AccountData alloc] init];
            account.ID = [set stringForColumnIndex:1];
            account.byPhone = [set stringForColumnIndex:2];
            account.friendStatus = [set stringForColumnIndex:3];
            account.head = [set stringForColumnIndex:4];
            account.mainBusiness = [set stringForColumnIndex:5];
            account.nickName = [set stringForColumnIndex:6];
            account.phone = [set stringForColumnIndex:7];
            account.sex = [set stringForColumnIndex:8];
            account.userBackground = [set stringForColumnIndex:9];
            account.gid = [set stringForColumnIndex:10];
            [ary addObject:account];
        }
    }];
    [self.dbQueue close];
    return ary;
}

//////////////////////////////////////// tab_callLog
- (BOOL)createTable4ChatLog{
    __block BOOL f = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        f = [db executeUpdate:@"create table if not exists tab_chatLog"
             "(_id integer primary key autoincrement,"
             "contentType text not null,"
             "sendType text not null,"
             "phone text not null,"
             "phoneToOrFrom text,"
             "content text not null,"
             "time text not null,"
             "isRead integer not null,"
             "isSend integer not null,"
             "gid text)"
             ];
    }];
    [self.dbQueue close];
    return f;
}

- (BOOL)insertChatMess:(ChatMessData *)log{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into tab_chatLog(contentType, sendType, phone, phoneToOrFrom, content ,time ,isRead, isSend, gid) values (? ,?, ?, ?, ?, ?, ?, ?, ?)";
        f = [db executeUpdate:sql,
             log.contentType,
             log.sendType,
             log.phone,
             log.phoneToOrFrom,
             log.content,
             log.time,
             [NSNumber numberWithInteger:log.isRead],
             [NSNumber numberWithInteger:log.isSend],
             log.gid];
    }];
    [self.dbQueue close];
    if (f) {
        NSLog(@"insertChatMess true");
    }
    else
    {
        NSLog(@"insertChatMess false");
    }
    return f;
}

- (NSArray *)getChatMessesCurPhone:(NSString *)curPhone
                    andFriendPhone:(NSString *)friendPhone
{
    NSMutableArray *ary = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from tab_chatLog where phone = %@ and sendType = \"%@\" order by _id", curPhone, @"point"];
        if (friendPhone && [friendPhone length] > 0) {
            sql = [NSString stringWithFormat:@"select * from tab_chatLog where phone = %@ and phoneToOrFrom = %@ and sendType = \"%@\" order by _id", curPhone, friendPhone, @"point"];
        }
        NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            ChatMessData *log = [[ChatMessData alloc] init];
            log.contentType = [set stringForColumnIndex:1];
            log.sendType = [set stringForColumnIndex:2];
            log.phone = [set stringForColumnIndex:3];
            log.phoneToOrFrom = [set stringForColumnIndex:4];
            log.content = [set stringForColumnIndex:5];
            log.time = [set stringForColumnIndex:6];
            log.isRead = [set intForColumnIndex:7];
            log.isSend = [set intForColumnIndex:8];
            //log.gid = [set stringForColumnIndex:9];
            [ary addObject:log];
        }
    }];
    [self.dbQueue close];
    return ary;
}

- (NSArray *)getChatMessesByGid:(NSString *)gid
{
    NSMutableArray *ary = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from tab_chatLog where gid = %@ and sendType = \"%@\" order by _id", gid, @"group"];
        NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            ChatMessData *log = [[ChatMessData alloc] init];
            log.contentType = [set stringForColumnIndex:1];
            log.sendType = [set stringForColumnIndex:2];
            log.phone = [set stringForColumnIndex:3];
            log.phoneToOrFrom = [set stringForColumnIndex:4];
            log.content = [set stringForColumnIndex:5];
            log.time = [set stringForColumnIndex:6];
            log.isRead = [set intForColumnIndex:7];
            log.isSend = [set intForColumnIndex:8];
            log.gid = [set stringForColumnIndex:9];
            [ary addObject:log];
        }
    }];
    [self.dbQueue close];
    return ary;
}


- (NSInteger)getSumUnReadByGid:(NSString *)gid
{
    __block NSInteger sum = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select count(_id) from tab_chatLog where isRead = 0 and sendType = \"%@\" and gid = %@", @"group", gid];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            sum = [set intForColumnIndex:0];
        }
    }];
    return sum;
}

- (BOOL)updateChatMessesHadReadCurPhone:(NSString *)curPhone
                         andFriendPhone:(NSString *)friendPhone
{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"update tab_chatLog set isRead = 1 where phone = ? and phoneToOrFrom = ?";
        f = [db executeUpdate:sql, curPhone, friendPhone];
    }];
    [self.dbQueue close];
    return f;
}

- (BOOL)updateChatMessesHadReadCurGid:(NSString *)gid
{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"update tab_chatLog set isRead = 1 where gid = ? and sendType = ?";
        f = [db executeUpdate:sql, gid, @"group"];
    }];
    [self.dbQueue close];
    return f;
}

- (NSInteger)getSumUnReadCurPhone:(NSString *)curPhone
                   andFriendPhone:(NSString *)friendPhone
{
    __block NSInteger sum = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select count(_id) from tab_chatLog where isRead = 0 and phone = \"%@\" and phoneToOrFrom = \"%@\"", curPhone, friendPhone];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            sum = [set intForColumnIndex:0];
        }
    }];
    return sum;
}

- (BOOL)deleteChatMessesById:(int)index{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from tab_chatLog where _id = ?";
        f = [db executeUpdate:sql,[NSNumber numberWithInteger:index]];
    }];
    [self.dbQueue close];
    return f;
}

- (BOOL)deleteChatMessesAll
{
    __block BOOL f = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from tab_chatLog";
        f = [db executeUpdate:sql];
    }];
    [self.dbQueue close];
    return f;
}

//
- (NSArray *)getLastChatMessAryCurPhone:(NSString *)curPhone
{
    NSMutableArray *ary = [NSMutableArray array];
    
    //point
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tab_chatLog WHERE phone = %@ And sendType = \"point\"  GROUP BY phoneToOrFrom ORDER BY _id DESC", curPhone];
        NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            ChatMessData *log = [[ChatMessData alloc] init];
            log.contentType = [set stringForColumnIndex:1];
            log.sendType = [set stringForColumnIndex:2];
            log.phone = [set stringForColumnIndex:3];
            log.phoneToOrFrom = [set stringForColumnIndex:4];
            log.content = [set stringForColumnIndex:5];
            log.time = [set stringForColumnIndex:6];
            log.isRead = [set intForColumnIndex:7];
            log.isSend = [set intForColumnIndex:8];
            log.gid = [set stringForColumnIndex:9];
            [ary addObject:log];
        }
    }];
    NSLog(@"point ary count==%d", [ary count]);
    [self.dbQueue close];
    
    //group
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tab_chatLog WHERE phone = %@ And sendType = \"group\"  GROUP BY gid ORDER BY _id DESC", curPhone];
        NSLog(@"sql==%@", sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            ChatMessData *log = [[ChatMessData alloc] init];
            log.contentType = [set stringForColumnIndex:1];
            log.sendType = [set stringForColumnIndex:2];
            log.phone = [set stringForColumnIndex:3];
            log.phoneToOrFrom = [set stringForColumnIndex:4];
            log.content = [set stringForColumnIndex:5];
            log.time = [set stringForColumnIndex:6];
            log.isRead = [set intForColumnIndex:7];
            log.isSend = [set intForColumnIndex:8];
            log.gid = [set stringForColumnIndex:9];
            [ary addObject:log];
        }
    }];
    NSLog(@"group ary count==%d", [ary count]);
    [self.dbQueue close];
    
    return ary;
}

@end

