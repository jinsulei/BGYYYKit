//
//  BGYDataManager.m
//  BGYUni
//
//  Created by lshenrong on 2021/11/1.
//

#import "BGYDataManager.h"
#import "BGYFileManager.h"
#import <FMDB/FMDB.h>
#import <BGYFoundation/BGYFoundation.h>
#import "DBConcreteRequestModel.h"
#import "DBImageModel+DBExtention.h"
//#import "jsonTool.h"
#import "BGYPhotoModel.h"
#import "NSDate+BGYExtention.h"
//#import "YTKNetworkConfig.h"
#import "BGYSystemLogModel.h"
//#import "UploadLogMessgeAPi.h"
#import "DBAreaModel.h"
#import "DBProjectModel.h"
#import "UserOperationModel.h"
#import "BGYPileRecordModel.h"
#import "BGYPileRecordItemModel.h"
#import "BGYDataDictModel.h"
#import "BGYPileDynamicFormModel.h"
#import "BGYPileBuildModel.h"
#import "BGYPileNoModel.h"
#import "BGYPileConstantModel.h"
#import <MJExtension/MJExtension.h>
#import "UserInfoConfig.h"
#import "FrameworkUtill.h"
#import "DBProjectModel.h"
#import "DBAreaModel.h"
#import "UserOperationModel.h"
#import "BGYPileRecordModel.h"
#import "BGYPileRecordItemModel.h"
#import "BGYPileDynamicFormModel.h"
#import "BGYPileBuildModel.h"
#import "BGYPileNoModel.h"
#import "BGYPileConstantModel.h"


static NSString * const BGYFileTableName = @"qms_unix_file_cache";
static NSString * const BGYGalleryTableName  = @"qms_gallery_cache";
static NSString * const BGYTasKQueueTableName = @"t_qms_queue_task";
static NSString * const BGYTasKSyncTableName = @"t_qms_sync_task";
static NSString * const BGYConcreteRequestTableName = @"qms_concrete_request";
static NSString * const BGYWeblogTableName = @"t_qms_weblog";


static NSString * const BGYAreaTableName = @"t_qms_area";
static NSString * const BGYProjectTableName = @"t_qms_project";
static NSString * const BGYUserOperation = @"t_qms_useroperation";
static NSString * const BGYPileRecord = @"t_qms_pilerecord";
static NSString * const BGYPileRecordItem = @"t_qms_pilerecorditem";
static NSString * const BGYPileDynamicForm =@"t_qms_dynamicForm";
static NSString * const BGYdataDictTypeCode =@"t_qms_datadict";
static NSString * const BGYdataAuthority = @"t_qms_dataauthority";
static NSString * const BGYPileBuild =@"t_qms_build";
static NSString * const BGYPileNo =@"t_qms_pileno";
static NSString * const BGYPileSetting =@"t_qms_pilesetting";
static NSString * const BGYPileEmptyForm =@"t_qms_pileemptyform";


static NSString * const BGYFileID = @"fileId";
static NSString * const BGYFileSize = @"fileSize";
static NSString * const BGYContentType = @"contentType";
static NSString * const BGYLocalPath = @"localPath";
static NSString * const BGYCreate_time = @"create_time";

static NSString * const BGYFileName = @"fileName";
static NSString * const BGYThumbFile = @"thumbFile";
static NSString * const BGYPreviewFile = @"previewFile";
static NSString * const BGYOriginFile = @"originFile";
static NSString * const BGYUpdate_time = @"update_time";

static NSString * const BGYId = @"id";
static NSString * const BGYNodeId = @"nodeId";
static NSString * const BGYTargetEntityId= @"targetEntityId";
static NSString * const BGYNodeName = @"nodeName";
static NSString * const BGYNodeParentName = @"nodeParentName";
static NSString * const BGYType = @"type";
static NSString * const BGYStatus = @"status";
static NSString * const BGYCreate_by = @"create_by";
static NSString * const BGYUpdate_by = @"update_by";
static NSString * const BGYPeriod = @"period";


static NSString * const BGYTried_times = @"tried_times";
static NSString * const BGYLast_error  = @"last_error";
static NSString * const BGYAttr = @"attr";

static NSString * const BGYThekey = @"thekey";
static NSString * const BGYThegroup  = @"thegroup";
static NSString * const BGYSteps = @"steps";
static NSString * const BGYDisplay  = @"display";
static NSString * const BGYOwner_user = @"owner_user";

static NSString * const BGYArg0 = @"arg0";
static NSString * const BGYArg1 = @"arg1";
static NSString * const BGYArg2 = @"arg2";
static NSString * const BGYArg3 = @"arg3";
static NSString * const BGYArg4 = @"arg4";
static NSString * const BGYArg5 = @"arg5";
static NSString * const BGYLevel = @"level";
static NSString * const BGYUpcast = @"upcast";
static NSString * const BGYUploadStatus = @"upload_status";





static NSString * const BGYIExcuteDBTypeUpdate = @"update";
static NSString * const BGYIExcuteDBTypeSelect = @"select";


static NSString *const BGYDataManagerErrorDomain = @"com.bgyUni.BGYDataManager.ErrorDomian";

@interface BGYDataManager ()
{
    dispatch_queue_t _callQueue;
}
@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) FMDatabaseQueue *FMDatabaseQueue;
@property (nonatomic, assign) BOOL isExcuteChecking;

@end


@implementation BGYDataManager

+ (instancetype)shareDataManager
{
    static BGYDataManager *_DataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DataManager = [[BGYDataManager alloc] init];
        _DataManager.isExcuteChecking = 0;
        NSString *dataPath = [BGYFileManager pathForLibraryDirectoryWithPath:@"/APPData/qms_offline_queue.db"];
        
        BGYLog(@"DB PATH -----%@",dataPath);
        if (![BGYFileManager existsItemAtPath:dataPath]) {
            [BGYFileManager createDirectoriesForPath:[BGYFileManager pathForLibraryDirectoryWithPath:@"/APPData/"]];
            _DataManager.dataBase = [FMDatabase databaseWithPath:dataPath];
            _DataManager.FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
            
        } else {
            _DataManager.dataBase = [FMDatabase databaseWithPath:dataPath];
            _DataManager.FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
            
        }
        //表添加字段
        [_DataManager addClomn];
        [_DataManager creatTable:_DataManager.dataBase];
        
        
        
    });
    return _DataManager;
}

+ (instancetype)shareBGYPackageeDataManager
{
    static BGYDataManager *_DataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DataManager = [[BGYDataManager alloc] init];
        _DataManager.isExcuteChecking = 0;
        NSString *dataPath = [BGYFileManager pathForDocumentsDirectoryWithPath:@"/BGYApps/bgy_package_cache.db"];
        BGYLog(@"DB PATH -----%@",dataPath);
        if (![BGYFileManager existsItemAtPath:dataPath]) {
            [BGYFileManager createDirectoriesForPath:[BGYFileManager pathForDocumentsDirectoryWithPath:@"/BGYApps/"]];
            _DataManager.dataBase = [FMDatabase databaseWithPath:dataPath];
            _DataManager.FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
            
        } else {
            _DataManager.dataBase = [FMDatabase databaseWithPath:dataPath];
            _DataManager.FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
            
        }
        //表添加字段
        [_DataManager addClomn];
        [_DataManager creatTable:_DataManager.dataBase];
        
    });
    return _DataManager;
}




- (void)selectBGYPackageList:(NSString *)userName  finish:(void (^)(NSArray *stepArr))finish{
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareBGYPackageeDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = @"select appId,versionNumber from BGYPackageTable";
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            NSMutableArray *resultArr = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            
            [searchRS close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
            
        }];
    });
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _callQueue = dispatch_queue_create("com.bgyUni.BGYDataManager.Queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


//额外添加表字段
- (void)addClomn{
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            //新增error_description字段
            if (![fmdb columnExists:@"error_description" inTableWithName:BGYConcreteRequestTableName]) {
                NSString *updateSql = [NSString stringWithFormat: @"ALTER TABLE qms_concrete_request ADD COLUMN error_description text"];
                if ([fmdb open]) {
                    BOOL updateRES = [fmdb executeUpdate:updateSql];
                    if (!updateRES) {
                        NSLog(@"更新数据失败：Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    }
                }
            }
            //[fmdb columnExists:@"upload_status" inTableWithName:BGYWeblogTableName] &&
            if (![fmdb columnExists:@"upload_id" inTableWithName:BGYWeblogTableName] &&![fmdb columnExists:@"upload_status" inTableWithName:BGYWeblogTableName]) {
                [fmdb beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    if ([fmdb executeUpdate:@"ALTER TABLE t_qms_weblog RENAME TO temp_qms_weblog"]) {
                        
                        NSString *executeStr = @"create table  t_qms_weblog (\
                                                                                                                        arg0,\
                                                                                                                        arg1,\
                                                                                                                        arg2,\
                                                                                                                        arg3,\
                                                                                                                        arg4,\
                                                                                                                        arg5,\
                                                                                                                        level,\
                                                                                                                        create_time,\
                                                                                                                        create_by,\
                                                                                                                        upcast,\
                                                                                                                        upload_status INTEGER default 0,\
                                                                                                                        upload_id INTEGER PRIMARY KEY AUTOINCREMENT\
                                                                                                                        )";
                        
                        if ([fmdb executeUpdate:executeStr]) {
                            // 从旧数据表把旧数据插入新的数据表中
                            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_qms_weblog (arg0,arg1,arg2,arg3,arg4,arg5,level,create_time,create_by,upcast) select arg0,arg1,arg2,arg3,arg4,arg5,level,create_time,create_by,upcast from temp_qms_weblog"];
                            if ([fmdb executeUpdate:insertSql]) {
                                [fmdb executeUpdate:@"drop table temp_qms_weblog"];// 删除旧表
                                //                                   [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"t_qms_weblog"];// 标记已经升级
                            };
                            
                        }
                    }
                } @catch (NSException *exception) {
                    isRollBack = YES;
                    // 事务回退
                    [fmdb rollback];
                } @finally {
                    if (!isRollBack) {
                        // 事务提交
                        [fmdb commit];
                        [[BGYDataManager shareDataManager] selectHistoryLogListByPageSize:20];
                    }
                }
                
            }
        }];
    });
}


/**
 *  创建数据库表
 */
