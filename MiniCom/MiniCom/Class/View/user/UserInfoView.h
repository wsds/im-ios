//
//  UserInfoView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView
{
    UIImageView *icon;
    
    UILabel *nameLb;
    
    UILabel *uidLb;
    
    UILabel *telLb;
    
    UILabel *sexLb;
    
    UILabel *busLb;
}

- (void)updateUserImage:(NSString *)imageName
               nickName:(NSString *)nickName
                    uid:(NSString *)uid
                    tel:(NSString *)tel
                    sex:(NSString *)sex
               business:(NSString *)business;

- (void)updateGroupImage:(NSString *)imageName
               groupName:(NSString *)groupName
                     uid:(NSString *)uid
             description:(NSString *)description;

@end
