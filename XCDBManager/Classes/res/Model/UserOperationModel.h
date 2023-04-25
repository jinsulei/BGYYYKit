//
//  UserOperationModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserOperationModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *resourceType;
@property(nonatomic ,copy) NSString *appId;
@property(nonatomic ,copy) NSString *remarks;
@property(nonatomic ,copy) NSString *code;
@end

NS_ASSUME_NONNULL_END