-(void)creatTable:(FMDatabase *)dataBase {
    if ([dataBase open]) {
        [self creatTable:dataBase WithName:BGYFileTableName];
        [self creatTable:dataBase WithName:BGYGalleryTableName];
        [self creatTable:dataBase WithName:BGYTasKQueueTableName];
        [self creatTable:dataBase WithName:BGYTasKSyncTableName];
        [self creatTable:dataBase WithName:BGYConcreteRequestTableName];
        [self creatTable:dataBase WithName:BGYWeblogTableName];
        [self creatTable:dataBase WithName:BGYOfflineImageTableName];
        [self creatTable:dataBase WithName:BGYPhotoModelTableName];
        [self creatTable:dataBase WithName:BGYAreaTableName];
        [self creatTable:dataBase WithName:BGYProjectTableName];
        [self creatTable:dataBase WithName:BGYUserOperation];
        [self creatTable:dataBase WithName:BGYPileRecord];
        [self creatTable:dataBase WithName:BGYPileRecordItem];
        [self creatTable:dataBase WithName:BGYPileDynamicForm];
        [self creatTable:dataBase WithName:BGYdataDictTypeCode];
        [self creatTable:dataBase WithName:BGYPileBuild];
        [self creatTable:dataBase WithName:BGYPileNo];
        [self creatTable:dataBase WithName:BGYPileSetting];
        [self creatTable:dataBase WithName:BGYPileEmptyForm];
        [self creatTable:dataBase WithName:BGYdataAuthority];
        
        
        [dataBase close];
    }
}

#pragma mark - Image table
-(void)creatTable:(FMDatabase *)dataBase WithName:(NSString *)name {
    if ([name isEqualToString:BGYOfflineImageTableName]) {
        NSString *tableCulom = [DBImageModel createTableSql];
        BOOL result =  [dataBase executeUpdate:tableCulom];
        if (!result) {
            BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
        }
    }
    else if([name isEqualToString:BGYFileTableName]) {
        NSString *tableCulom = @"create table if not exists qms_unix_file_cache (\
        fileId unique,\
        fileSize,\
        fileName,\
        contentType,\
        localPath,\
        create_time\
        )";
        [dataBase executeUpdate:tableCulom];
    }else if ([name isEqualToString:BGYGalleryTableName]){
        //建索引
        NSString *tableCulom = @"create table if not exists qms_gallery_cache (\
        fileId unique,\
        fileSize,\
        fileName,\
        contentType,\
        thumbFile,\
        previewFile,\
        originFile,\
        update_time\
        )";
        
        BOOL result =  [dataBase executeUpdate:tableCulom];
        if (result) {
            NSString *indexOne = @"create index if not exists IDX_GALLERY_UPTIME on qms_gallery_cache (update_time)";
            NSString *indexTwo = @"create index if not exists IDX_GALLERY_FILEID on qms_gallery_cache (fileId)";
            [dataBase executeUpdate:indexOne];
            [dataBase executeUpdate:indexTwo];
            
        }else {
            BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
        }
        
    }else if ([name isEqualToString:BGYTasKQueueTableName]) {
        NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_queue_task (id unique,nodeId,targetEntityId,nodeName,nodeParentName,type,data,status,create_time,update_time,create_by,update_by,period)";
        BOOL result =  [dataBase executeUpdate:tableCulom];
        if (!result) {
            BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
        }    }else if ([name isEqualToString:BGYTasKSyncTableName]) {
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_sync_task (id unique,type,data,status,tried_times,last_error,create_time,update_time,create_by,update_by,attr)";
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }else if ([name isEqualToString:BGYConcreteRequestTableName]) {
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS qms_concrete_request (thekey unique ,thegroup,steps,display,status,create_time,update_time,owner_user,error_description)";
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                NSString *indexOne = @"CREATE INDEX IF NOT EXISTS IDX_qms_concrete_request_THEGROUP on qms_concrete_request (thegroup)";
                NSString *indexTwo = @"CREATE INDEX IF NOT EXISTS IDX_qms_concrete_request_STATUS on qms_concrete_request (status)";
                NSString *indexThree = @"CREATE INDEX IF NOT EXISTS IDX_qms_concrete_request_UPTIME on qms_concrete_request (update_time)";
                
                BOOL res = [dataBase executeUpdate:indexOne];
                
                if (!res) {
                    BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
                }
                [dataBase executeUpdate:indexTwo];
                [dataBase executeUpdate:indexThree];
            }else {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
        else if ([name isEqualToString:BGYWeblogTableName]) {
            NSString *tableCulom = @"create table if not exists t_qms_weblog (\
         arg0,\
         arg1,\
         arg2,\
         arg3,\
         arg4,\
         arg5,\
         level,\
         create_time,\
         create_by,\
         upcast,\
         upload_status INTEGER default 0,\
         upload_id INTEGER PRIMARY KEY AUTOINCREMENT\
         )";
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
        else if ([name isEqualToString:BGYAreaTableName]){
            // 区域表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_area (id INTEGER PRIMARY KEY,areaId varchar(50),areaCode varchar(50),areaName varchar(200),status int)";
            
            NSString *tableindex=@"CREATE INDEX IF NOT EXISTS index_areaId on t_qms_area (areaId)";
          
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                [dataBase executeUpdate:tableindex];
            }
        }
    
        else if ([name isEqualToString:BGYProjectTableName]){
            // 项目表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_project (id INTEGER PRIMARY KEY,areaId varchar(50),projectId varchar(50),projectCode varchar(50),projectName varchar(200),status int)";
            
            NSString *tableindex=@"CREATE INDEX IF NOT EXISTS index_projectId on t_qms_project (projectId)";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                [dataBase executeUpdate:tableindex];
            }
        }
        else if ([name isEqualToString:BGYUserOperation]){
            // 用户权限表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_useroperation (id INTEGER PRIMARY KEY,resourceType varchar(50),appId varchar(50),remarks varchar(200),code varchar(200))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
        else if ([name isEqualToString:BGYPileEmptyForm]){
            // 空白模版
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_pileemptyform (id INTEGER PRIMARY KEY,filename varchar(50),pileTypeId varchar(50),version int,datetime varchar(50))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
    
        else if ([name isEqualToString:BGYdataDictTypeCode]){
            // 数据字典码表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_datadict (id INTEGER PRIMARY KEY,typeName varchar(100),typeCode varchar(100),dictKey varchar(50),dictName varchar(100),enable varchar(50))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
        else if ([name isEqualToString:BGYdataAuthority]){
            // 数据操作权限
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_dataauthority (id INTEGER PRIMARY KEY,fieldid varchar(100),fieldvalue varchar(200),createtime varchar(100),ext1 varchar(200),ext2 varchar(200))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
    
        else if ([name isEqualToString:BGYPileSetting]){
            // 桩基计算常量
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_pilesetting (id varchar(100),secondaryBuildingId varchar(50),deleteTag varchar(50),tenantId varchar(20),pileNo varchar(100),pilingStatus varchar(50),pileTypeId varchar(50),pileTypeName varchar(100),pileModel varchar(50),concreteGrade varchar(50),groundElevationValue int,pileTopElevationValue int,pileDiameter int,coordinateX int,coordinateY int,simpleElevationValue int,depthIntoBearingStratum int,effectivePileLength int,reinforcementCageSize int,casingElevationValue int,voidedPileNo varchar(50),supplement varchar(50),templateType varchar(50))";
            
          
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
    
        else if ([name isEqualToString:BGYPileBuild]){
            // 楼栋
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_build (id INTEGER PRIMARY KEY,projectId varchar(50),projectCode varchar(50),secondaryBuildingId varchar(100),secondaryBuildingCode varchar(100),secondaryBuildingName varchar(200),virtualBuilding varchar(50),hasPileImg varchar(50),hasPileno varchar(20))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
        }
        else if ([name isEqualToString:BGYPileNo]){
            // 桩号
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_pileno (id INTEGER PRIMARY KEY,projectId varchar(50),secondaryBuildingId varchar(100),pileId varchar(100),pileNo varchar(200),pileTypeId varchar(50),pileTypeName varchar(200),pilingStatus varchar(50),hasRefPile varchar(50),type varchar(50))";
            
            NSString *tableindex=@"CREATE INDEX IF NOT EXISTS index_pileid on t_qms_pileno (pileId)";
    
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                [dataBase executeUpdate:tableindex];
            }
        }
        else if ([name isEqualToString:BGYPileRecord]){
            // 桩基填报记录主表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_pilerecord (id varchar(50),pileId varchar(50),pilingRecordId varchar(50),businessName varchar(200),businessId varchar(50),formName varchar(200),formVersion varchar(50),formCode varchar(50),type varchar(20),hasWorkCheck varchar(20),hasInvalidatedPile varchar(20),anbleInvalidatedPile varchar(20),formBusiGroupCode varchar(100),formBusiGroupName varchar(100),pid varchar(50),flowId varchar(50),flowUrl varchar(500),flowNo varchar(50),ext1 varchar(100),ext2 varchar(200),ext3 varchar(200))";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (!result) {
                BGYLog(@"Error %d : %@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
            }
            
        }
        else if ([name isEqualToString:BGYPileRecordItem]){
            // 桩基填报记录桩类型表
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_pilerecorditem (id varchar(50),pileId varchar(50),pilingRecordId varchar(50),itemGroupName varchar(50),itemGroupCode varchar(50),parentId varchar(50),parentId2 varchar(50),mustNotNull int,status varchar(20),num int,groupType varchar(20),editRoles varchar(50),repeatMax int,groupBillStatus varchar(50),submitRoles varchar(200),updateRoles varchar(200),orderNum int,type varchar(20),pid varchar(50),ext1 varchar(100),ext2 varchar(200),ext3 varchar(200))";
            
            NSString *tableindex=@"CREATE INDEX IF NOT EXISTS index_pileid on t_qms_pilerecorditem (pileId)";
            
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                [dataBase executeUpdate:tableindex];
            }
            
        }
    
        else if ([name isEqualToString:BGYPileDynamicForm]){
            // 桩基填报单个桩表单
            
            NSString *tableCulom = @"CREATE TABLE IF NOT EXISTS t_qms_dynamicForm (id varchar(50),pileId varchar(50),pilingRecordId varchar(50),itemGroupName varchar(50),itemGroupCode varchar(50),parentId varchar(50),parentId2 varchar(50),fullCode varchar(200),mustNotNull int,status varchar(20),num int,fieldName varchar(100),fieldValue varchar(200),tempValue varchar(200),fieldCode varchar(50),fieldType varchar(50),repeatMax int,editRoles varchar(100),orderNum int,hasUpdate varchar(50),fieldDescribe varchar(200),fieldSelectParams varchar(100),fieldFormula varchar(200),fieldLength varchar(20),fieldSuffixDescribe varchar(100),valueRange varchar(50),oldFieldValue varchar(100),auditStatus varchar(50),createTime varchar(50),updateTime varchar(50),type varchar(20),pid varchar(50),num2 int,orderNum2 int,ext1 varchar(100),ext2 varchar(200),ext3 varchar(200))";
            
            NSString *tableindex=@"CREATE INDEX IF NOT EXISTS index_pileid on t_qms_dynamicForm (pileId)";
          
            BOOL result =  [dataBase executeUpdate:tableCulom];
            if (result) {
                [dataBase executeUpdate:tableindex];
            }
           
            
        }
    
    
}


#pragma mark - sql excute table sql---语句操作数据库

//分两种情况 select 和 非 select语句
- (void)excuteSQL:(NSString *)sqlString finish:(void (^)(id result))finish{
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSMutableArray *resultArr = [NSMutableArray array];
            NSString *frontString = [sqlString substringToIndex:15];
            if ([frontString  containsString:BGYIExcuteDBTypeSelect] || [frontString  containsString:BGYIExcuteDBTypeSelect.uppercaseString] ) {
                NSString *selectSql = sqlString;
                FMResultSet *searchRS = [fmdb executeQuery:selectSql];
                while ([searchRS next]) {
                    if ([searchRS resultDictionary]) {
                        [resultArr addObject:[searchRS resultDictionary]];
                    }
                }
                if (searchRS) {
                    if (finish) {
                        NSDictionary *resultDic = @{@"code" : @"success",@"data":resultArr};
                        finish([resultDic mj_JSONObject]);
                    }
                }else {
                    NSString *msg = [NSString stringWithFormat:@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]];
                    NSDictionary *resultStatus  = @{@"code" : @"fail",@"msg":msg};
                    if (finish) {
                        finish([resultStatus mj_JSONObject]);
                    }
                    
                }
                [searchRS close];
            }else {
                NSString *updateSql = sqlString;
                NSDictionary *resultStatus;
                BOOL updateRS = [fmdb executeUpdate:updateSql];
                if (updateRS) {
                    resultStatus  = @{@"code" : @"success"};
                }else {
                    NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    NSString *msg = [NSString stringWithFormat:@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]];
                    resultStatus  = @{@"code" : @"fail",@"msg":msg};
                }
                if (finish) {
                    finish([resultStatus mj_JSONObject]);
                }
            }
        }];
    });
    
}


