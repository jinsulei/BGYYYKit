//
//  BGYPileNoModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYPileNoModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *secondaryBuildingId;
@property(nonatomic ,copy) NSString *projectId;
@property(nonatomic ,copy) NSString *pileId;
@property(nonatomic ,copy) NSString *pileNo;
@property(nonatomic ,copy) NSString *pileTypeId;
@property(nonatomic ,copy) NSString *pileTypeName;
@property(nonatomic ,copy) NSString *pilingStatus;
@property(nonatomic ,copy) NSString *hasRefPile;
@property(nonatomic ,copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
