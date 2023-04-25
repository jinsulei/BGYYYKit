//
//  DBPileOfflineDataModel.h
//  BGYUni
//
//  Created by BGY on 2022/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBPileOfflineDataModel : NSObject

@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *name;
@property(nonatomic ,copy) NSString *path;
@property(nonatomic ,copy) NSString *status;
@property(nonatomic ,copy) NSString *version;
@property(nonatomic ,copy) NSString *username;
@property(nonatomic ,copy) NSString *requesturl;
@property(nonatomic ,copy) NSString *method;
@property(nonatomic ,copy) NSString *requestparams;
@property(nonatomic ,copy) NSString *createtime;
@end

NS_ASSUME_NONNULL_END