#pragma mark - offline_queue table

- (void)updateOfflineQueueDataStatusBykey:(NSString *)theKey StepStatus:(NSString *)status {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *updateSql = [NSString stringWithFormat: @"update qms_concrete_request set status='%@' where thekey='%@'",status,theKey];
            if ([fmdb open]) {
                BOOL updateRES = [fmdb executeUpdate:updateSql];
                if (!updateRES) {
                    [fmdb close];
                    NSLog(@"更新数据失败...");
                    NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    
                } else {
                    [fmdb close];
                    NSLog(@"更新数据成功...");
                }
            }
            
        }];
    });
}

//插入错误信息
- (void)insertOfflineQueueErrorMessage:(NSString *)message theKey:(NSString *)theKey {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            //新增error_description字段
            if (message && theKey) {
                [self updateErrorMessage:message theKey:theKey];
            }
        }];
    });
}

- (void)updateErrorMessage:(NSString *)message theKey:(NSString *)theKey {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *updateSql = [NSString stringWithFormat: @"update qms_concrete_request set error_description ='%@' where thekey='%@'",message,theKey];
            if ([fmdb open]) {
                BOOL updateRES = [fmdb executeUpdate:updateSql];
                if (!updateRES) {
                    NSLog(@"更新数据失败Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    
                } else {
                    NSLog(@"更新数据成功...");
                }
                [fmdb close];
            }
        }];
    });
}


- (void)updateOfflineQueueDataMessageByStepData:(NSString *)step StepStatus:(NSString *)status Key:(NSString *)theKey  {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *updateSql = [NSString stringWithFormat: @"update qms_concrete_request set steps='%@', status='%@' where thekey='%@'",step,status,theKey];
            if ([fmdb open]) {
                BOOL updateRES = [fmdb executeUpdate:updateSql];
                if (!updateRES) {
                    [fmdb close];
                    NSLog(@"更新数据失败...");
                    NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    
                } else {
                    [fmdb close];
                    NSLog(@"更新数据成功...");
                }
            }
            
        }];
    });
}



//查询离线任务数量
- (void)selectOfflineQueueListCountByUserId:(NSString *)userId finish:(void (^)(id result))finish  {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSMutableArray *resultArr = [NSMutableArray array];
            NSString *selectSql = [NSString stringWithFormat:@"select count(1) cnt,status from qms_concrete_request where owner_user='%@' and status in ('-1','0','1') group by status",userId];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            while ([searchRS next]) {
                if ([searchRS resultDictionary]) {
                    [resultArr addObject:[searchRS resultDictionary]];
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (searchRS) {
                    if (finish) {
                        NSDictionary *resultDic = @{@"code" : @"success",@"data":resultArr,@"eventName":Notification_UniOfflineUploadCountStatus};
                        finish([resultDic mj_JSONObject]);
                    }
                }else {
                    NSString *msg = [NSString stringWithFormat:@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]];
                    NSDictionary *resultStatus  = @{@"code" : @"fail",@"msg":msg,@"eventName":Notification_UniOfflineUploadCountStatus};
                    if (finish) {
                        finish([resultStatus mj_JSONObject]);
                    }
                }
            });
            [searchRS close];
            
        }];
    });
}

//查询离线任务数量
- (void)selectOfflineQueueListCountByUserId2:(NSString *)userId finish:(void (^)(NSArray *stepArr))finish{

        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
           
            NSString *selectSql = [NSString stringWithFormat:@"SELECT thekey FROM `qms_concrete_request` where status!='9'"];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            NSMutableArray *resultArr = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            
        
            [searchRS close];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
        }];

}

//查询任务列表
- (void)selectOfflineQueueListByUserName:(NSString *)userName finish:(void (^)(NSArray *stepArr))finish{
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = [NSString stringWithFormat:@"select * from qms_concrete_request where owner_user='%@' and status in ('0','-1','1') order by update_time desc",userName];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            NSMutableArray *resultArr = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            if (!searchRS) {
                BGYLog(@"查询数据失败...");
            } else {
                BGYLog(@"查询数据成功...");
            }
            [searchRS close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
            
        }];
    });
}

- (void)UpdateOffLineImg:(DBImageModel *)model {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *updateSql = model.updateSql;
            BOOL updateRES = [fmdb executeUpdate:updateSql];
            if (!updateRES) {
                NSLog(@"更新数据失败...");
                NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                
            } else {
                NSLog(@"更新数据成功...");
            }
        }];
    });
}

//删除超过一个月的数据库系统日志
- (void)deleteWebLogDataOutOfWeek {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *userId = [UserInfoConfig shareUserInfo].loginUserId;
            if (userId) {
                NSTimeInterval timeStamp  = [FrameworkUtill daysAgo:7];
                NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_weblog where substr(create_time,0,14) < '%0.f' or create_time < '%0.f'  and upload_status = 1",timeStamp,timeStamp];
                BOOL  deleteRS = [fmdb executeUpdate:deleteSql];
                if (!deleteRS) {
                    BGYLog(@"删除一个星期前日志失败...");
                } else {
                    BGYLog(@"删除一个星期前日志成功...");
                }
            }
        }];
    });
}

//删除超过一个月的数据库数据
- (void)deleteOfflineQueueDataOutOfMonth {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *userId = [UserInfoConfig shareUserInfo].loginUserId;
            if (userId) {
                NSTimeInterval timeStamp  = [FrameworkUtill monthsAgo:1];
                NSString *deleteSql = [NSString stringWithFormat:@"delete from qms_concrete_request where owner_user='%@' and update_time < %0.f ",userId,timeStamp];
                BOOL  deleteRS = [fmdb executeUpdate:deleteSql];
                
                if (!deleteRS) {
                    BGYLog(@"删除一个月前数据失败...");
                } else {
                    BGYLog(@"删除一个月前数据成功...");
                }
            }
        }];
    });
}

//插入离线任务数量
- (void)insertOfflineQueueDataMessage:(DBConcreteRequestModel *)model {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@','%@')",
                                   BGYConcreteRequestTableName,
                                   BGYThekey,
                                   BGYThegroup,
                                   BGYSteps,
                                   BGYDisplay,
                                   BGYCreate_time,
                                   BGYUpdate_time,
                                   BGYOwner_user,
                                   model.thekey,
                                   model.thegroup,
                                   model.steps,
                                   model.display,
                                   model.create_time,
                                   model.update_time,
                                   model.owner_user
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}



- (void)insertOfflineWeblog:(NSString *)msg api:(NSString *)api leve:(NSInteger)level {
    
    ///暂时注销
    return;
    
    
    
    
//    NSString *userID =  [LoginManager shareInstance].loginUserId;
//    NSString *timeStr = [NSDate  bgy_currentTimeStampString];
//    NSString *host =  [[YTKNetworkConfig sharedConfig] baseUrl];
//
//
//
//
//    dispatch_async(_callQueue, ^{
//        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
//            NSString *updateSql = [NSString stringWithFormat:
//                                       @"INSERT INTO '%@' ('%@', '%@', '%@','%@','%@','%@','%@') VALUES ('%@', '%@', '%@','%@','%@','%ld','%d')",
//                                   BGYWeblogTableName,
//                                   BGYArg0,
//                                   BGYArg1,
//                                   BGYArg2,
//                                   BGYCreate_time,
//                                   BGYCreate_by,
//                                   BGYLevel,
//                                   BGYUploadStatus,
//                                   msg,
//                                   host,
//                                   api,
//                                   timeStr,
//                                   userID,
//                                   (long)level,
//                                   0
//            ];
//            BGYLog(@"插入日志表sql :%@",updateSql);
//            if ([fmdb open]) {
//                BOOL updateRES = [fmdb executeUpdate:updateSql];
//                if (!updateRES) {
//                    [fmdb close];
//                    NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
//
//                } else {
//                    [fmdb close];
//                    NSLog(@"更新数据成功...");
//                }
//            }
//        }];
//    });
}

