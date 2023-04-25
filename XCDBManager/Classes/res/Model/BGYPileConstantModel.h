//
//  BGYPileConstantModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYPileConstantModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *deleteTag;
@property(nonatomic ,copy) NSString *tenantId;
@property(nonatomic ,copy) NSString *secondaryBuildingId;
@property(nonatomic ,copy) NSString *pileNo;
@property(nonatomic ,copy) NSString *pilingStatus;
@property(nonatomic ,copy) NSString *pileTypeId;
@property(nonatomic ,copy) NSString *pileTypeName;
@property(nonatomic ,copy) NSString *pileModel;
@property(nonatomic ,copy) NSString *concreteGrade;
@property(nonatomic ,assign) NSInteger groundElevationValue;
@property(nonatomic ,assign) NSInteger pileTopElevationValue;
@property(nonatomic ,assign) NSInteger pileDiameter;
@property(nonatomic ,assign) NSInteger coordinateX;
@property(nonatomic ,assign) NSInteger coordinateY;
@property(nonatomic ,assign) NSInteger simpleElevationValue;
@property(nonatomic ,assign) NSInteger depthIntoBearingStratum;
@property(nonatomic ,assign) NSInteger effectivePileLength;
@property(nonatomic ,assign) NSInteger reinforcementCageSize;
@property(nonatomic ,assign) NSInteger casingElevationValue;
@property(nonatomic ,copy) NSString *voidedPileNo;
@property(nonatomic ,copy) NSString *supplement;
@property(nonatomic ,copy) NSString *templateType;
@end

NS_ASSUME_NONNULL_END
