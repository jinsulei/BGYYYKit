//
//  BGYDataDictModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYDataDictModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *typeName;
@property(nonatomic ,copy) NSString *typeCode;
@property(nonatomic ,copy) NSString *dictKey;
@property(nonatomic ,copy) NSString *dictName;
@property(nonatomic ,copy) NSString *enable;
@end

NS_ASSUME_NONNULL_END