- (void)selectHistoryLogListByPageSize:(NSInteger)pageSize{

    //暂时注销上传日志功能
    BGYLog(@"stop  uplaod log");
    return;

    if (self.isExcuteChecking  == YES) {
        BGYLog(@"isExcuteChecking: %d",self.isExcuteChecking);
        return;
    }
    if (pageSize > 20) {
        pageSize = 20;
    }
    
    self.isExcuteChecking = YES;
    
    @weakify(self)
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase * _Nonnull db) {
            @strongify(self)
            NSUInteger count =  [db intForQuery:@"select count(*) from t_qms_weblog where upload_status = 0 or upload_status = '0'"];
            if (count == 0) {
                [db close];
                self.isExcuteChecking = NO;
                BGYLog(@"没有要上传的日志");
                return;
            }
            
            NSInteger timers = count / pageSize;
            NSInteger left = count % pageSize;
            if (left > 0) {
                timers ++ ;
            }
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            for (NSInteger i = 0; i < timers ; i++) {
                NSMutableArray *resultArr = [NSMutableArray array];
                NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_weblog where  upload_status = 0 or upload_status = '0' order by upload_id asc limit 0,%ld",pageSize];
                FMResultSet *searchRS = [db executeQuery:selectSql];
                while ([searchRS next]) {
                    if ([searchRS resultDictionary]) {
                        [resultArr addObject:[searchRS resultDictionary]];
                    }
                }
                if (!searchRS) {
                    BGYLog(@"查询数据失败Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                } else {
                    BGYLog(@"查询数据成功...");
                }
                [searchRS close];
                resultArr = [BGYSystemLogModel mj_objectArrayWithKeyValuesArray:resultArr];
                if ([resultArr count] > 0) {
                    
                    [self updateWebLogDataByResult:resultArr callback:^{
                        dispatch_semaphore_signal(sema);
                    } fmdb:db] ;
                }else{
                    dispatch_semaphore_signal(sema);
                }
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
        }];
    });
    
}

- (void)updateWebLogDataByResult:(NSArray *)resultModelArr  callback:(void(^)(void))block  fmdb:(FMDatabase *)fmdb{
    [resultModelArr enumerateObjectsUsingBlock:^(BGYSystemLogModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.create_time =  [FrameworkUtill accurateDateByTimeString:obj.create_time];
    }];
    NSMutableString *mStr = [NSMutableString string];
    for (BGYSystemLogModel *model in resultModelArr) {
        [mStr appendString:[model mj_JSONString]];
        [mStr appendString:@"\n"];
    }
    
#warning 暂时注释 因为为引用网络框架
//    UploadLogMessgeAPi *api = [[UploadLogMessgeAPi alloc ] initWithMessage:mStr Api:nil];
//    api.isSystemLog = YES;
//    [api startBGYUniRequestWithCompletionBlock:^(BGYUniBaseResponse * _Nullable response) {
//        if (api.responseStatusCode == 200) {
//            dispatch_async(self->_callQueue, ^{
//                BGYSystemLogModel *firstUploadModel = [resultModelArr firstObject];
//                BGYSystemLogModel *lastUploadModel = [resultModelArr lastObject];
//
//                NSUInteger min = firstUploadModel.upload_id;
//                NSUInteger max  = lastUploadModel.upload_id;
//                if (min > lastUploadModel.upload_id) {
//                    min =  lastUploadModel.upload_id;
//                    max = firstUploadModel.upload_id;
//                }
//                NSString *updateSql = [NSString stringWithFormat: @"update t_qms_weblog set upload_status=1 where upload_id >= %lu and upload_id <= %lu",(unsigned long)min ,(unsigned long)max];
//                if ([fmdb open]) {
//                    if (updateSql && updateSql.length > 0 ) {
//                        BOOL updateRES = [fmdb executeUpdate:updateSql];
//                        if (!updateRES) {
//#if DEBUG
//                            BGYLog(@"上传日志失败：Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
//#endif
//                        } else {
//                            BGYLog(@"上传日志更新本地状态成功...");
//                        }
//                    }
//                }
//                self.isExcuteChecking = NO;
//                if (block) {
//                    block();
//                }
//            });
//        }else{
//            self.isExcuteChecking = NO;
//            if (block) {
//                block();
//            }
//        }
//    }];
}


//查询数据库里面的日志,支持分页查询
- (void)selectHistoryLogListByUserName:(NSString *)userName pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize finish:(void (^)(NSArray *historyArr))finish {
    NSMutableArray *resultArr = [NSMutableArray array];
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_weblog  where create_by = '%@' order by create_time desc  limit %ld,%ld",userName,pageIndex * pageSize,pageSize];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            if (!searchRS) {
                BGYLog(@"查询数据失败...");
            } else {
                BGYLog(@"查询数据成功...");
            }
            [searchRS close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
            
        }];
    });
}

- (void)insertdatadict:(NSDictionary *)dic {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_datadict (typeName,typeCode,dictKey,dictName,enable) VALUES ('%@','%@','%@','%@','%@')",
                                   [dic objectForKey:@"typeName"],
                                   [dic objectForKey:@"typeCode"],
                                   [dic objectForKey:@"dictKey"],
                                   [dic objectForKey:@"dictName"],
                                   [dic objectForKey:@"enable"]
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}
- (void)deletedataDict{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = @"delete from t_qms_datadict";
        
        BOOL  updateRES = [fmdb executeUpdate:deleteSql];
        
        if (!updateRES) {
            BGYLog(@"删除数据失败...");
            BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            
        } else {
            BGYLog(@"删除数据成功...");
        }
        
        
    }];
    
    
}

// 插入用户操作权限
- (void)insertUserOperationData:(UserOperationModel *)model {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_useroperation (resourceType,appId,remarks,code) VALUES ('%@','%@','%@','%@')",
                                   model.resourceType,
                                   model.appId,
                                   model.remarks,
                                   model.code
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}
- (void)deleteUserOperationData{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = @"delete from t_qms_useroperation";
        
        BOOL  updateRES = [fmdb executeUpdate:deleteSql];
        
        if (!updateRES) {
            BGYLog(@"删除数据失败...");
            BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            
        } else {
            BGYLog(@"删除数据成功...");
        }
        
        
    }];
    
    
}
- (void)selectUserOperationByappid:(NSString *)appid  code:(NSString *)code finish:(void (^)(NSArray *stepArr))finish{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
    
        NSString *selectSql = [NSString stringWithFormat:@"select remarks,code from t_qms_useroperation where appId='%@' and resourceType='BUTTON'",appid];
        
        if(!BGY_IsEmptyString(code)){
            selectSql = [NSString stringWithFormat:@"select remarks,code from t_qms_useroperation where code='%@' and resourceType='BUTTON'",code];
        }
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        NSMutableArray *resultArr = [NSMutableArray array];
        
        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }
        if (!searchRS) {
            //                BGYLog(@"查询数据失败...");
        } else {
            //                BGYLog(@"查询数据成功...");
        }
        [searchRS close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                finish([resultArr copy]);
            }
        });
        
    }];
    
}
#pragma 桩基
// 获取楼栋
- (void)selectBuildListById:(NSString *)projectId finish:(void (^)(NSArray *stepArr))finish{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_build where projectId='%@'",projectId];
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        
        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }
        
        [searchRS close];
        
   
            if (finish) {
                finish([resultArr copy]);
            }
      
        
    }];
    
}



- (void)selectBuildPileNoBybuildId:(NSString *)Id finish:(void (^)(NSArray *stepArr))finish{

    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {

        NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_pileno where secondaryBuildingId='%@'",Id];

        FMResultSet *searchRS = [fmdb executeQuery:selectSql];

        NSMutableArray *resultArr = [NSMutableArray array];

        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }

        [searchRS close];


            if (finish) {
                finish([resultArr copy]);
            }
  


    }];

}

- (void)deletePileConstantDataById:(NSString *)Id{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_pilesetting where id='%@'",Id];
        
        BOOL  updateRES = [fmdb executeUpdate:deleteSql];
        
        if (!updateRES) {
            BGYLog(@"删除数据失败...");
            BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            
        } else {
            BGYLog(@"删除数据成功...");
        }
    }];
}
- (void)insertPileConstantData:(BGYPileConstantModel *)model {
    // 桩基插入常量
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_pilesetting (id,secondaryBuildingId,deleteTag,tenantId,pileNo,pilingStatus,pileTypeId,pileTypeName,pileModel,concreteGrade,groundElevationValue,pileTopElevationValue,pileDiameter,coordinateX,coordinateY,simpleElevationValue,depthIntoBearingStratum,effectivePileLength,reinforcementCageSize,casingElevationValue,voidedPileNo,supplement,templateType) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%ld','%ld','%ld','%ld','%ld','%ld','%ld','%ld','%@','%@','%@')",
                                   model.id,
                                   model.secondaryBuildingId,
                                   model.deleteTag,
                                   
                                   BGY_AvoidNullString(model.tenantId),
                                   BGY_AvoidNullString(model.pileNo),
                                   BGY_AvoidNullString(model.pilingStatus),
                                   BGY_AvoidNullString(model.pileTypeId),
                                   BGY_AvoidNullString(model.pileTypeName),
                                   BGY_AvoidNullString(model.pileModel),
                                   BGY_AvoidNullString(model.concreteGrade),
                                   model.groundElevationValue,
                                   model.pileTopElevationValue,
                                   model.pileDiameter,
                                   model.coordinateX,
                                   model.coordinateY,
                                   model.simpleElevationValue,
                                   model.depthIntoBearingStratum,
                                   model.effectivePileLength,
                                   model.reinforcementCageSize,
                                   model.casingElevationValue,
                                   model.voidedPileNo,
                                   model.supplement,
                                   model.templateType
                                   
                                   
            ];
            
           [fmdb executeUpdate:insertSql];
          
        }];
    });
}

