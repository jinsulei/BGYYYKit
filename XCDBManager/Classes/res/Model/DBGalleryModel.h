//
//  DBGalleryModel.h
//  BGYUni
//
//  Created by lshenrong on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBGalleryModel : NSObject

@property(nonatomic ,copy) NSString *fileId;
@property(nonatomic ,copy) NSString *fileSize;
@property(nonatomic ,copy) NSString *fileName;
@property(nonatomic ,copy) NSString *thumbFile;
@property(nonatomic ,copy) NSString *previewFile;
@property(nonatomic ,copy) NSString *originFile;
@property(nonatomic ,copy) NSString *update_time;

@end

NS_ASSUME_NONNULL_END
