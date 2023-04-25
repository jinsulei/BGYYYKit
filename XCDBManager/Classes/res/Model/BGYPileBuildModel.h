//
//  BGYPileBuildModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYPileBuildModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *projectId;
@property(nonatomic ,copy) NSString *projectCode;
@property(nonatomic ,copy) NSString *secondaryBuildingId;
@property(nonatomic ,copy) NSString *secondaryBuildingCode;
@property(nonatomic ,copy) NSString *secondaryBuildingName;
@property(nonatomic ,copy) NSString *virtualBuilding;
@property(nonatomic ,copy) NSString *hasPileImg;
@property(nonatomic ,copy) NSString *hasPileno;
@property(nonatomic ,copy) NSArray *details;
@end

NS_ASSUME_NONNULL_END