- (void)deletePileEmptyForm{
    
    // 删除空白表单模版
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_pileemptyform"];
      
        [fmdb executeUpdate:deleteSql];
       
       
    }];
}
- (void)insertPileEmptyForm:(NSDictionary *)dic {
    // 插入空白表单模版
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
            NSInteger  version=[[dic objectForKey:@"version"]intValue];
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_pileemptyform (filename,pileTypeId,version,datetime) VALUES ('%@','%@','%ld','%@')",
                                   [dic objectForKey:@"filename"],
                                   [dic objectForKey:@"pileTypeId"],
                                   version,
                                   [dic objectForKey:@"datetime"]
                                   
                                   
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}

- (void)deleteDataAuthority:(NSString *)fieldid{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_dataauthority where fieldid='%@'",fieldid];
        
       [fmdb executeUpdate:deleteSql];
        
        
    }];
}

// 清理桩基所有缓存
- (void)ClearPileCaches{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = @"delete from t_qms_pilerecord";
        NSString *deleteSql2 = @"delete from t_qms_pilerecorditem";
        NSString *deleteSql3 = @"delete from t_qms_dynamicForm";
     
        
        [fmdb executeUpdate:deleteSql];
        [fmdb executeUpdate:deleteSql2];
        [fmdb executeUpdate:deleteSql3];
     

    }];
}
- (void)ClearAllCaches{
    // 清理所有缓存
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = @"delete from t_qms_pilerecord";
        NSString *deleteSql2 = @"delete from t_qms_pilerecorditem";
        NSString *deleteSql3 = @"delete from t_qms_dynamicForm";
        NSString *deleteSql4 = @"delete from t_qms_area";
        NSString *deleteSql5 = @"delete from t_qms_project";
        NSString *deleteSql6 = @"delete from t_qms_useroperation";
        NSString *deleteSql7 = @"delete from t_qms_datadict";
        NSString *deleteSql8 = @"delete from t_qms_dataauthority";
        NSString *deleteSql9 = @"delete from t_qms_build";
        NSString *deleteSql10 = @"delete from t_qms_pilesetting";
        NSString *deleteSql11 = @"delete from t_qms_pileemptyform";
        NSString *deleteSql12 = @"delete from t_qms_pileno";
     
        
        [fmdb executeUpdate:deleteSql];
        [fmdb executeUpdate:deleteSql2];
        [fmdb executeUpdate:deleteSql3];
        [fmdb executeUpdate:deleteSql4];
        [fmdb executeUpdate:deleteSql5];
        [fmdb executeUpdate:deleteSql6];
        [fmdb executeUpdate:deleteSql7];
        [fmdb executeUpdate:deleteSql8];
        [fmdb executeUpdate:deleteSql9];
        [fmdb executeUpdate:deleteSql10];
        [fmdb executeUpdate:deleteSql11];
        [fmdb executeUpdate:deleteSql12];
    
     

    }];
}

- (void)updatedynamicForm:(NSString *)id   fieldValue:(NSString *)fieldValue  tempValue:(NSString *)tempValue{
    // 更改表单内容
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {

            NSString * sql= [NSString stringWithFormat:@"update t_qms_dynamicForm set fieldValue='%@',tempValue='%@' where id='%@'",fieldValue,tempValue,id];
            [fmdb executeUpdate:sql];
           
        }];
    });
}

- (void)updatePilerecorditemByStatus:(NSString *)id   groupBillStatus:(NSString *)groupBillStatus{
    // 更改桩类型状态
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {

            NSString * sql= [NSString stringWithFormat:@"update t_qms_pilerecorditem set groupBillStatus='%@' where id='%@'",groupBillStatus,id];
            [fmdb executeUpdate:sql];
           
        }];
    });
}

- (void)insertDataAuthority:(NSDictionary *)dic {
    // 插入数据操作权限
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {

            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_dataauthority (fieldid,fieldvalue,createtime) VALUES ('%@','%@','%@')",
                                   [dic objectForKey:@"fieldid"],
                                   [dic objectForKey:@"fieldvalue"],
                                   [FrameworkUtill getCurrentTime]
                                   
                                   
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}
- (NSString *)selectDataAuthorityByKey:(NSString *)Key
{
    // 查询数据操作权限
   __block NSString *result=@"";
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select fieldvalue from t_qms_dataauthority where fieldid='%@'",Key];
        
       
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        while ([searchRS next]) {
            result=[searchRS stringForColumn:@"fieldvalue"];
        }

        [searchRS close];

    }];
    
    return result;
}
- (NSString *)selectPileEmptyForm:(NSString *)pileTypeId
{
    // 查询字典
   __block NSString *result=@"";
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select filename from t_qms_pileemptyform where pileTypeId='%@' order by version desc  limit 1",pileTypeId];
        
       
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        while ([searchRS next]) {
            result=[searchRS stringForColumn:@"filename"];
        }

        [searchRS close];

    }];
    
    return result;
}


- (void)insertPileBuildData:(BGYPileBuildModel *)model {
    // 楼栋
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_build (projectId,projectCode,secondaryBuildingId,secondaryBuildingCode,secondaryBuildingName,virtualBuilding,hasPileImg,hasPileno) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",
                                   BGY_AvoidNullString(model.projectId),
                                   BGY_AvoidNullString(model.projectCode),
                                   BGY_AvoidNullString(model.secondaryBuildingId),
                                   BGY_AvoidNullString(model.secondaryBuildingCode),
                                   BGY_AvoidNullString(model.secondaryBuildingName),
                                   BGY_AvoidNullString(model.virtualBuilding),
                                   BGY_AvoidNullString(model.hasPileImg),
                                   BGY_AvoidNullString(model.hasPileno)
            ];
            BOOL insertRES = [fmdb executeUpdate:insertSql];
            if (!insertRES) {
                BGYLog(@"插入数据失败...");
            } else {
                BGYLog(@"插入数据成功...");
            }
        }];
    });
}
- (void)insertPileNoData:(BGYPileNoModel *)model {
    // 桩号
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_pileno (secondaryBuildingId,projectId,pileId,pileNo,pileTypeId,pileTypeName,pilingStatus,hasRefPile,type) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                                  BGY_AvoidNullString(model.secondaryBuildingId),
                                  BGY_AvoidNullString(model.projectId),
                                  BGY_AvoidNullString(model.pileId),
                                  BGY_AvoidNullString(model.pileNo),
                                  BGY_AvoidNullString(model.pileTypeId),
                                  BGY_AvoidNullString(model.pileTypeName),
                                  BGY_AvoidNullString(model.pilingStatus),
                                  BGY_AvoidNullString(model.hasRefPile),
                                  BGY_AvoidNullString(model.type)
                                   
            ];
            [fmdb executeUpdate:insertSql];
          
        }];
    });
}
- (void)deletePileBuildData:(NSString *)projectid{
    
    // 删除楼栋
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_build where projectId='%@'",projectid];
       
        [fmdb executeUpdate:deleteSql];
      
    }];
}

- (void)deletePileNoData:(NSString *)pileId{
    
    // 删除桩号
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from t_qms_pileno where pileId='%@'",pileId];
        
        [fmdb executeUpdate:deleteSql];
      
    }];
}


- (void)insertPileRecordData:(BGYPileRecordModel *)model {
    // 桩类型
//    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
           
            NSString *selectSql=[NSString stringWithFormat:@"select pileId from t_qms_pilerecord where pileId='%@'",model.pileId];
              NSString *pileId=@"";
              FMResultSet *searchRS = [fmdb executeQuery:selectSql];
              while ([searchRS next]) {
                  pileId=[searchRS stringForColumn:@"pileId"];
              }
            if(BGY_IsEmptyString(pileId)){
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_pilerecord (id,pileId,pilingRecordId,businessName,businessId,formName,formVersion,formCode,hasWorkCheck,hasInvalidatedPile,anbleInvalidatedPile,formBusiGroupCode,formBusiGroupName,type,pid,flowId,flowUrl,flowNo) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                                       model.id,
                                       model.pileId,
                                      BGY_AvoidNullString(model.pilingRecordId),
                                      BGY_AvoidNullString(model.businessName),
                                      BGY_AvoidNullString(model.businessId),
                                      BGY_AvoidNullString(model.formName),
                                      BGY_AvoidNullString(model.formVersion),
                                      BGY_AvoidNullString(model.formCode),
                                       model.hasWorkCheck,
                                       model.hasInvalidatedPile,
                                       model.anbleInvalidatedPile,
                                       model.formBusiGroupCode,
                                       model.formBusiGroupName,
                                       model.type,
                                      BGY_AvoidNullString(model.pid),
                                      BGY_AvoidNullString(model.flowId),
                                      BGY_AvoidNullString(model.flowUrl),
                                      BGY_AvoidNullString(model.flowNo)
                                       
                ];
                [fmdb executeUpdate:insertSql];
            }
            else{
                
                NSString *updateSql=[NSString stringWithFormat:@"UPDATE t_qms_pilerecord set pilingRecordId='%@',businessName='%@',businessId='%@',formName='%@',formVersion='%@',formCode='%@',hasWorkCheck='%@',hasInvalidatedPile='%@',anbleInvalidatedPile='%@',formBusiGroupCode='%@',formBusiGroupName='%@',flowId='%@',flowUrl='%@',flowNo='%@',pid='%@',id='%@' where pileId='%@'",BGY_AvoidNullString(model.pilingRecordId),BGY_AvoidNullString(model.businessName),BGY_AvoidNullString(model.businessId),BGY_AvoidNullString(model.formName),BGY_AvoidNullString(model.formVersion),BGY_AvoidNullString(model.formCode),model.hasWorkCheck,model.hasInvalidatedPile,model.anbleInvalidatedPile,model.formBusiGroupCode,model.formBusiGroupName,BGY_AvoidNullString(model.flowId),BGY_AvoidNullString(model.flowUrl),BGY_AvoidNullString(model.flowNo),model.id,model.id,model.pileId];
                
                [fmdb executeUpdate:updateSql];
            }
           
   
        }];
//    });
}

- (void)selectPileRecordDataByRecordId:(NSString *)recordId finish:(void (^)(NSArray *stepArr))finish{
    
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_pilerecord where pileId='%@'",recordId];
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        NSMutableArray *resultArr = [NSMutableArray array];
        
        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }
        
        [searchRS close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                finish([resultArr copy]);
            }
        });
        
    }];
    
}


