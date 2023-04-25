//
//  DBAreaModel.h
//  BGYUni
//
//  Created by BGY on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "DBProjectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBAreaModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *areaId;
@property(nonatomic ,copy) NSString *areaCode;
@property(nonatomic ,copy) NSString *areaName;
@property(nonatomic ,assign) int status;
@property(nonatomic ,copy) NSArray <DBProjectModel *>*projectList;
@end



NS_ASSUME_NONNULL_END
