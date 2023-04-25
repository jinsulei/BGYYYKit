//
//  BGYSystemLogModel.h
//  BGYUni
//
//  Created by lshenrong on 2022/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYSystemLogModel : NSObject

@property (nonatomic, strong) NSString *arg0;
@property (nonatomic, strong) NSString *arg1;
@property (nonatomic, strong) NSString *arg2;
@property (nonatomic, strong) NSString *arg3;
@property (nonatomic, strong) NSString *arg4;
@property (nonatomic, strong) NSString *arg5;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *upcast;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *create_by;
@property (nonatomic, assign) NSUInteger upload_id;

@end

NS_ASSUME_NONNULL_END