- (NSString *)selectPileDataByPileId:(NSString *)pileId{
    
    __block NSString *result=@"";
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select pileId from t_qms_pilerecord where pileId='%@'",pileId];
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        
        while ([searchRS next]) {
            result=[searchRS stringForColumn:@"pileId"];
        }
        
        [searchRS close];
       
        
    }];
    return  result;
}

- (NSMutableString *)selectPiledynamicFormByPileId:(NSString *)pileId{
    
    __block NSMutableString *result=[[NSMutableString alloc]init];
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"SELECT  distinct(editRoles) as editRoles FROM `t_qms_dynamicForm` where pileId='%@'",pileId];
        
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        
        while ([searchRS next]) {
            NSString *item=[searchRS stringForColumn:@"editRoles"];
            if(!BGY_IsEmptyString(item)){
                [result appendFormat:@"%@", item];
                [result appendFormat:@","];
               
            }
           
        }
        
        [searchRS close];
    
        if(!BGY_IsEmptyString(result)){
          
            if([result hasSuffix:@","])
              [result setString:[result substringToIndex:[result length]-1]];
        }
      
    }];
    return  result;
}

// 计算桩基常量
- (void)selectPileConstantById:(NSString *)Id   finish:(void (^)(NSArray *stepArr))finish{

    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_pilesetting where  id='%@'",Id];

        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        
        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }

        [searchRS close];
 
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                finish([resultArr copy]);
            }
        });
        
    }];
}

- (void)selectPileDynamicFormByCode:(NSDictionary *)dic   finish:(void (^)(NSArray *stepArr))finish{

    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
     
        NSString *pileId=[dic objectForKey:@"pileId"];
        NSString *fullCode=[dic objectForKey:@"key"];
        NSString *parentId2=[dic objectForKey:@"parentId2"];
        NSString *sum=[dic objectForKey:@"typeCalculate"];
        

        NSString *selectSql=@"";
        
        if([sum isEqualToString:@"sum"]){
            selectSql = [NSString stringWithFormat:@"select SUM(tempValue) as tempValue FROM `t_qms_dynamicForm` where pileId='%@' and fullCode='%@' and tempValue!=''",pileId,fullCode];
        }
        else{
            
     
            selectSql = [NSString stringWithFormat:@"select tempValue from t_qms_dynamicForm where  pileId='%@' and parentId2='%@' and fullCode='%@' and tempValue!=''",pileId,parentId2,fullCode];
           
             NSString *tempValue=@"";
             FMResultSet *tempsearchRS = [fmdb executeQuery:selectSql];
             while ([tempsearchRS next]) {
                 tempValue=[tempsearchRS stringForColumn:@"tempValue"];
             }
            
            if(BGY_IsEmptyString(tempValue)){
                selectSql = [NSString stringWithFormat:@"select tempValue from t_qms_dynamicForm where  pileId='%@'  and fullCode='%@' and tempValue!=''",pileId,fullCode];
                
            }
        }
       
        
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        
        while ([searchRS next]) {
            [resultArr addObject:[searchRS resultDictionary]];
        }

        [searchRS close];
 
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                finish([resultArr copy]);
            }
        });
        
    }];
}

// 清空桩基缓存数据
- (BOOL)deletePilerecordByPileId:(NSString *)pileId{
  
  __block  bool result=NO;
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
      
        NSString *sql = [NSString stringWithFormat:@"delete from t_qms_pilerecord where pileId='%@'",pileId];
        result=[fmdb executeUpdate:sql];
        
        NSString *sql2 = [NSString stringWithFormat:@"delete from t_qms_pilerecorditem where pileId='%@'",pileId];
        result=[fmdb executeUpdate:sql2];
        
        NSString *sql3 = [NSString stringWithFormat:@"delete from t_qms_dynamicForm where pileId='%@'",pileId];

        result=[fmdb executeUpdate:sql3];
      
       
    }];
  
    return result;
}


- (void)insertPileRecordItemData:(BGYPileRecordItemModel *)model {
    // 桩类型分组
//    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
          
            NSString *selectSql=[NSString stringWithFormat:@"select pileId from t_qms_pilerecorditem where pileId='%@' and itemGroupCode='%@' and num='%ld' and orderNum='%ld' and parentId='%@'",model.pileId,model.itemGroupCode,model.num,model.orderNum,model.parentId];
            
              NSString *pileId=@"";
              FMResultSet *searchRS = [fmdb executeQuery:selectSql];
              while ([searchRS next]) {
                  pileId=[searchRS stringForColumn:@"pileId"];
              }
             if(BGY_IsEmptyString(pileId)){
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_pilerecorditem (id,pileId,pilingRecordId,itemGroupName,itemGroupCode,parentId,parentId2,mustNotNull ,status,num,groupType,editRoles,repeatMax,groupBillStatus,submitRoles,updateRoles,orderNum,type,pid) VALUES ('%@','%@','%@','%@','%@','%@','%@','%ld','%@','%ld','%@','%@','%ld','%@','%@','%@','%ld','%@','%@')",
                                       model.id,
                                      BGY_AvoidNullString(model.pileId),
                                      BGY_AvoidNullString(model.pilingRecordId),
                                      BGY_AvoidNullString(model.itemGroupName),
                                      BGY_AvoidNullString(model.itemGroupCode),
                                      BGY_AvoidNullString(model.parentId),
                                      BGY_AvoidNullString(model.parentId2),
                                       model.mustNotNull,
                                      BGY_AvoidNullString(model.status),
                                       model.num,
                                      BGY_AvoidNullString(model.groupType),
                                      BGY_AvoidNullString(model.editRoles),
                                       model.repeatMax,
                                      BGY_AvoidNullString(model.groupBillStatus),
                                      BGY_AvoidNullString(model.submitRoles),
                                      BGY_AvoidNullString(model.updateRoles),
                                       model.orderNum,
                                       model.type,
                                      BGY_AvoidNullString(model.pid)
                ];
                [fmdb executeUpdate:insertSql];
            }
            else{
                NSString *updateSql=[NSString stringWithFormat:@"UPDATE t_qms_pilerecorditem SET groupBillStatus='%@',editRoles='%@',submitRoles='%@',updateRoles='%@',pid='%@' where pileId='%@' and itemGroupCode='%@'and num='%ld' and orderNum='%ld' ",BGY_AvoidNullString(model.groupBillStatus),BGY_AvoidNullString(model.editRoles),BGY_AvoidNullString(model.submitRoles),BGY_AvoidNullString(model.updateRoles),BGY_AvoidNullString(model.pid),model.pileId,model.itemGroupCode,model.num,model.orderNum];
                
                [fmdb executeUpdate:updateSql];
            }
           
        }];
//    });
}

- (void)insertPileRecordItemData2:(BGYPileRecordItemModel *)model {
    // 新增分组,桩类型分组
//    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
          
            
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_pilerecorditem (id,pileId,pilingRecordId,itemGroupName,itemGroupCode,parentId,parentId2,mustNotNull ,status,num,groupType,editRoles,repeatMax,groupBillStatus,submitRoles,updateRoles,orderNum,type,pid) VALUES ('%@','%@','%@','%@','%@','%@','%@','%ld','%@','%ld','%@','%@','%ld','%@','%@','%@','%ld','%@','%@')",
                                       model.id,
                                      BGY_AvoidNullString(model.pileId),
                                      BGY_AvoidNullString(model.pilingRecordId),
                                      BGY_AvoidNullString(model.itemGroupName),
                                      BGY_AvoidNullString(model.itemGroupCode),
                                      BGY_AvoidNullString(model.parentId),
                                      BGY_AvoidNullString(model.parentId2),
                                       model.mustNotNull,
                                      BGY_AvoidNullString(model.status),
                                       model.num,
                                      BGY_AvoidNullString(model.groupType),
                                      BGY_AvoidNullString(model.editRoles),
                                       model.repeatMax,
                                      BGY_AvoidNullString(model.groupBillStatus),
                                      BGY_AvoidNullString(model.submitRoles),
                                      BGY_AvoidNullString(model.updateRoles),
                                       model.orderNum,
                                       model.type,
                                      BGY_AvoidNullString(model.pid)
                ];
                [fmdb executeUpdate:insertSql];
          
           
        }];
//    });
}
- (NSString *)selectDataDictByKey:(NSString *)dictKey
{
    // 查询字典
   __block NSString *result=@"";
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select dictName from t_qms_datadict where typeCode='FORM_EDIT_ROLE' and dictKey ='%@'",dictKey];
        
       
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        while ([searchRS next]) {
            result=[searchRS stringForColumn:@"dictName"];
        }

        [searchRS close];

    }];
    
    return result;
}

