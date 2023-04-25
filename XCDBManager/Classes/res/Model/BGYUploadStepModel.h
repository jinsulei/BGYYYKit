//
//  BGYUloadStepModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/18.
//

#import <Foundation/Foundation.h>
#import "BGYFileModel.h"

NS_ASSUME_NONNULL_BEGIN






@interface BGYUloadDataModel : NSObject

@property(nonatomic ,copy) NSString *grainLevel;
@property(nonatomic ,copy) NSString *nodeId;
@property(nonatomic ,copy) NSString *fileHashKey;
@property(nonatomic ,copy) NSString *stageId;
@property(nonatomic ,copy) NSString *entityId;
@property(nonatomic ,copy) NSString *entityType;
@property(nonatomic ,copy) NSString *content;
@property(nonatomic ,strong)NSString *targetEntities;
@property(nonatomic ,strong) NSMutableArray <BGYFileModel *>*files;
@property(nonatomic ,copy) NSString *submitType;
@property(nonatomic ,copy) NSString *lastBatchId;
@property(nonatomic ,copy) NSString *createTime;
@property(nonatomic ,copy) NSString *electionDate;
//最后一个
@property(nonatomic ,copy) NSString *projectId;


@end


@interface BGYUploadStepModel : NSObject

@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,strong) BGYFileModel *file;
@property(nonatomic ,copy) NSString *api;
@property(nonatomic ,strong) NSMutableDictionary *data;
@property(nonatomic ,copy) NSString *funName;
@property(nonatomic ,copy) NSString *materialName;


@end






NS_ASSUME_NONNULL_END
