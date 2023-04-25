//
//  DBImageModel+DBExtention.h
//  BGYUni
//
//  Created by YuSong.Yan on 2021/11/17.
//

#import "DBImageModel.h"
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const BGYOfflineImageTableName = @"t_offline_image";

static NSString *const BGYImageFId = @"fid";
static NSString * const BGYImageFileName = @"fileName";
static NSString * const BGYImageRelativePath = @"relativePath";
static NSString * const BGYImageSource = @"source";
static NSString * const BGYImageAddress = @"address";
static NSString * const BGYImageCreateTime  = @"createTime";
static NSString * const BGYImageUpdateTime  = @"updateTime";
static NSString * const BGYImageTotalsize = @"totalsize";
static NSString * const BGYImageCurSize = @"curSize";

@interface DBImageModel (DBExtention)

- (instancetype)initWithDBResult:(FMResultSet *)result;

+ (NSString *)createTableSql;

- (NSString *)insertSql;

- (NSString *)updateSql;

@end

NS_ASSUME_NONNULL_END