- (void)selectPileRecordItemByRecordId:(NSString *)recordId  parentId:(NSString *)parentId  finish:(void (^)(NSArray *stepArr))finish{

        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
            // 查询外业、不嵌套遍历
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_pilerecorditem where pileId='%@' and parentId='-1'",recordId];
            // 查询非外业部分
            NSString *selectSql2 = [NSString stringWithFormat:@"select * from t_qms_pilerecorditem where pileId='%@' and parentId!='-1' and status='ENABLE'",recordId];
                
            NSString *selectSql3 = [NSString stringWithFormat:@"select * from t_qms_dynamicForm where pileId='%@' and status='ENABLE'",recordId];
                
            NSString *selectSql4 = [NSString stringWithFormat:@"select * from t_qms_pilerecord where pileId='%@'",recordId];
            
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            FMResultSet *searchRS2 = [fmdb executeQuery:selectSql2];
            FMResultSet *searchRS3 = [fmdb executeQuery:selectSql3];
            FMResultSet *searchRS4 = [fmdb executeQuery:selectSql4];
            
            NSMutableArray *resultArr = [NSMutableArray array];
            NSMutableArray *resultArr1 = [NSMutableArray array];
            NSMutableArray *resultArr2 = [NSMutableArray array];
            NSMutableArray *resultArr3 = [NSMutableArray array];
            NSMutableArray *resultArr4 = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr1 addObject:[searchRS resultDictionary]];
            }
            while ([searchRS2 next]) {
                [resultArr2 addObject:[searchRS2 resultDictionary]];
            }
            
            while ([searchRS3 next]) {
                [resultArr3 addObject:[searchRS3 resultDictionary]];
            }
            while ([searchRS4 next]) {
                [resultArr4 addObject:[searchRS4 resultDictionary]];
            }
            
            [resultArr addObject:resultArr1];
            [resultArr addObject:resultArr2];
            [resultArr addObject:resultArr3];
            [resultArr addObject:resultArr4];
            
            [searchRS close];
            [searchRS2 close];
            [searchRS3 close];
            [searchRS4 close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
      }];

}
- (void)insertPiledynamicFormData:(BGYPileDynamicFormModel *)model {
    // 桩基表单项
//    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
           

            NSString *selectSql=[NSString stringWithFormat:@"select pileId from t_qms_dynamicForm where pileId='%@' and fullCode='%@' and num='%ld' and orderNum='%ld' and orderNum2='%ld'",model.pileId,model.fullCode,model.num,model.orderNum,model.orderNum2];
            
              NSString *pileId=@"";
              FMResultSet *searchRS = [fmdb executeQuery:selectSql];
              while ([searchRS next]) {
                  pileId=[searchRS stringForColumn:@"pileId"];
              }
            
            if(BGY_IsEmptyString(pileId)){
                
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_dynamicForm (id,pileId,pilingRecordId,itemGroupName,itemGroupCode,parentId,parentId2,fullCode,mustNotNull ,status,num,fieldName,fieldCode,fieldType,repeatMax,editRoles,fieldValue,tempValue,hasUpdate,orderNum,fieldDescribe,fieldSelectParams,fieldFormula,fieldLength,fieldSuffixDescribe,valueRange,oldFieldValue,auditStatus,createTime,type,pid,num2,orderNum2) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%ld','%@','%ld','%@','%@','%@','%ld','%@','%@','%@','%@','%ld','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld','%ld')",
                                       model.id,
                                      BGY_AvoidNullString(model.pileId),
                                      BGY_AvoidNullString(model.pilingRecordId),
                                      BGY_AvoidNullString(model.itemGroupName),
                                      BGY_AvoidNullString(model.itemGroupCode),
                                      BGY_AvoidNullString(model.parentId),
                                      BGY_AvoidNullString(model.parentId2),
                                      BGY_AvoidNullString(model.fullCode),
                                       model.mustNotNull,
                                      BGY_AvoidNullString(model.status),
                                       model.num,
                                      BGY_AvoidNullString(model.fieldName),
                                      BGY_AvoidNullString(model.fieldCode),
                                      BGY_AvoidNullString(model.fieldType),
                                       model.repeatMax,
                                      BGY_AvoidNullString(model.editRoles),
                                      BGY_AvoidNullString(model.fieldValue),
                                      BGY_AvoidNullString(model.tempValue),
                                      BGY_AvoidNullString(model.hasUpdate),
                                       model.orderNum,
                                      BGY_AvoidNullString(model.fieldDescribe),
                                      BGY_AvoidNullString(model.fieldSelectParams),
                                      BGY_AvoidNullString(model.fieldFormula),
                                      BGY_AvoidNullString(model.fieldLength),
                                      BGY_AvoidNullString(model.fieldSuffixDescribe),
                                      BGY_AvoidNullString(model.valueRange),
                                      BGY_AvoidNullString(model.oldFieldValue),
                                      BGY_AvoidNullString(model.auditStatus),
                                       [FrameworkUtill getCurrentTime],
                                       model.type,
                                      BGY_AvoidNullString(model.pid),
                                       model.num2,
                                       model.orderNum2
                ];
                [fmdb executeUpdate:insertSql];
            }
            else{
                
                NSString *updateSql=[NSString stringWithFormat:@"UPDATE t_qms_dynamicForm SET editRoles='%@',fieldValue='%@',tempValue='%@',hasUpdate='%@',fieldDescribe='%@',fieldSelectParams='%@',fieldFormula='%@',fieldLength='%@',fieldSuffixDescribe='%@',valueRange='%@',oldFieldValue='%@',auditStatus='%@',pid='%@' where pileId='%@' and fullCode='%@' and num='%ld' and orderNum='%ld' and orderNum2='%ld'",BGY_AvoidNullString(model.editRoles),BGY_AvoidNullString(model.fieldValue),BGY_AvoidNullString(model.tempValue),BGY_AvoidNullString(model.hasUpdate),BGY_AvoidNullString(model.fieldDescribe),BGY_AvoidNullString(model.fieldSelectParams),
                                    BGY_AvoidNullString(model.fieldFormula),
                                    BGY_AvoidNullString(model.fieldLength),
                                    BGY_AvoidNullString(model.fieldSuffixDescribe),
                                    BGY_AvoidNullString(model.valueRange),
                                    BGY_AvoidNullString(model.oldFieldValue),
                                    BGY_AvoidNullString(model.auditStatus),BGY_AvoidNullString(model.pid),model.pileId,model.fullCode,model.num,model.orderNum,model.orderNum2];
                
                [fmdb executeUpdate:updateSql];
            }
            
        }];
//    });
}
- (void)insertPiledynamicFormData2:(BGYPileDynamicFormModel *)model {
    // 新增分组，桩基表单项
//    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
           
          
                
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_dynamicForm (id,pileId,pilingRecordId,itemGroupName,itemGroupCode,parentId,parentId2,fullCode,mustNotNull ,status,num,fieldName,fieldCode,fieldType,repeatMax,editRoles,fieldValue,tempValue,hasUpdate,orderNum,fieldDescribe,fieldSelectParams,fieldFormula,fieldLength,fieldSuffixDescribe,valueRange,oldFieldValue,auditStatus,createTime,type,pid) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%ld','%@','%ld','%@','%@','%@','%ld','%@','%@','%@','%@','%ld','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                                       model.id,
                                      BGY_AvoidNullString(model.pileId),
                                      BGY_AvoidNullString(model.pilingRecordId),
                                      BGY_AvoidNullString(model.itemGroupName),
                                      BGY_AvoidNullString(model.itemGroupCode),
                                      BGY_AvoidNullString(model.parentId),
                                      BGY_AvoidNullString(model.parentId2),
                                      BGY_AvoidNullString(model.fullCode),
                                       model.mustNotNull,
                                      BGY_AvoidNullString(model.status),
                                       model.num,
                                      BGY_AvoidNullString(model.fieldName),
                                      BGY_AvoidNullString(model.fieldCode),
                                      BGY_AvoidNullString(model.fieldType),
                                       model.repeatMax,
                                      BGY_AvoidNullString(model.editRoles),
                                      BGY_AvoidNullString(model.fieldValue),
                                      BGY_AvoidNullString(model.tempValue),
                                      BGY_AvoidNullString(model.hasUpdate),
                                       model.orderNum,
                                      BGY_AvoidNullString(model.fieldDescribe),
                                      BGY_AvoidNullString(model.fieldSelectParams),
                                      BGY_AvoidNullString(model.fieldFormula),
                                      BGY_AvoidNullString(model.fieldLength),
                                      BGY_AvoidNullString(model.fieldSuffixDescribe),
                                      BGY_AvoidNullString(model.valueRange),
                                      BGY_AvoidNullString(model.oldFieldValue),
                                      BGY_AvoidNullString(model.auditStatus),
                                       [FrameworkUtill getCurrentTime],
                                       model.type,
                                      BGY_AvoidNullString(model.pid)
                ];
                [fmdb executeUpdate:insertSql];
           
        }];
//    });
}
- (void)deletedynamicFormById:(NSString *)Id  type:(NSString *)type{

    if([type isEqualToString:@"group"]){
     
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *deleteSql =[NSString stringWithFormat:@"delete from t_qms_dynamicForm  where parentid2='%@'",Id];
            
            NSString *deleteSql2 =[NSString stringWithFormat:@"delete from t_qms_pilerecorditem  where id='%@'",Id];
           
          
           [fmdb executeUpdate:deleteSql];
           [fmdb executeUpdate:deleteSql2];
         
        }];
        
    }
    else if ([type isEqualToString:@"item"]){
        
          [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
              NSString *deleteSql =[NSString stringWithFormat:@"delete from t_qms_dynamicForm  where id='%@'",Id];
            
             [fmdb executeUpdate:deleteSql];
           
          }];
    }

}
- (void)selectdynamicFormById:(NSString *)Id  type:(NSString *)type  finish:(void (^)(NSArray *stepArr))finish{

    if([type isEqualToString:@"group"]){
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_pilerecorditem where id='%@'",Id];
            NSString *selectSql2 = [NSString stringWithFormat:@"select * from t_qms_dynamicForm where parentid2='%@'",Id];
            
            
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            FMResultSet *searchRS2 = [fmdb executeQuery:selectSql2];
            
            NSMutableArray *resultArr = [NSMutableArray array];
            NSMutableArray *resultArr2 = [NSMutableArray array];
            NSMutableArray *resultArr3 = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr2 addObject:[searchRS resultDictionary]];
            }
            while ([searchRS2 next]) {
                [resultArr3 addObject:[searchRS2 resultDictionary]];
            }
            [resultArr addObject:resultArr2];
            [resultArr addObject:resultArr3];
            
            
            [searchRS close];
            [searchRS2 close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
            
        }];
    }
    else if ([type isEqualToString:@"item"]){
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_qms_dynamicForm where id='%@'",Id];
            
            
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            
            NSMutableArray *resultArr = [NSMutableArray array];
            
            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }

            [searchRS close];
     
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });
            
        }];
    }

}

#pragma 区域项目数据操作

- (void)insertAreaData:(DBAreaModel *)model {
   
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            
            NSString *selectSql=[NSString stringWithFormat:@"select areaId from t_qms_area where areaId='%@'",model.areaId];
            NSString *areaId=@"";
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            while ([searchRS next]) {
                areaId=[searchRS stringForColumn:@"areaId"];
            }
            if(BGY_IsEmptyString(areaId)){
                NSString *insertSql = [NSString stringWithFormat:
                                           @"INSERT INTO t_qms_area (areaId,areaCode,areaName,status) VALUES ('%@','%@','%@',%d)",
                                       model.areaId,
                                       model.areaCode,
                                       model.areaName,
                                       model.status
                ];

                [fmdb executeUpdate:insertSql];
            }
           
        }];
  });
}





