//
//  UserInfoConfig.m
//  BGYDBManager
//
//  Created by BGY-XC on 2023/4/24.
//

#import "UserInfoConfig.h"

@implementation UserInfoConfig
+ (instancetype)shareUserInfo
{
    static UserInfoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoConfig alloc] init];
    });
    return instance;
}
@end
