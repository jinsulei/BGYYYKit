//
//  DBImageModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DBImageModel : NSObject

@property(nonatomic, copy) NSString *fileName;
@property(nonatomic, copy) NSString *relativePath;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) NSTimeInterval createTime;
@property(nonatomic, assign) NSTimeInterval updateTime;
@property(nonatomic, copy) NSString *fid;
@property(nonatomic, assign) float totalsize;
@property(nonatomic, assign) float curSize;
@property(nonatomic, assign) int32_t source;


@property (strong, nonatomic, nullable) UIImage *image;
@property (readonly, nonatomic) NSString *absolutePath;

+ (NSString *)cachedRoorDir;


- (NSString *)thumbFileName;
- (NSString *)thumbFileAbsolutePath;

- (NSDictionary *)generateUniData;

@end

NS_ASSUME_NONNULL_END
