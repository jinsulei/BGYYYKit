//
//  BGYPileRecordModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/7.
//

#import <Foundation/Foundation.h>
#import "BGYPileRecordItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGYPileRecordModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *pileId;
@property(nonatomic ,copy) NSString *pilingRecordId;
@property(nonatomic ,copy) NSString *businessName;
@property(nonatomic ,copy) NSString *businessId;
@property(nonatomic ,copy) NSString *formName;
@property(nonatomic ,copy) NSString *formVersion;
@property(nonatomic ,copy) NSString *formCode;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *formBusiGroupCode;
@property(nonatomic ,copy) NSString *formBusiGroupName;
@property(nonatomic ,copy) NSString *hasWorkCheck;
@property(nonatomic ,copy) NSString *hasInvalidatedPile;
@property(nonatomic ,copy) NSString *anbleInvalidatedPile;
@property(nonatomic ,copy) NSString *pid;
@property(nonatomic ,copy) NSString *flowId;
@property(nonatomic ,copy) NSString *flowUrl;
@property(nonatomic ,copy) NSString *flowNo;
//@property(nonatomic ,copy) NSArray *groupItem;
@end

NS_ASSUME_NONNULL_END
