//
//  UserInfoConfig.h
//  BGYDBManager
//
//  Created by BGY-XC on 2023/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoConfig : NSObject
+ (instancetype)shareUserInfo;

///登录用户名
@property (nonatomic, copy, nullable) NSString *loginUserId;
///当前位置信息
//@property (nonatomic, copy, nullable) NSString *locateText;
@end

NS_ASSUME_NONNULL_END
