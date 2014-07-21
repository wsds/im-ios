//
//  Params4Http.m
//  MiniCom
//
//  Created by wlp on 14-5-19.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Params4Http.h"

@implementation Params4Http

- (id)initWithUrl:(NSString *)url
           params:(NSDictionary *)params
              tag:(NSInteger)tag
          needHud:(BOOL)needHud
          hudText:(NSString *)hudText
        needLogin:(BOOL)needLogin
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.url = url;
        self.params = params;
        self.tag = tag;
        self.needLogin = needLogin;
        self.needHud = needHud;
        self.hudText = hudText;
    }
    return self;
}

@end