- (void)insertProjectData:(DBProjectModel *)model {
   
    dispatch_async(_callQueue, ^{
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql=[NSString stringWithFormat:@"select projectId from t_qms_project where projectId='%@'",model.projectId];
        NSString *projectId=@"";
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        while ([searchRS next]) {
            projectId=[searchRS stringForColumn:@"projectId"];
        }
        
        if(BGY_IsEmptyString(projectId)){
            NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO t_qms_project (areaId,projectId,projectCode,projectName,status) VALUES ('%@','%@','%@','%@',%d)",
                                   model.areaId,
                                   model.projectId,
                                   model.projectCode,
                                   model.projectName,
                                   model.status
            ];
            
            [fmdb executeUpdate:insertSql];
        }
  
    }];
 });
}

- (void)selectAreaListByareaname:(NSString *)areaname finish:(void (^)(NSArray *stepArr))finish{

        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
          
            NSString *selectSql = [NSString stringWithFormat:@"select areaCode,areaName,areaId,status from t_qms_area"];
            
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        NSMutableArray *resultArr = [NSMutableArray array];

            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            if (!searchRS) {
//                BGYLog(@"查询数据失败...");
            } else {
//                BGYLog(@"查询数据成功...");
            }
            [searchRS close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish([resultArr copy]);
                }
            });

        }];

}

- (void)selectProjectListByareaId:(NSString *)areaId  projectName:(NSString *)projectName finish:(void (^)(NSArray *stepArr))finish{
  
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select projectId,areaId,projectName,projectCode,status from t_qms_project  where areaId='%@'",areaId];
            
        if(!BGY_IsEmptyString(projectName)){
          NSString  *projectName2=[@"%" stringByAppendingString:projectName];
          NSString  *projectName3=[projectName2 stringByAppendingString:@"%"];
            
            selectSql = [NSString stringWithFormat:@"select projectId,areaId,projectName,projectCode,status from t_qms_project  where projectName like '%@'",projectName3];
        }
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        NSMutableArray *resultArr = [NSMutableArray array];

            while ([searchRS next]) {
                [resultArr addObject:[searchRS resultDictionary]];
            }
            if (!searchRS) {
//                BGYLog(@"查询数据失败...");
            } else {
//                BGYLog(@"查询数据成功...");
            }
            [searchRS close];
        
            if (finish) {
                finish([resultArr copy]);
            }
        }];
  
}

// 修改区域项目选中状态
- (void)updateProjectStatusByprojectId:(NSString *)projectId{
   
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        // 将已选中修改成未选
         NSString *projectSql = [NSString stringWithFormat: @"update t_qms_project set status=0  where status=1"];
         NSString *areaSql = [NSString stringWithFormat: @"update t_qms_area set status=0  where status=1"];
        
         NSString *projectSql2 = [NSString stringWithFormat: @"update t_qms_project set status=1  where projectId='%@'",projectId];
         NSString *areaSql2 = [NSString stringWithFormat: @"update t_qms_area set status=1  where areaId=(select areaId from t_qms_project where projectId='%@')",projectId];
        
        [fmdb executeUpdate:areaSql];
        BOOL updateRES = [fmdb executeUpdate:projectSql];
       
        if (updateRES) {
            [fmdb executeUpdate:projectSql2];
            [fmdb executeUpdate:areaSql2];
          
        }
        
       
    }];
 
}

// 修改区域项目选中状态
- (void)updateAreaProjectStatus:(NSString *)projectName{
    dispatch_async(_callQueue, ^{
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        // 将已选中修改成未选
        NSString *projectSql = [NSString stringWithFormat: @"update t_qms_project set status=0  where status=1"];
        NSString *areaSql = [NSString stringWithFormat: @"update t_qms_area set status=0  where status=1"];
        
        if ([fmdb open]) {
         
            BOOL updateRES = [fmdb executeUpdate:areaSql];
            updateRES = [fmdb executeUpdate:projectSql];
            
            if (!updateRES) {
                [fmdb close];
                NSLog(@"更新数据失败...");
                NSLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);

            } else {
                // 修改成功，再更新当前选中状态
                NSString *newprojectSql = [NSString stringWithFormat: @"update t_qms_project set status=1  where projectName='%@'",projectName];
                
                NSString *newareaSql = [NSString stringWithFormat: @"update t_qms_area set status=1  where areaId=(select areaId from t_qms_project  where projectName='%@')",projectName];
                BOOL newupdateRES = [fmdb executeUpdate:newprojectSql];
                newupdateRES = [fmdb executeUpdate:newareaSql];
                if (!updateRES) {
                    NSLog(@"更新数据失败...");
                }
                
                [fmdb close];
               
            }
        }
       
    }];
  });
}

@end


@implementation BGYDataManager (ImageCache)

- (void)selectOfflineImgList:(void (^)(NSArray <DBImageModel *> *modelArr))finish {
    NSMutableArray *modelArr = [NSMutableArray array];
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_offline_image order by createTime desc"];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            while ([searchRS next]) {
                DBImageModel *model = [[DBImageModel alloc] initWithDBResult:searchRS];
                [modelArr addObject:model];
            }
            
            if (!searchRS) {
                BGYLog(@"查询数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            } else {
                BGYLog(@"查询数据成功...");
            }
            if (finish) {
                finish([modelArr copy]);
            }
            [searchRS close];
        }];
    });
}

- (NSArray <DBImageModel *> *)selectOfflineImgList {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from t_offline_image order by createTime desc"];
        FMResultSet *searchRS = [fmdb executeQuery:selectSql];
        while ([searchRS next]) {
            DBImageModel *model = [[DBImageModel alloc] initWithDBResult:searchRS];
            [modelArr addObject:model];
        }
        
        if (!searchRS) {
            BGYLog(@"查询数据失败...");
            BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
        } else {
            BGYLog(@"查询数据成功...");
        }
        
        [searchRS close];
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return modelArr;

}


- (void)selectAllImagesDateBefore:(NSTimeInterval)createTime result:(void (^)(NSArray <DBImageModel *> *modelArr))finish {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_offline_image where createTime < %f", createTime];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            NSMutableArray *modelArr = [NSMutableArray array];
            while ([searchRS next]) {
                DBImageModel *model = [[DBImageModel alloc] initWithDBResult:searchRS];
                [modelArr addObject:model];
            }
            
            if (!searchRS) {
                BGYLog(@"查询数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            } else {
                BGYLog(@"查询数据成功...");
            }
            if (finish) {
                finish([modelArr copy]);
            }
            [searchRS close];
        }];
    });
}

- (void)clearAlImagesBefore:(NSTimeInterval)createTime result:(void (^)(NSArray <DBImageModel *> *modelArr))finish {
    dispatch_async(_callQueue, ^{
        @weakify(self);
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            @strongify(self);
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_offline_image where createTime < %f", createTime];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            NSMutableArray *modelArr = [NSMutableArray array];
            while ([searchRS next]) {
                DBImageModel *model = [[DBImageModel alloc] initWithDBResult:searchRS];
                [modelArr addObject:model];
            }
            
            if (!searchRS) {
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                if (finish) {
                    finish(nil);
                }
                return;
            } else {
                BGYLog(@"查询数据成功...");
                [self clearAlImagesBefore:createTime successBlock:^(BOOL success) {
                    if (finish) {
                        finish(success ? modelArr: nil);
                    }
                }];
            }
            [searchRS close];
        }];
    });

}
- (void)clearAlImagesBefore:(NSTimeInterval)createTime successBlock:(nullable void (^)(BOOL success))finish {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_offline_image where createTime < %f", createTime];
            BOOL deleteRS = [fmdb executeUpdate:deleteSql];
            if (!deleteRS) {
                BGYLog(@"删除数据库图片失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                if (finish) {
                    finish(NO);
                }
            } else {
                BGYLog(@"删除数据库图片成功...");
                if (finish) {
                    finish(YES);
                }
            }
        }];
    });
}

- (void)selectOfflineImgByPath:(DBImageModel *)model finish:(void (^)(DBImageModel * imageModel))finish {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_offline_image where relativePath = '%@'",model.relativePath];
            FMResultSet *searchRS = [fmdb executeQuery:selectSql];
            DBImageModel *model = [[DBImageModel alloc] initWithDBResult:searchRS];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish(model);
                }
            });
            
            if (!searchRS) {
                BGYLog(@"查询数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
            } else {
                BGYLog(@"查询数据成功...");
            }
            [searchRS close];
        }];
    });
}


- (void)insertOffineImage:(DBImageModel *)model finish:(void(^)(BOOL success, NSError *error))finishBlock {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            if ([fmdb open]) {
                NSString *insertSql = [model insertSql];
                BOOL insertRES = [fmdb executeUpdate:insertSql];
                if (!insertRES) {
                    BGYLog(@"插入数据失败...");
                    BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                    NSError *error = [NSError errorWithDomain:BGYDataManagerErrorDomain
                                                         code:[self.dataBase lastErrorCode]
                                                     userInfo:@{NSLocalizedDescriptionKey:[self.dataBase lastErrorMessage]}];
                    [fmdb close];
                    if (finishBlock) {
                        finishBlock(NO, error);
                    }
                } else {
                    BGYLog(@"插入数据成功...");
                    [fmdb close];
                    if (finishBlock) {
                        finishBlock(YES, nil);
                    }
                }
                
            }
        }];
    });
}

- (void)updateOfflineImage:(DBImageModel *)model {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *updateSql = model.updateSql;
            BOOL updateRES = [fmdb executeUpdate:updateSql];
            if (!updateRES) {
                BGYLog(@"更新数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                
            } else {
                BGYLog(@"更新数据成功...");
            }
        }];
    });
}


- (void)removeImageWithRelatePath:(NSString *)path finish:(void(^)(BOOL success, NSError *error))finishBlock {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = \"%@\"", BGYOfflineImageTableName, BGYImageRelativePath, path];
            BOOL updateRES = [fmdb executeUpdate:deleteSql];
            if (!updateRES) {
                BGYLog(@"删除数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                
            } else {
                BGYLog(@"删除数据成功...");
            }
        }];
    });
}

- (void)clearImageTable {
    dispatch_async(_callQueue, ^{
        [[[BGYDataManager shareDataManager] FMDatabaseQueue] inDatabase:^(FMDatabase *fmdb) {
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM  %@", BGYOfflineImageTableName];
            BOOL updateRES = [fmdb executeUpdate:deleteSql];
            if (!updateRES) {
                BGYLog(@"删除数据失败...");
                BGYLog(@"Error %d : %@",[self.dataBase lastErrorCode],[self.dataBase lastErrorMessage]);
                
            } else {
                BGYLog(@"删除数据成功...");
            }
        }];
    });
}



@end
