//
//  DBConcreteRequestModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBConcreteRequestModel : NSObject

@property(nonatomic ,copy) NSString *thekey;
@property(nonatomic ,copy) NSString *thegroup;
@property(nonatomic ,copy) NSString *steps;
@property(nonatomic ,copy) NSString *display;
@property(nonatomic ,copy) NSString *nodeParentName;
@property(nonatomic ,copy) NSString *status;
@property(nonatomic ,copy) NSString *create_time;
@property(nonatomic ,copy) NSString *update_time;
@property(nonatomic ,copy) NSString *owner_user;

@end

NS_ASSUME_NONNULL_END
