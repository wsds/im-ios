//
//  SquareManager.m
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareManager.h"

@implementation SquareManager

static SquareManager *object = nil;

+ (SquareManager *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[SquareManager alloc] init];
        }
    }
    return object;
}

- (id)init
{
    self = [super init];
    if (self){

    }
    return  self;
}

- (NSArray *)getSquareMessWithType:(E_ShowView_Square)type
{
    switch (type) {
        case E_ShowView_Square_JingHua:
            return self.square_jinghua_ary;
            break;
        case E_ShowView_Square_QuanBu:
            return self.square_quanbu_ary;
            break;
        case E_ShowView_Square_HuoDong:
            return self.square_huodong_ary;
            break;
        case E_ShowView_Square_Tucao:
            return self.square_tucao_ary;
            break;
        default:
            break;
    }
    return nil;
}

@end
