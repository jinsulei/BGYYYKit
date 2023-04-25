//
//  BGYDataManager.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/1.
//

#import <Foundation/Foundation.h>


#define Notification_UniOfflineUploadCountStatus       @"offlineQueueCountByStatus"

NS_ASSUME_NONNULL_BEGIN
@class DBConcreteRequestModel;
@class DBImageModel;
@class DBProjectModel;
@class DBAreaModel;
@class UserOperationModel;
@class BGYPileRecordModel;
@class BGYPileRecordItemModel;
@class BGYPileDynamicFormModel;
@class BGYPileBuildModel;
@class BGYPileNoModel;
@class BGYPileConstantModel;

@interface BGYDataManager : NSObject

+ (instancetype)shareDataManager;
+ (instancetype)shareBGYPackageeDataManager;

/**
 *  根据用户名获取PackageList
 */
- (void)selectBGYPackageList:(NSString *)userName  finish:(void (^)(NSArray *stepArr))finish;
/**
 *  根据用户获取离线任务队列列表 OfflineQueueList
 */
- (void)selectOfflineQueueListCountByUserId:(NSString *)userId finish:(void (^)(id result))finish;
- (void)selectOfflineQueueListByUserName:(NSString *)userName finish:(void (^)(NSArray *stepArr))finish;

/**
 *  查询数据库里面的日志,支持分页查询
 */
- (void)selectHistoryLogListByUserName:(NSString *)userName pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize finish:(void (^)(NSArray *historyArr))finish;

/**
 *  插入离线任务
 */
- (void)insertOfflineQueueDataMessage:(DBConcreteRequestModel *)model;
/**
 *  根据thekey 更新离线任务 step和status
 */
- (void)updateOfflineQueueDataMessageByStepData:(NSString *)step StepStatus:(NSString *)status Key:(NSString *)theKey;
/**
 *  根据thekey 更新离线任务 status
 */
- (void)updateOfflineQueueDataStatusBykey:(NSString *)theKey StepStatus:(NSString *)status;
/**
 *  根据sqlString 进行数据库操作
 *  分两种情况 select 和 非 select语句
 *  没有权限限制，当心使用
 */
- (void)excuteSQL:(NSString *)sqlString finish:(void (^)(id result))finish;
/**
 *  日志相关操作，暂未使用
 */
- (void)insertOfflineWeblog:(NSString *)msg api:(NSString *)api leve:(NSInteger)level;

- (void)deleteWebLogDataOutOfWeek;
///上传日志
- (void)selectHistoryLogListByPageSize:(NSInteger)pageSize;

/**
 *  离线任务，根据thekey，添加错误信息
 */
- (void)insertOfflineQueueErrorMessage:(NSString *)message theKey:(NSString *)theKey;


/**
 *  ****************************桩基相关************************************
 */

/**
 *  清除所有表单数据缓存
 */
- (void)ClearAllCaches;
- (void)insertPileRecordItemData2:(BGYPileRecordItemModel *)model;
- (void)insertPiledynamicFormData2:(BGYPileDynamicFormModel *)model;
/**
 *  根据pileId清空桩基缓存数据
 */
- (BOOL)deletePilerecordByPileId:(NSString *)pileId;
/**
 *  清除所有装机表单数据缓存
 */
