//
//  BGYPhotoModel.h
//  BGYUni
//
//  Created by YuSong.Yan on 2022/3/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

static NSString *const BGYPhotoModelTableName = @"BGYPhotoModel_image";

@interface BGYPhotoModel : NSObject

///文件名
@property(nonatomic, copy) NSString* fileName;

///存储相对路径
@property(nonatomic, copy) NSString* relativePath;

///拍照位置
@property(nonatomic, copy) NSString* address;

///最后修改时间
@property(nonatomic, assign) NSTimeInterval updateTime;

//文件大小bt
@property(nonatomic, assign) NSUInteger totalsize;


///所属分类
@property(nonatomic, assign) NSInteger categoryId;

///图片
@property(nonatomic, strong, nullable) UIImage *image;


///绝对路径
@property (readonly, nonatomic) NSString *absolutePath;

///图片备注信息
@property(nonatomic, copy, nullable) NSString* markText;

+ (NSString *)cachedRoorDir;

- (NSString *)thumbFileName;
- (NSString *)thumbFileAbsolutePath;

- (NSDictionary *)generateUniData;

@end

NS_ASSUME_NONNULL_END
