//
//  SquareManager.h
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SquareMessData.h"
#import "SquareContentData.h"

typedef enum {
    E_ShowView_Square_JingHua = 0,
    E_ShowView_Square_QuanBu = 1,
    E_ShowView_Square_HuoDong = 2,
    E_ShowView_Square_Tucao = 3,
}E_ShowView_Square;

@interface SquareManager : NSObject

@property(nonatomic, assign) NSString *squareFlag;

@property(nonatomic, retain) NSArray *square_jinghua_ary;

@property(nonatomic, retain) NSArray *square_quanbu_ary;

@property(nonatomic, retain) NSArray *square_huodong_ary;

@property(nonatomic, retain) NSArray *square_tucao_ary;

+ (SquareManager *)SharedInstance;

- (NSArray *)getSquareMessWithType:(E_ShowView_Square)type;

@end
