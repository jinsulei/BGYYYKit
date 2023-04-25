//
//  DBFileMode.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBFileModel : NSObject

///文件缓存，相对路径
@property(nonatomic ,copy) NSString *localPath;

///文件名
@property(nonatomic ,copy) NSString *fileName;

//文件id，来源于服务器
@property(nonatomic ,copy) NSString *fileId;

//文件大小
@property(nonatomic ,copy) NSString *fileSize;

//文件来源类型
@property(nonatomic ,copy) NSString *contentType;

//创建时间
@property(nonatomic ,copy) NSString *create_time;

//更新时间
@property(nonatomic ,copy) NSString *update_time;

@end

NS_ASSUME_NONNULL_END
