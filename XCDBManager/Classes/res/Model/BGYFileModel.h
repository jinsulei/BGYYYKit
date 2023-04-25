//
//  BGYFileModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGYFileModel : NSObject

@property(nonatomic ,copy) NSString *originName;
@property(nonatomic ,copy) NSString *originFile;
@property(nonatomic ,copy) NSString *dFilePath;
@property(nonatomic ,copy) NSString *materialName;
@property(nonatomic ,copy) NSString *materialId;
@property(nonatomic ,copy) NSString *hashKey;
@property(nonatomic ,copy) NSString *obj1;
@property(nonatomic ,copy) NSString *obj2;

@property(nonatomic ,copy) NSString *fileId;
@property(nonatomic ,copy) NSString *filePath;
@property(nonatomic ,copy) NSString *contentType;
@property(nonatomic ,copy) NSString *fileSize;

@end

NS_ASSUME_NONNULL_END
