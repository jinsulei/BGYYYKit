//
//  DBImageModel+DBExtention.m
//  BGYUni
//
//  Created by YuSong.Yan on 2021/11/17.
//

#import "DBImageModel+DBExtention.h"


@implementation DBImageModel (DBExtention)

- (instancetype)initWithDBResult:(FMResultSet *)result {
    self = [super init];
    if (self) {
        self.fileName      = [result stringForColumn:BGYImageFileName];
        self.relativePath      = [result stringForColumn:BGYImageRelativePath];
        self.address       = [result stringForColumn:BGYImageAddress];
        self.createTime    = [result doubleForColumn:BGYImageCreateTime];
        self.updateTime    = [result doubleForColumn:BGYImageUpdateTime];
        self.fid           = [result stringForColumn:BGYImageFId];
        self.totalsize     = [result doubleForColumn:BGYImageTotalsize];
        self.curSize       = [result doubleForColumn:BGYImageCurSize];
        self.source          = [result intForColumn:BGYImageSource];
    }
    return self;

}

+ (NSString *)createTableSql {
    NSString *tableCulom = @"create table if not exists t_offline_image (relativePath unique, \
    fileName text,\
    address text,\
    createTime double, \
    updateTime double, \
    fid text, \
    source int, \
    totalsize float,\
    cursize float)";
    return tableCulom;
}

- (NSString *)insertSql {
    NSString *insertSql = [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@','%@', %@, %@,'%@','%@','%@','%@','%@') VALUES ('%@','%@', '%@', %f, %f,'%@', %f, %f, %d)",
                           BGYOfflineImageTableName,
                           BGYImageRelativePath,
                           BGYImageFileName,
                           BGYImageAddress,
                           BGYImageCreateTime,
                           BGYImageUpdateTime,
                           BGYImageFId,
                           BGYImageTotalsize,
                           BGYImageCurSize,
                           BGYImageSource,
                           
                           self.relativePath,
                           self.fileName,
                           self.address,
                           self.createTime,
                           self.updateTime,
                           self.fid,
                           self.totalsize,
                           self.curSize,
                           self.source
                         ];
    return insertSql;
}

- (NSString *)updateSql {
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = \"%@\", %@ = %d, %@ = %f, %@ = \"%@\" , %@ = %f, %@ = %f, %@ = %f WHERE %@ = \"%@\"",BGYOfflineImageTableName,
                           BGYImageFId, self.fid,
                           BGYImageSource, self.source,
                           BGYImageUpdateTime, self.updateTime,
                           BGYImageAddress, self.address,
                           BGYImageTotalsize, self.totalsize,
                           BGYImageCurSize,  self.curSize,
                           BGYImageCreateTime, self.createTime,
                           BGYImageRelativePath, self.relativePath];
    
    
    return updateSql;
}




@end
