//
//  Params4Http.h
//  MiniCom
//
//  Created by wlp on 14-5-19.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Params4Http : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *params;
@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL needHud;
@property (strong, nonatomic) NSString *hudText;
@property (nonatomic) BOOL needLogin;

- (id)initWithUrl:(NSString *)url
           params:(NSDictionary *)params
              tag:(NSInteger)tag
          needHud:(BOOL)needHud
          hudText:(NSString *)hudText
        needLogin:(BOOL)needLogin;
@end
