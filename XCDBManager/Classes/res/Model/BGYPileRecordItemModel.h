//
//  BGYPileRecordItemModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/7.
//

#import <Foundation/Foundation.h>
#import "BGYPileDynamicFormModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGYPileRecordItemModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *pileId;
@property(nonatomic ,copy) NSString *pilingRecordId;
@property(nonatomic ,copy) NSString *itemGroupName;
@property(nonatomic ,copy) NSString *itemGroupCode;
@property(nonatomic ,copy) NSString *parentId;
@property(nonatomic ,copy) NSString *parentId2;
@property(nonatomic ,assign) NSInteger mustNotNull;
@property(nonatomic ,copy) NSString *status;
@property(nonatomic ,assign) NSInteger num;
@property(nonatomic ,copy) NSString *groupType;
@property(nonatomic ,copy) NSString *editRoles;
@property(nonatomic ,assign) NSInteger repeatMax;
@property(nonatomic ,copy) NSString *groupBillStatus;
@property(nonatomic ,copy) NSString *submitRoles;
@property(nonatomic ,copy) NSString *updateRoles;
@property(nonatomic ,assign) NSInteger orderNum;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *pid;
@property(nonatomic ,copy) NSArray<BGYPileRecordItemModel *> *children;
@property(nonatomic ,copy) NSArray<BGYPileDynamicFormModel *> *dynamicFormFields;
@end


NS_ASSUME_NONNULL_END
