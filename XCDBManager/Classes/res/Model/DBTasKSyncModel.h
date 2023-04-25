//
//  DBTasKSyncModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTasKSyncModel : NSObject

@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *data;
@property(nonatomic ,copy) NSString *status;
@property(nonatomic ,copy) NSString *tried_times;
@property(nonatomic ,copy) NSString *last_error;
@property(nonatomic ,copy) NSString *create_time;
@property(nonatomic ,copy) NSString *update_time;
@property(nonatomic ,copy) NSString *create_by;
@property(nonatomic ,copy) NSString *update_by;
@property(nonatomic ,copy) NSString *attr;

@end

NS_ASSUME_NONNULL_END
