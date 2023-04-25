//
//  DBProjectModel.h
//  BGYUni
//
//  Created by BGY on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBProjectModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *areaId;
@property(nonatomic ,copy) NSString *projectId;
@property(nonatomic ,copy) NSString *projectCode;
@property(nonatomic ,copy) NSString *projectName;
@property(nonatomic ,assign) int status;
@end

NS_ASSUME_NONNULL_END
