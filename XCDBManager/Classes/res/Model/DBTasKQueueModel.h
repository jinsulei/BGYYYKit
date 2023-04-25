//
//  DBTasKQueueModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTasKQueueModel : NSObject

@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *nodeId;
@property(nonatomic ,copy) NSString *targetEntityI;
@property(nonatomic ,copy) NSString *nodeName;
@property(nonatomic ,copy) NSString *nodeParentName;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *create_time;
@property(nonatomic ,copy) NSString *update_time;

@property(nonatomic ,copy) NSString *status;
@property(nonatomic ,copy) NSString *create_by;
@property(nonatomic ,copy) NSString *update_by;
@property(nonatomic ,copy) NSString *period;



@end

NS_ASSUME_NONNULL_END