- (void)ClearPileCaches;
- (void)deleteDataAuthority:(NSString *)fieldid;
- (void)updatedynamicForm:(NSString *)id   fieldValue:(NSString *)fieldValue  tempValue:(NSString *)tempValue;
- (void)deletePileNoData:(NSString *)pileId;
- (NSMutableString *)selectPiledynamicFormByPileId:(NSString *)pileId;
- (NSString *)selectPileDataByPileId:(NSString *)pileId;
- (void)updatePilerecorditemByStatus:(NSString *)id   groupBillStatus:(NSString *)groupBillStatus;
- (void)insertDataAuthority:(NSDictionary *)dic;
- (NSString *)selectDataAuthorityByKey:(NSString *)Key;
- (void)selectPileConstantById:(NSString *)Id   finish:(void (^)(NSArray *stepArr))finish;
- (void)selectPileDynamicFormByCode:(NSDictionary *)dic   finish:(void (^)(NSArray *stepArr))finish;
- (void)deletePileConstantDataById:(NSString *)Id;
- (void)insertPileConstantData:(BGYPileConstantModel *)model;
- (void)selectBuildPileNoBybuildId:(NSString *)Id finish:(void (^)(NSArray *stepArr))finish;
- (void)selectBuildListById:(NSString *)projectId finish:(void (^)(NSArray *stepArr))finish;
- (void)deletePileBuildData:(NSString *)projectid;
- (void)insertPileBuildData:(BGYPileBuildModel *)model;
- (void)insertPileNoData:(BGYPileNoModel *)model;
- (NSString *)selectDataDictByKey:(NSString *)dictKey;
- (NSString *)selectPileEmptyForm:(NSString *)pileTypeId;
- (void)insertPileEmptyForm:(NSDictionary *)dic;
- (void)deletePileEmptyForm;
- (void)deletedataDict;
- (void)insertdatadict:(NSDictionary *)dic;
- (void)selectUserOperationByappid:(NSString *)appid  code:(NSString *)code finish:(void (^)(NSArray *stepArr))finish;
- (void)deletedynamicFormById:(NSString *)Id  type:(NSString *)type;
- (void)selectdynamicFormById:(NSString *)Id  type:(NSString *)type  finish:(void (^)(NSArray *stepArr))finish;
- (void)selectPileRecordDataByRecordId:(NSString *)recordId finish:(void (^)(NSArray *stepArr))finish;
- (void)selectPileRecordItemByRecordId:(NSString *)recordId  parentId:(NSString *)parentId  finish:(void (^)(NSArray *stepArr))finish;
- (void)insertPiledynamicFormData:(BGYPileDynamicFormModel *)model;
- (void)insertPileRecordItemData:(BGYPileRecordItemModel *)model;
- (void)insertPileRecordData:(BGYPileRecordModel *)model;
- (void)insertUserOperationData:(UserOperationModel *)model;
- (void)deleteUserOperationData;
- (void)insertAreaData:(DBAreaModel *)model;
- (void)insertProjectData:(DBProjectModel *)model;
- (void)updateProjectStatusByprojectId:(NSString *)projectId;
// 更新项目选中状态
- (void)updateAreaProjectStatus:(NSString *)projectName;
- (void)selectAreaListByareaname:(NSString *)areaname finish:(void (^)(NSArray *stepArr))finish;
- (void)selectProjectListByareaId:(NSString *)areaId  projectName:(NSString *)projectName finish:(void (^)(NSArray *stepArr))finish;
- (void)selectOfflineQueueListCountByUserId2:(NSString *)userId finish:(void (^)(NSArray *stepArr))finish;
@end


@interface BGYDataManager (ImageCache)

- (void)selectOfflineImgList:(void (^)(NSArray <DBImageModel *> *modelArr))finish;
- (NSArray <DBImageModel *> *)selectOfflineImgList;

- (void)selectAllImagesDateBefore:(NSTimeInterval)createTime result:(void (^)(NSArray <DBImageModel *> *modelArr))finish;

- (void)selectOfflineImgByPath:(DBImageModel *)model finish:(void (^)(DBImageModel * imageModel))finish;

- (void)insertOffineImage:(DBImageModel *)model finish:(void(^)(BOOL success, NSError *error))finishBlock;

- (void)updateOfflineImage:(DBImageModel *)model;

//移除图片文件
- (void)removeImageWithRelatePath:(NSString *)path finish:(nullable void(^)(BOOL success, NSError *error))finishBlock;

- (void)deleteOfflineQueueDataOutOfMonth;

- (void)clearAlImagesBefore:(NSTimeInterval)createTime result:(nullable void (^)(NSArray <DBImageModel *> * _Nullable modelArr))finish;

- (void)clearImageTable;
@end

NS_ASSUME_NONNULL_END
